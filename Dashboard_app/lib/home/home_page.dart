import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:dashboard_app/model/api_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dashboard_app/bloc/authentication_bloc.dart';
// ignore: unused_import
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/material.dart';
import 'package:dashboard_app/globals.dart' as globals;
import 'package:rflutter_alert/rflutter_alert.dart';
//import 'package:sound_mode/sound_mode.dart';
// ignore: unused_import
import 'package:sound_mode/utils/sound_profiles.dart';
//import 'package:sound_mode/utils/sound_profiles.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        brightness: Brightness.light,
      ),
      title: 'FlutterBase',
      home: Scaffold(
        body: MessageHandler(),
      ),
    );
  }
}

class MessageHandler extends StatefulWidget {
  @override
  _MessageHandlerState createState() => _MessageHandlerState();
}

//contains build for initial home page consisting of list of courses, adding a course option
//and dropdown list for logout and change password option
//contains post request for getting list of courses, removing fcmtoken from db on logout, adding a course

class _MessageHandlerState extends State<MessageHandler> {
  List corlist;
  void ter() {
    print(globals.usern);
    print(globals.tokun);
  }

  Future<List> getdata() async {
    //post request for getting list of course
    if (globals.tokun == "") {
      BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
      return [];
    }
    String lop = 'https://notifyme69.herokuapp.com/api/inst/get_courses/';
    String tpp = "Token " + globals.tokun;
    String pqww = globals.usern;
    String po = '{"username":"$pqww"}';
    print(po);
    print(tpp);
    final http.Response response = await http.post(
      lop,
      headers: <String, String>{
        'Authorization': tpp,
      },
      body: po,
    );
    if (response.statusCode == 200) {
      print("holo");
      String ss = response.body.replaceAll("\"", "");
      List a = ss.split('[');
      List b = a[1].split(']');
      List lists = b[0].split(',');
      return lists;
    } else {
      print("nolo");
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
  }

  Future temp() async {
    //temp() used as future in futurebuilder that returns the list of courses
    corlist = await getdata();
    return (corlist);
    //  return p;
  }

  Future adcourse() async {
    //post request for adding a course
    String yop = "https://notifyme69.herokuapp.com/api/add_course/";
    String tpp = "Token " + globals.tokun;
    String pqww = globals.usern;
    String gggg = _coursecodeController.text;
    String coursnmae = _coursenameController.text;
    String pouu = '{"username":"$pqww","code":"$gggg","course":"$coursnmae"}';
    final http.Response susponse = await http.post(
      yop,
      headers: <String, String>{
        'Authorization': tpp,
      },
      body: pouu,
    );
    print(susponse.body);
    if (susponse.body == '{"response":"Success"}') {
      print("suc");
      setState(() {});
      // ignore: deprecated_member_use
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Course Added Successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      print("unsuc");
      // ignore: deprecated_member_use
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Course Not Added'),
        backgroundColor: Colors.red,
      ));
    }
  }

  final _coursecodeController = TextEditingController();
  final _coursenameController = TextEditingController();
  @override
  void initState() {
    super.initState();
    ter();
  }

  Widget _buildRow(String pair) {
    //builds list of courses
    return ListTile(
        title: Text(pair, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(Icons.arrow_right_alt),
        onTap: () {
          globals.cours = pair;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Onepointfive()), //rediction to course details page
          );
        });
  }

  Widget tuildlist() {
    //actual build  of list of courses
    return FutureBuilder(
      future: temp(),
      builder: (context, projectSnap) {
        if (projectSnap.hasData == null ||
            projectSnap.connectionState == ConnectionState.waiting ||
            projectSnap.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            if (projectSnap.data[0] == "") {
              print("dadadadada");
              return Container();
            }
            String project = projectSnap.data[index];
            return _buildRow(project);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    //build of initial home page with dropdown list in app bar
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Change Password', 'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: tuildlist(),
      floatingActionButton: FloatingActionButton(
        //add a course by instructor button
        onPressed: () {
          Alert(
              context: context,
              title: "Add a Course",
              content: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.queue),
                      labelText: 'Course Name',
                    ),
                    controller: _coursenameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.queue),
                      labelText: 'Course Code',
                    ),
                    controller: _coursecodeController,
                  ),
                ],
              ),
              buttons: [
                DialogButton(
                  onPressed: () {
                    adcourse();

                    //Navigator.pop(context);
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              ]).show();
        },
        //tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void handleClick(String value) {
    //handles click on dropdown list
    switch (value) {
      case 'Logout':
        {
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          break;
        }
      case 'Change Password':
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    FourthRoute()), //redirection to change password page
          );
          print("chanef");
          break;
        }
    }
  }
}

class Onepointfive extends StatefulWidget {
  @override
  _MsageHandlerState createState() => _MsageHandlerState();
}

//extension of OnePointFive that contains the build of send notification form along with dropdown
//list consisting of Previous Notifications, TA's, Students enrolled - page routing
//contains post request for sending notification

class _MsageHandlerState extends State<Onepointfive> {
  @override
  // ignore: override_on_non_overriding_member
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  BuildContext globcont;
  Map<String, dynamic> fun() {
    String flagg = "Soft";
    if (isSwitched) {
      flagg = "Hard";
    }
    Map<String, dynamic> toDatabaseJson() => {
          "username": globals.usern,
          "title": _titleController.text,
          "content": _contentController.text,
          "course": globals.cours,
          "flag": flagg,
        };
    return toDatabaseJson();
  }

  Future _notif(BuildContext context) async {
    //post request to send notification
    String sez = 'https://notifyme69.herokuapp.com/api/send_notif/';
    String secC = "Token " + globals.tokun;
    //print(tpp);
    print(fun());
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        'Authorization': secC,
      },
      body: jsonEncode(fun()),
    );
    final snackBar = SnackBar(
      content: Text('Notification Sent Successfully'),
      backgroundColor: Colors.green,
    );
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(snackBar);
    print(response.body);
    if (response.statusCode == 200) {
      print("suc");
    } else {
      print("unsuc");
      // ignore: deprecated_member_use
    }
  }

  bool isSwitched = false;
  Widget build(BuildContext context) {
    globcont = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Send Notification'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              //dropdown list to go to the page containg respective lists
              return {'Previous Notifications', 'Students Enrolled', 'TA\'s'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: (Container(
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'title', icon: Icon(Icons.book)),
                  controller: _titleController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'content', icon: Icon(Icons.book_online)),
                  controller: _contentController,
                ),
                SwitchListTile(
                  value: isSwitched,
                  title: new Text('High Priority',
                      style: new TextStyle(color: Colors.grey)),
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.17,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: RaisedButton(
                      onPressed: () {
                        _notif(context);
                      },
                      child: Text(
                        'Send Notification',
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void handleClick(String value) {
    switch (value) {
      case 'Students Enrolled':
        {
          Navigator.push(
            globcont,
            MaterialPageRoute(
                builder: (context) =>
                    Studentlist()), //routing to student list page
          );
          break;
        }
      case 'TA\'s':
        {
          Navigator.push(
            globcont,
            MaterialPageRoute(
                builder: (context) => FifthRoute()), //routing to TA list page
          );
          print("chanef");
          break;
        }
      case 'Previous Notifications':
        {
          Navigator.push(
            globcont,
            MaterialPageRoute(
                builder: (context) =>
                    SecondRoute()), //routing to list of notif page
          );
          break;
        }
    }
  }
}

class Studentlist extends StatefulWidget {
  @override
  _MeeHandlerState createState() => _MeeHandlerState();
}

//extension of StudentList class to display list to students on clicking Students enrolled option
//in dropdown list (gets student list by post request)
//contains option to remove student on clicking the list tile

class _MeeHandlerState extends State<Studentlist> {
  @override
  // ignore: override_on_non_overriding_member
  Future getcdat() async {
    //post request for getting list of students
    String sez = 'https://notifyme69.herokuapp.com/api/getStudents/';
    String secC = "Token " + globals.tokun;
    String cors = globals.cours;
    String po = '{"course":"$cors"}';
    print(po);
    //print(tpp);
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        'Authorization': secC,
      },
      body: po,
    );
    if (response.statusCode == 200) {
      print("holo");
      print(response.body);
      List a = response.body.split('[');
      print(a);
      List b = a[1].split(']');
      List lists = b[0].split(',');
      print(lists);
      return lists;
    } else {
      print("nolo");
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
  }

  Future removestud(BuildContext context) async {
    //post request to remove student (permission on instructor)
    String sez = 'https://notifyme69.herokuapp.com/api/removestudent/';
    String secC = "Token " + globals.tokun;
    String cors = globals.cours;
    String pqww = globals.stud;
    String po = '{"course":"$cors","username":"$pqww"}';
    print(po);
    //print(tpp);
    final http.Response susponse = await http.post(
      sez,
      headers: <String, String>{
        'Authorization': secC,
      },
      body: po,
    );
    if (susponse.statusCode == 200) {
      print("suc");
      setState(() {});
      // ignore: deprecated_member_use
      return "";
    } else {
      print("unsuc");
      // ignore: deprecated_member_use
      return "";
    }
  }

  Future<void> _showMyDialog() async {
    //dialog box to take confirmation from instructor
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext wecontext) {
        return AlertDialog(
          title: Text('Remove this student'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('click OK to confirm'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('OK'),
              onPressed: () {
                removestud(context);
                Navigator.of(wecontext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> deny() async {
    //deny permission to remove student is user is a TA
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext wecontext) {
        return AlertDialog(
          title: Text('PERMISSION DENIED'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You do not have permission to remove a student'),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('Go Back'),
              onPressed: () {
                Navigator.of(wecontext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _kildRow(BuildContext context, String pair, int numb) {
    //build list tile to show student name with remove icon button
    pair = pair.replaceAll("\"", "");
    return ListTile(
        title: Text(pair, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(Icons.remove_circle),
        onTap: () {
          globals.stud = pair;
          if (globals.isTa) {
            deny();
          } else {
            _showMyDialog();
          }
        });
  }

  Widget notigbuild() {
    //actual build of list of futurebuilder
    return FutureBuilder(
      future: getcdat(),
      builder: (context, projectSnap) {
        if (projectSnap.hasData == null ||
            projectSnap.connectionState == ConnectionState.waiting ||
            projectSnap.connectionState == ConnectionState.none) {
          //print('project snapshot data is: ${projectSnap.data}');
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            if (projectSnap.data[0] == "") {
              print("dadadadada");
              return Container();
            }
            String project = projectSnap.data[index];
            return _kildRow(context, project, index);
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
      ),
      body: notigbuild(),
    );
  }
}

//SecondRoute contains build of list of previous notifications of a particular course
//displayed on clicking previous notification option in dropdown list
//contains post request for getting list of notification
//on clicking the notification, redirected to ThirdRoute conatining notif details

class SecondRoute extends StatelessWidget {
  @override
  // ignore: override_on_non_overriding_member
  Future getcdat() async {
    String sez = 'https://notifyme69.herokuapp.com/api/inst/get_notifs/';
    String secC = "Token " + globals.tokun;
    String cors = globals.cours;
    //String pqww = globals.usern;
    String po = '{"course":"$cors"}';
    print(po);
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        'Authorization': secC,
      },
      body: po,
    );
    if (response.statusCode == 200) {
      print("holo");
      print(response.body);
      List a = response.body.split('[');
      print(a);
      List b = a[1].split(']');
      List lists = b[0].split(',');
      print(lists);
      return lists;
    } else {
      print("nolo");
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
  }

  Widget _kildRow(BuildContext context, String pair, int numb) {
    //build of list tile containing notif title
    pair = pair.replaceAll("\"", "");
    return ListTile(
        title: Text(pair, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(Icons.arrow_right_alt),
        onTap: () {
          globals.notidet = pair;
          globals.notinum = numb;
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ThirdRoute()), //redirected to notif detail page
          );
        });
  }

  Widget notigbuild() {
    //actual build of notif list using future builder
    return FutureBuilder(
      future: getcdat(),
      builder: (context, projectSnap) {
        if (projectSnap.hasData == null ||
            projectSnap.connectionState == ConnectionState.waiting ||
            projectSnap.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            String project = projectSnap.data[index];
            return _kildRow(context, project, index);
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: notigbuild(),
    );
  }
}

//ThirdRoute contains build for displaying list of students who have seen a particular notification
//On clicking info button in app bar, redirects to notification details page (ThreepointFive Route)

class ThirdRoute extends StatelessWidget {
  @override
  // ignore: override_on_non_overriding_member
  Future getcdat() async {
    //post request for getting notification details
    String sez = 'https://notifyme69.herokuapp.com/api/inst/get_notif_details/';
    String secC = "Token " + globals.tokun;
    String coursename = globals.cours;
    String pqww = globals.notidet;
    String po = '{"course":"$coursename","name":"$pqww"}';
    print(po);
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        'Authorization': secC,
      },
      body: po,
    );
    if (response.statusCode == 200) {
      print("holo");
      var jsonData = response.body;
      var parsedJson = json.decode('$jsonData');
      print(parsedJson);
      List a = [];
      a.add(parsedJson["title"]);
      a.add(parsedJson["content"]);
      a.add(parsedJson["sender"]);
      a.add(parsedJson["time"]);
      globals.seenstuds = a;
      print(a);
      print(globals.seenstuds);
      return parsedJson["read"];
    } else {
      print("nolo");
      return [];
    }
  }

  Widget _kildRow(BuildContext context, String pair) {
    //final alreadySaved = _savedWordPairs.contains(pair);
    pair = pair.replaceAll("\"", "");
    return ListTile(
      title: Text(pair, style: TextStyle(fontSize: 18.0)),
    );
  }

  Widget notigbuild() {
    //actual build of notif details page using list tiles
    return FutureBuilder(
      future: getcdat(),
      builder: (context, projectSnap) {
        if (projectSnap.hasData == null ||
            projectSnap.connectionState == ConnectionState.waiting ||
            projectSnap.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            String project = projectSnap.data[index];
            return _kildRow(context, project);
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Acknowledged by'), actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.info),
          tooltip: 'Show Notif Details',
          onPressed: () {
            Navigator.push(
              //redirects to notif detail page on clicking info icon
              context,
              MaterialPageRoute(builder: (context) => ThreepointfiveRoute()),
            );
          },
        ),
      ]),
      body: notigbuild(),
    );
  }
}

//ThirdpontfiveRoute contains build of notification details of a particular notification
//contains details like sent by, time, title, content

class ThreepointfiveRoute extends StatelessWidget {
  // ignore: override_on_non_overriding_member

  Widget _kildRow(BuildContext context, String pair) {
    pair = pair.replaceAll("\"", "");
    return ListTile(
      title: Text(pair, style: TextStyle(fontSize: 18.0)),
    );
  }

  Widget notigbuild() {
    return Builder(
      builder: (context) {
        return ListView.builder(
          itemCount: globals.seenstuds.length,
          itemBuilder: (context, index) {
            String project = globals.seenstuds[index];
            return _kildRow(context, project);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: notigbuild(),
    );
  }
}

//FourthRoute conatins build of change password page along with post request

class FourthRoute extends StatelessWidget {
  @override
  // ignore: override_on_non_overriding_member
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _oldpasswordController = TextEditingController();
  final _newpasswordController = TextEditingController();
  Map<String, dynamic> fun() {
    Map<String, dynamic> toDatabaseJson() => {
          "username": _usernameController.text,
          "oldpassword": _oldpasswordController.text,
          "newpassword": _newpasswordController.text,
        };
    return toDatabaseJson();
  }

  Future _changepassword(BuildContext context) async {
    //post request to change password
    String sez = 'https://notifyme69.herokuapp.com/api/changepassword/';
    String secC = "Token " + globals.tokun;
    //print(tpp);
    print(fun());
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        'Authorization': secC,
      },
      body: jsonEncode(fun()),
    );
    print(response.body);
    if (response.body != '{"response":"Fail"}') {
      print("suc");
      print(globals.tokun);
      var tokan = jsonDecode(response.body);
      globals.tokun = tokan["token"];
      print(response.body);
      print(globals.tokun);
      final snackBar = SnackBar(
        content: Text('Password Changed Successfully'),
        backgroundColor: Colors.green,
      );
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(snackBar);
    } else {
      print("unsuc");
      // ignore: deprecated_member_use
      final snackBar = SnackBar(
        content: Text('Enter Correct Username/Password'),
        backgroundColor: Colors.red,
      );
      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(snackBar);
    }
  }

  Widget build(BuildContext context) {
    //build of change password form
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: (Container(
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'username', icon: Icon(Icons.person)),
                  controller: _usernameController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'old password', icon: Icon(Icons.security)),
                  controller: _oldpasswordController,
                  obscureText: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'new password', icon: Icon(Icons.security)),
                  controller: _newpasswordController,
                  obscureText: true,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.17,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: RaisedButton(
                      onPressed: () {
                        _changepassword(context);
                      },
                      child: Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 24.0,
                        ),
                      ),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class FifthRoute extends StatefulWidget {
  @override
  _MessaHandlerState createState() => _MessaHandlerState();
}

//extension of FifthRoute, displays list of TA's of a course
//conatins post request to get list of TA's, also contains option
//to add a TA along with it's post request

class _MessaHandlerState extends State<FifthRoute> {
  @override
  // ignore: override_on_non_overriding_member
  final _taController = TextEditingController();
  Future getcdat() async {
    //post request to get list of TA's
    //post request to get TA list
    String sez = 'https://notifyme69.herokuapp.com/api/getTas/';
    String secC = "Token " + globals.tokun;
    String cors = globals.cours;
    String po = '{"course":"$cors"}';
    print(po);
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        'Authorization': secC,
      },
      body: po,
    );
    print(response.body);
    if (response.statusCode == 200) {
      print("holo");
      print(response.body);
      List a = response.body.split('[');
      print(a);
      List b = a[1].split(']');
      List lists = b[0].split(',');
      print(lists);
      return lists;
    } else {
      print("nolo");
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
  }

  Widget _kildRow(BuildContext context, String pair) {
    pair = pair.replaceAll("\"", "");
    return ListTile(
      title: Text(pair, style: TextStyle(fontSize: 18.0)),
    );
  }

  Widget notigbuild() {
    //actual build of list of TA's
    return FutureBuilder(
      future: getcdat(),
      builder: (context, projectSnap) {
        if (projectSnap.hasData == null ||
            projectSnap.connectionState == ConnectionState.waiting ||
            projectSnap.connectionState == ConnectionState.none) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            if (projectSnap.data[0] == "") {
              print("dadadadada");
              return Container();
            }
            String project = projectSnap.data[index];
            return _kildRow(context, project);
          },
        );
      },
    );
  }

  Future addtafinal(BuildContext context) async {
    //post request to add a TA on pressing floating action button
    String yop = "https://notifyme69.herokuapp.com/api/addTa/";
    String tpp = "Token " + globals.tokun;
    String pqww = globals.cours;
    String tanmae = _taController.text;
    String pouu = '{"username":"$tanmae","course":"$pqww"}';
    print(pouu);
    final http.Response susponse = await http.post(
      yop,
      headers: <String, String>{
        'Authorization': tpp,
      },
      body: pouu,
    );
    print(susponse.body);
    if (susponse.body == '"Success"') {
      print("suc");
      // ignore: deprecated_member_use
      setState(() {});
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('TA Added Successfully'),
        backgroundColor: Colors.green,
      ));
    } else {
      print("unsuc");
      // ignore: deprecated_member_use
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('TA Not found'),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> addata(BuildContext context) async {
    //add TA dialog box with text input form
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext wecontext) {
        return AlertDialog(
          title: Text('Add a TA'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.person_add),
                    labelText: 'TA Name',
                  ),
                  controller: _taController,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              child: Text('ADD'),
              onPressed: () {
                addtafinal(wecontext);
                Navigator.of(wecontext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of TA\'s'),
      ),
      body: notigbuild(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //alert dialog on pressing add button that takes TA name as input
          addata(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
