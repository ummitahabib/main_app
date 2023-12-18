// To parse this JSON data, do
//
//     final fieldAgentOrganization = fieldAgentOrganizationFromJson(jsonString);

import 'dart:convert';

FieldAgentOrganization fieldAgentOrganizationFromJson(String str) => FieldAgentOrganization.fromJson(json.decode(str));

String fieldAgentOrganizationToJson(FieldAgentOrganization data) => json.encode(data.toJson());

class FieldAgentOrganization {
  FieldAgentOrganization({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory FieldAgentOrganization.fromJson(Map<String, dynamic> json) => FieldAgentOrganization(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.organizationId,
    this.fieldAgentId,
    this.organizationName,
  });

  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  int? id;
  String? organizationId;
  String? fieldAgentId;
  String? organizationName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: DateTime.parse(json["modified_date"]),
        id: json["id"],
        organizationId: json["organizationId"],
        fieldAgentId: json["fieldAgentId"],
        organizationName: json["organizationName"],
      );

  Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "deleted": deleted,
        "deleted_by": deletedBy,
        "created_date": createdDate!.toIso8601String(),
        "modified_date": modifiedDate!.toIso8601String(),
        "id": id,
        "organizationId": organizationId,
        "fieldAgentId": fieldAgentId,
        "organizationName": organizationName,
      };
}
