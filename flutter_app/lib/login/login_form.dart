import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/login/bloc/login_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:flutter_app/model/api_model.dart';

final _base = "https://notifyme69.herokuapp.com";
final _tokenEndpoint = "/api/register/app/";
final _tokenURL = _base + _tokenEndpoint;

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      BlocProvider.of<LoginBloc>(context).add(LoginButtonPressed(
        username: _usernameController.text,
        password: _passwordController.text,
      ));
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFaliure) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('Login Unsuccessful'),
            backgroundColor: Colors.red,
          ));
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return Container(
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
                          labelText: 'password', icon: Icon(Icons.security)),
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.22,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: RaisedButton(
                          onPressed: state is! LoginLoading
                              ? _onLoginButtonPressed
                              : null,
                          child: Text(
                            'Login',
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
                    Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      height: MediaQuery.of(context).size.width * 0.22,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: RaisedButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 24.0,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SecondRoute()),
                            );
                          },
                          shape: StadiumBorder(
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      child: state is LoginLoading
                          ? CircularProgressIndicator()
                          : null,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SecondRoute extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _password2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> fun() {
      Map<String, dynamic> toDatabaseJson() => {
            "email": _emailController.text,
            "username": _usernameController.text,
            "password": _passwordController.text,
            "password2": _password2Controller.text,
          };
      return toDatabaseJson();
    }

    Future getToken(BuildContext context) async {
      print(_tokenURL);
      print(jsonEncode(fun()));
      print("kokoko");
      final http.Response response = await http.post(
        _tokenURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          //'Accept': 'application/json;',
          //'Authorization': '<Your token>',
          'Connection': 'Keep-Alive',
          'Keep-Alive': 'timeout=5, max=1000',
          'Accept-Encoding': 'gzip, deflate, br',
          'Accept': '*/*',
          "Vary": "Accept",
          "Allow": "OPTIONS,POST",
          "X-Frame-Options": "DENY",
          "X-Content-Type-Options": "nosniff",
          "Referrer-Policy": "same-origin",
          "Via": "1.1 vegur",
        },
        body: jsonEncode(fun()),
      );
      print("uuuuuuuu");
      print(response.body);
      print("asd");

      if (response.body == '{"response":"Success"}') {
        print("suc");
        final snackBar = SnackBar(
          content: Text('Registration Successful'),
          backgroundColor: Colors.green,
        );
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        print("unsuc");
        // ignore: deprecated_member_use
        final snackBar = SnackBar(
          content: Text('Registration Unsuccessful'),
          backgroundColor: Colors.red,
        );
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }

    _onsignupButtonPressed(BuildContext context) {
      getToken(context);
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Login'),
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
                      labelText: 'email', icon: Icon(Icons.person)),
                  controller: _emailController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'password', icon: Icon(Icons.security)),
                  controller: _passwordController,
                  obscureText: true,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'confirm password',
                      icon: Icon(Icons.security)),
                  controller: _password2Controller,
                  obscureText: true,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: MediaQuery.of(context).size.width * 0.17,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: RaisedButton(
                      onPressed: () {
                        _onsignupButtonPressed(context);
                      },
                      child: Text(
                        'Register',
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
