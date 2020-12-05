import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_app/login/bloc/login_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_app/model/api_model.dart';

final _base = "https://notifyme69.herokuapp.com";
final _tokenEndpoint = "/api/register-user/";
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
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text('${state.error}'),
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
                            'SIGN UP',
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
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _password2Controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> fun() {
      Map<String, dynamic> toDatabaseJson() => {
            "username": _usernameController.text,
            "email": _emailController.text,
            "password": _passwordController.text,
            "password2": _password2Controller.text,
          };
      return toDatabaseJson();
    }

    Future<String> getToken() async {
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
      if (response.statusCode == 200) {
        print("Success");
        return "Success";
      } else {
        print("Failure");
        return "Failure";
      }
    }

    _onsignupButtonPressed() {
      getToken();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Login | Home Hub'),
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
                  obscureText: true,
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
                  height: MediaQuery.of(context).size.width * 0.22,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: RaisedButton(
                      onPressed: _onsignupButtonPressed,
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
