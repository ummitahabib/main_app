import 'dart:convert';

//forget password request

ForgetpasswordRequest forgetpasswordRequestFromJson(String str) => ForgetpasswordRequest.fromJson(json.decode(str));

String forgetpasswordRequestToJson(ForgetpasswordRequest data) => json.encode(data.toJson());

class ForgetpasswordRequest {
  String email;

  ForgetpasswordRequest({
    required this.email,
  });

  factory ForgetpasswordRequest.fromJson(Map<String, dynamic> json) => ForgetpasswordRequest(
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "email": email,
      };
}
