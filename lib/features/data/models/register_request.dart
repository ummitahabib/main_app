import 'dart:convert';

import 'package:smat_crow/utils2/constants.dart';

// register request

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  String firstName;
  String lastName;
  String email;
  String password;

  RegisterRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      RegisterRequest(
        firstName: json[jsonFirstname],
        lastName: json[jsonLastname],
        email: json[jsonEmail],
        password: json[jsonPassword],
      );

  Map<String, dynamic> toJson() => {
        jsonFirstname: firstName,
        jsonLastname: lastName,
        jsonEmail: email,
        jsonPassword: password,
      };
}
