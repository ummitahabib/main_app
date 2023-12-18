// To parse this JSON data, do
//
//     final updateDeviceIdRequest = updateDeviceIdRequestFromJson(jsonString);

import 'dart:convert';

UpdateDeviceIdRequest updateDeviceIdRequestFromJson(String str) => UpdateDeviceIdRequest.fromJson(json.decode(str));

String updateDeviceIdRequestToJson(UpdateDeviceIdRequest data) => json.encode(data.toJson());

class UpdateDeviceIdRequest {
  UpdateDeviceIdRequest({
    required this.userId,
    required this.notificationToken,
  });

  String userId;
  String notificationToken;

  factory UpdateDeviceIdRequest.fromJson(Map<String, dynamic> json) => UpdateDeviceIdRequest(
        userId: json["userId"],
        notificationToken: json["notificationToken"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "notificationToken": notificationToken,
      };
}
