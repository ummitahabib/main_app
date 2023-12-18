// To parse this JSON data, do
//
//     final createLogOwner = createLogOwnerFromJson(jsonString);

import 'dart:convert';

CreateLogOwner createLogOwnerFromJson(String str) =>
    CreateLogOwner.fromJson(json.decode(str));

String createLogOwnerToJson(CreateLogOwner data) => json.encode(data.toJson());

class CreateLogOwner {
  CreateLogOwner({
 required   this.logId,
  required  this.ownerName,
   required this.ownerRole,
  });

  int logId;
  String ownerName;
  String ownerRole;

  factory CreateLogOwner.fromJson(Map<String, dynamic> json) => CreateLogOwner(
        logId: json["logId"],
        ownerName: json["ownerName"],
        ownerRole: json["ownerRole"],
      );

  Map<String, dynamic> toJson() => {
        "logId": logId,
        "ownerName": ownerName,
        "ownerRole": ownerRole,
      };
}
