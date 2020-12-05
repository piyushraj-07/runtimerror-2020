import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/model/api_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/bloc/authentication_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_app/globals.dart' as globals;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

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

  Future<List> getdata() async {
    String lop = 'https://notifyme69.herokuapp.com/api/get_courses/';
    String tpp = "Token " + globals.tokun;
    String pqww = globals.usern;
    String po = '{"username":"$pqww"}';
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
      List a = response.body.split('[');
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
      // ignore: deprecated_member_use
      return Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Registration Successful'),
        backgroundColor: Colors.red,
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
        // final snackbar = SnackBar(
        //   content: Text(message['notification']['title']),
        //   action: SnackBarAction(
        //     label: 'Go',
        //     onPressed: () => null,
        //   ),
        // );

        // Scaffold.of(context).showSnackBar(snackbar);
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
      //trailing: Icon(alreadySaved ? Icons.favorite : Icons.favorite_border,
      //    color: alreadySaved ? Colors.red : null),
      //onTap: () {
      //setState(() {
      // if (alreadySaved) {
      //  _savedWordPairs.remove(pair);
      //} else {
      //  _savedWordPairs.add(pair);
      //}
      //});
    );
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
          RaisedButton(
            child: Text(
              'Logout',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            onPressed: () {
              //print(globals.usern);
              //print(globals.tokun);
              BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
            },
            shape: StadiumBorder(
              side: BorderSide(
                color: Colors.black,
                width: 2,
              ),
            ),
          )
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
                    setState(() {});
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
  _subscribeToTopic() async {
    // Subscribe the user to a topic
    _fcm.subscribeToTopic('all');
  }
}
