// To parse this JSON data, do
//
//     final logStatus = logStatusFromJson(jsonString);

import 'dart:convert';

LogStatus logStatusFromJson(String str) => LogStatus.fromJson(json.decode(str));

String logStatusToJson(LogStatus data) => json.encode(data.toJson());

class LogStatus {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? status;
  String? description;

  LogStatus({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.status,
    this.description,
  });

  factory LogStatus.fromJson(Map<String, dynamic> json) => LogStatus(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        status: json["status"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "status": status,
        "description": description,
      };
}
