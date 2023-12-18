// To parse this JSON data, do
//
//     final genericPostResponse = genericPostResponseFromJson(jsonString);

import 'dart:convert';

GenericPostResponse genericPostResponseFromJson(String str) => GenericPostResponse.fromJson(json.decode(str));

String genericPostResponseToJson(GenericPostResponse data) => json.encode(data.toJson());

class GenericPostResponse {
  GenericPostResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  var data;

  factory GenericPostResponse.fromJson(Map<String, dynamic> json) => GenericPostResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data,
      };
}
