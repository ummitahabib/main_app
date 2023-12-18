// To parse this JSON data, do
//
//     final createLogRequest = createLogRequestFromJson(jsonString);

import 'dart:convert';

CreateLogRequest createLogRequestFromJson(String str) => CreateLogRequest.fromJson(json.decode(str));

String createLogRequestToJson(CreateLogRequest data) => json.encode(data.toJson());

class CreateLogRequest {
  CreateLogRequest({
    this.createdBy,
    this.createdDate,
    this.deleted,
    this.deletedBy,
    this.endDate,
    this.endTime,
    this.farmingSeason,
    this.flags,
    this.isGroupAssignment,
    this.isMovement,
    this.laboratory,
    this.method,
    this.modifiedBy,
    this.modifiedDate,
    this.name,
    this.notes,
    this.organizationId,
    this.quantity,
    this.reason,
    this.siteId,
    this.source,
    this.startDate,
    this.startTime,
    this.status,
    this.testType,
    this.type,
  });

  String? createdBy;
  DateTime? createdDate;
  String? deleted;
  String? deletedBy;
  DateTime? endDate;
  DateTime? endTime;
  String? farmingSeason;
  String? flags;
  bool? isGroupAssignment;
  bool? isMovement;
  String? laboratory;
  String? method;
  String? modifiedBy;
  DateTime? modifiedDate;
  String? name;
  String? notes;
  String? organizationId;
  String? quantity;
  String? reason;
  String? siteId;
  String? source;
  DateTime? startDate;
  DateTime? startTime;
  String? status;
  String? testType;
  String? type;

  factory CreateLogRequest.fromJson(Map<String, dynamic> json) => CreateLogRequest(
        createdBy: json["created_by"],
        createdDate: DateTime.parse(json["created_date"]),
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        endDate: DateTime.parse(json["endDate"]),
        endTime: DateTime.parse(json["endTime"]),
        farmingSeason: json["farmingSeason"],
        flags: json["flags"],
        isGroupAssignment: json["isGroupAssignment"],
        isMovement: json["isMovement"],
        laboratory: json["laboratory"],
        method: json["method"],
        modifiedBy: json["modified_by"],
        modifiedDate: DateTime.parse(json["modified_date"]),
        name: json["name"],
        notes: json["notes"],
        organizationId: json["organizationId"],
        quantity: json["quantity"],
        reason: json["reason"],
        siteId: json["siteId"],
        source: json["source"],
        startDate: DateTime.parse(json["startDate"]),
        startTime: DateTime.parse(json["startTime"]),
        status: json["status"],
        testType: json["testType"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "created_date": createdDate!.toIso8601String(),
        "deleted": deleted,
        "deleted_by": deletedBy,
        "farmingSeason": farmingSeason,
        "flags": flags,
        "isGroupAssignment": isGroupAssignment,
        "isMovement": isMovement,
        "laboratory": laboratory,
        "method": method,
        "modified_by": modifiedBy,
        "modified_date": modifiedDate!.toIso8601String(),
        "name": name,
        "notes": notes,
        "organizationId": organizationId,
        "quantity": quantity,
        "reason": reason,
        "siteId": siteId,
        "source": source,
        "startDate": startDate!.toIso8601String(),
        "startTime": startTime!.toIso8601String(),
        "status": status,
        "testType": testType,
        "type": type,
      };
}
