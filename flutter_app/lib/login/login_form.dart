import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notiflyer/login/bloc/login_bloc.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import 'package:notiflyer/model/api_model.dart';

final _base = "https://notifyme69.herokuapp.com";
final _tokenEndpoint = "/api/register/app/";
final _tokenURL = _base + _tokenEndpoint;

//LoginForm conatins build for login(initial) page
//login post request in lib/api_connection/

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  //build for initial login page along with post request
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
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.width * 0.20,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: RaisedButton(
                          onPressed: state is! LoginLoading
                              ? _onLoginButtonPressed
                              : null,
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 20.0,
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
                      width: MediaQuery.of(context).size.width * 0.40,
                      height: MediaQuery.of(context).size.width * 0.20,
                      child: Padding(
                        padding: EdgeInsets.only(top: 30.0),
                        child: RaisedButton(
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 20.0,
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
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top: 15.0, left: 20.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ThirdRoute()),
                          );
                        },
                        child: Text(
                          'Forgot Password',
                          style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              decoration: TextDecoration.underline),
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

// SecondRoute conatins build for Sign up page (also contains post request)

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
      //post request to register(sign up) a user
      print(_tokenURL);
      print(jsonEncode(fun()));
      print("kokoko");
      final http.Response response = await http.post(
        _tokenURL,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
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
      //actual build of sign up page
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Sign Up'),
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
                  width: MediaQuery.of(context).size.width * 0.40,
                  height: MediaQuery.of(context).size.width * 0.20,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
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

//ThirdRoute contains build for forgot password page
//contains post request for sending OTP as well as changing password

class ThirdRoute extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> fun() {
      Map<String, dynamic> toDatabaseJson() => {
            //conversion of form fields to json
            "email": _emailController.text,
            "username": _usernameController.text,
            "password1": _passwordController.text,
            "password2": _passwordController.text,
            "otp": _otpController.text,
          };
      return toDatabaseJson();
    }

    Future passwordchange(BuildContext context) async {
      //post request to finally change password after entering correct OTP
      print(jsonEncode(fun()));
      String otpurl = 'https://notifyme69.herokuapp.com/api/confirmotp/';
      final http.Response response = await http.post(
        otpurl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(fun()),
      );
      print("uuuuuuuu");
      print(response.body);
      print("asd");

      if (response.statusCode == 200) {
        print("suc");
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
          content: Text('Enter correct OTP'),
          backgroundColor: Colors.red,
        );
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }

    _onsignupButtonPressed(BuildContext context) {
      passwordchange(context);
    }

    Future sendotp(BuildContext context) async {
      //post request to send OTP to registered email
      print("kokoko");
      String otpurl = 'https://notifyme69.herokuapp.com/api/otp/';
      String userr = _usernameController.text;
      String emaill = _emailController.text;
      String poqw = '{"username":"$userr","email":"$emaill"}';
      final http.Response response = await http.post(
        otpurl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: poqw,
      );
      print("uuuuuuuu");
      print(response.body);
      print("asd");

      if (response.statusCode == 200) {
        print("suc");
        final snackBar = SnackBar(
          content: Text('OTP sent to your Email'),
          backgroundColor: Colors.green,
        );
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(snackBar);
      } else {
        print("unsuc");
        // ignore: deprecated_member_use
        final snackBar = SnackBar(
          content: Text('Enter correct details'),
          backgroundColor: Colors.red,
        );
        // ignore: deprecated_member_use
        _scaffoldKey.currentState.showSnackBar(snackBar);
      }
    }

    return Scaffold(
      //actual display/build of the page
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: (Container(
        child: Form(
          child: Padding(
            padding: EdgeInsets.all(30.0),
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
                Container(
                  alignment: Alignment(1.0, 0.0),
                  padding: EdgeInsets.only(top: 10.0, left: 20.0),
                  child: InkWell(
                    onTap: () {
                      sendotp(context);
                    },
                    child: Text(
                      'Send OTP',
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          decoration: TextDecoration.underline),
                    ),
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'OTP', icon: Icon(Icons.security)),
                  controller: _otpController,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'new password', icon: Icon(Icons.security)),
                  controller: _passwordController,
                  obscureText: true,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.55,
                  height: MediaQuery.of(context).size.width * 0.20,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: RaisedButton(
                      onPressed: () {
                        _onsignupButtonPressed(context);
                      },
                      child: Text(
                        'Update Password',
                        style: TextStyle(
                          fontSize: 20.0,
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
