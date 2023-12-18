import 'dart:convert';

import 'package:smat_crow/utils2/constants.dart';

//signin request

SigninRequest signinRequestFromJson(String str) =>
    SigninRequest.fromJson(json.decode(str));

String signinRequestToJson(SigninRequest data) => json.encode(data.toJson());

class SigninRequest {
  String email;
  String password;

  SigninRequest({
    required this.email,
    required this.password,
  });

  factory SigninRequest.fromJson(Map<String, dynamic> json) => SigninRequest(
        email: json[jsonEmail],
        password: json[jsonPassword],
      );

  Map<String, dynamic> toJson() => {
        jsonEmail: email,
        jsonPassword: password,
      };
}
