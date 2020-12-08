import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:dashboard_app/model/api_model.dart';
import 'package:dashboard_app/globals.dart' as globals;

final _base = "https://notifyme69.herokuapp.com";
final _tokenEndpoint = "/api/login/dashboard/";
final _tokenURL = _base + _tokenEndpoint;

Future<Token> getToken(UserLogin userLogin) async {
  print(_tokenURL);
  final http.Response response = await http.post(
    _tokenURL,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(userLogin.toDatabaseJson()),
  );
  print(response.body);
  if (response.body == '{"response":"Fail"}') {
    print(json.decode(response.body).toString());
    throw Exception(json.decode(response.body));
  } else {
    var tu = json.decode(response.body);
    globals.isTa = tu["isTa"];
    print(tu);
    print(tu["isTa"]);
    print("huloooooo");
    print(globals.isTa);
    return Token.fromJson(json.decode(response.body));
  }
}
