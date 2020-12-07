import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//import 'package:notiflyer/model/api_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notiflyer/bloc/authentication_bloc.dart';
// ignore: unused_import
import 'package:flutter_dnd/flutter_dnd.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter/material.dart';
import 'package:notiflyer/globals.dart' as globals;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sound_mode/sound_mode.dart';
// ignore: unused_import
import 'package:sound_mode/utils/sound_profiles.dart';
//import 'package:sound_mode/utils/sound_profiles.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
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

class _MessageHandlerState extends State<MessageHandler> {
  List corlist;
  void ter() {
    print(globals.usern);
    print(globals.tokun);
  }

  // ignore: non_constant_identifier_names
  log_out() async {
    String lop = 'https://notifyme69.herokuapp.com/api/logout/';
    String tpp = "Token " + globals.tokun;
    String pqww = globals.usern;
    String po = '{"username":"$pqww"}';
    // ignore: unused_local_variable
    final http.Response response = await http.post(
      lop,
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        //'Vary': 'Accept',
        //'WWW-Authenticate': globals.tokun,
        'Authorization': tpp,
      },
      body: po,
    );
  }

  Future<List> getdata() async {
    if (globals.tokun == "") {
      log_out();
      BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
      return [];
    }
    String ringerStatus = await SoundMode.ringerModeStatus;
    print(ringerStatus);

    String lop = 'https://notifyme69.herokuapp.com/api/get_courses/';
    String tpp = "Token " + globals.tokun;
    String pqww = globals.usern;
    String tokwen = await _fcm.getToken();
    String po = '{"username":"$pqww","fcmtoken":"$tokwen"}';
    print(po);
    print(tpp);
    final http.Response response = await http.post(
      lop,
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        //'Vary': 'Accept',
        //'WWW-Authenticate': globals.tokun,
        'Authorization': tpp,
      },
      body: po,
    );
    if (response.statusCode == 200) {
      print("holo");
      //var data = json.decode(response.body) as List;
      //print(data);
      String ss = response.body.replaceAll("\"", "");
      List a = ss.split('[');
      //print(a);
      List b = a[1].split(']');
      List lists = b[0].split(',');
      //print(lists);
      //print(response.body);
      //print(json.decode(response.body));
      return lists;
    } else {
      print("nolo");
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
  }

  Future temp() async {
    corlist = await getdata();
    return (corlist);
    //  return p;
  }

  Future adcourse() async {
    String yop = "https://notifyme69.herokuapp.com/api/join_course/";
    String tpp = "Token " + globals.tokun;
    String pqww = globals.usern;
    String gggg = _coursecodeController.text;
    String pouu = '{"username":"$pqww","code":"$gggg"}';
    final http.Response susponse = await http.post(
      yop,
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        //'Vary': 'Accept',
        //'WWW-Authenticate': globals.tokun,
        'Authorization': tpp,
      },
      body: pouu,
    );
    print(susponse.body);
    if (susponse.body == '{"response":"success"}') {
      print("suc");
      setState(() {});
      // ignore: deprecated_member_use
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Registration Successful'),
        backgroundColor: Colors.green,
      ));
    } else {
      print("unsuc");
      // ignore: deprecated_member_use
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Registration Unsuccessfull'),
        backgroundColor: Colors.red,
      ));
    }
  }

  final FirebaseMessaging _fcm = FirebaseMessaging();
  final _coursecodeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _saveDeviceToken();
    ter();

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        String md = message['data']['value'];
        if ("$md" == "false") {
          final snackbar = SnackBar(
            content: Text(message['notification']['title']),
            action: SnackBarAction(
              label: 'Go',
              onPressed: () => null,
            ),
          );

          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(snackbar);
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  color: Colors.amber,
                  child: Text('Ok'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          );
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Widget _buildRow(String pair) {
    //final alreadySaved = _savedWordPairs.contains(pair);

    return ListTile(
        title: Text(pair, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(Icons.arrow_right_alt),
        onTap: () {
          globals.cours = pair;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
        });
  }

  Widget tuildlist() {
    return FutureBuilder(
      future: temp(),
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
            return _buildRow(project);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
        onPressed: () {
          Alert(
              context: context,
              title: "Add a Course",
              content: Column(
                children: <Widget>[
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
    switch (value) {
      case 'Logout':
        {
          log_out();
          BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
          break;
        }
      case 'Change Password':
        {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FourthRoute()),
          );
          print("chanef");
          break;
        }
    }
  }

  /// Get the token, save it to the database for current user
  _saveDeviceToken() async {
    // Get the current user
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();
    print(fcmToken);
    // Save it to Firestore
  }

  /// Subscribe the user to a topic

}

class SecondRoute extends StatelessWidget {
  @override
  // ignore: override_on_non_overriding_member
  Future getcdat() async {
    String sez = 'https://notifyme69.herokuapp.com/api/get_notifs/';
    String secC = "Token " + globals.tokun;
    String cors = globals.cours;
    //String pqww = globals.usern;
    String po = '{"course":"$cors"}';
    print(po);
    //print(tpp);
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        //'Vary': 'Accept',
        //'WWW-Authenticate': globals.tokun,
        'Authorization': secC,
      },
      body: po,
    );
    if (response.statusCode == 200) {
      print("holo");
      var data = json.decode(response.body);
      //print(data);
      print(response.body);
      List a = data["title"];
      print(a);
      globals.notpr = data["priority"];
      //List b = a[1].split(']');
      //List lists = b[0].split(',');
      //print(lists);
      //print(response.body);
      //print(json.decode(response.body));
      return a;
    } else {
      print("nolo");
      print(json.decode(response.body).toString());
      throw Exception(json.decode(response.body));
    }
  }

  Widget _kildRow(BuildContext context, String pair, int numb) {
    //final alreadySaved = _savedWordPairs.contains(pair);
    pair = pair.replaceAll("\"", "");
    if (globals.notpr[numb]) {
      return ListTile(
          title: Text(pair, style: TextStyle(fontSize: 18.0)),
          leading: Icon(Icons.priority_high_sharp),
          trailing: Icon(Icons.arrow_right_alt),
          onTap: () {
            globals.notidet = pair;
            globals.notinum = numb;
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThirdRoute()),
            );
          });
    }
    return ListTile(
        title: Text(pair, style: TextStyle(fontSize: 18.0)),
        trailing: Icon(Icons.arrow_right_alt),
        onTap: () {
          globals.notidet = pair;
          globals.notinum = numb;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ThirdRoute()),
          );
        });
  }

  Widget notigbuild() {
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

class ThirdRoute extends StatelessWidget {
  @override
  // ignore: override_on_non_overriding_member
  Future getcdat() async {
    String sez = 'https://notifyme69.herokuapp.com/api/get_notif_details/';
    String secC = "Token " + globals.tokun;
    int cors = globals.notinum;
    String coursename = globals.cours;
    String pqww = globals.usern;
    String po = '{"id":"$cors","course":"$coursename","username":"$pqww"}';
    print(po);
    //print(tpp);
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        //'Vary': 'Accept',
        //'WWW-Authenticate': globals.tokun,
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
      print(a);
      return a;
    } else {
      print("nolo");
      //print(json.decode(response.body).toString());
      //throw Exception(json.decode(response.body));
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
            String project = projectSnap.data[index];
            return _kildRow(context, project);
          },
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: notigbuild(),
    );
  }
}

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
    String sez = 'https://notifyme69.herokuapp.com/api/changepassword/';
    String secC = "Token " + globals.tokun;
    //print(tpp);
    print(fun());
    final http.Response response = await http.post(
      sez,
      headers: <String, String>{
        //'Content-Type': 'application/json; charset=UTF-8',
        //'Vary': 'Accept',
        //'WWW-Authenticate': globals.tokun,
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
