// To parse this JSON data, do
//
//     final getLogDetails = getLogDetailsFromJson(jsonString);

import 'dart:convert';

GetLogDetails getLogDetailsFromJson(String str) => GetLogDetails.fromJson(json.decode(str));

String getLogDetailsToJson(GetLogDetails data) => json.encode(data.toJson());

class GetLogDetails {
  GetLogDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory GetLogDetails.fromJson(Map<String, dynamic> json) => GetLogDetails(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.organizationId,
    this.siteId,
    this.type,
    this.name,
    this.farmingSeason,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.status,
    this.flags,
    this.isMovement,
    this.isGroupAssignment,
    this.notes,
    this.quantity,
    this.reason,
    this.method,
    this.laboratory,
    this.testType,
    this.source,
  });

  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  int? id;
  String? organizationId;
  String? siteId;
  String? type;
  String? name;
  String? farmingSeason;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  String? status;
  String? flags;
  bool? isMovement;
  bool? isGroupAssignment;
  String? notes;
  String? quantity;
  String? reason;
  String? method;
  String? laboratory;
  String? testType;
  String? source;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: DateTime.parse(json["modified_date"]),
        id: json["id"],
        organizationId: json["organizationId"],
        siteId: json["siteId"],
        type: json["type"],
        name: json["name"],
        farmingSeason: json["farmingSeason"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        status: json["status"],
        flags: json["flags"],
        isMovement: json["isMovement"],
        isGroupAssignment: json["isGroupAssignment"],
        notes: json["notes"],
        quantity: json["quantity"],
        reason: json["reason"],
        method: json["method"],
        laboratory: json["laboratory"],
        testType: json["testType"],
        source: json["source"],
      );

  Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "deleted": deleted,
        "deleted_by": deletedBy,
        "id": id,
        "organizationId": organizationId,
        "siteId": siteId,
        "type": type,
        "name": name,
        "farmingSeason": farmingSeason,
        "status": status,
        "flags": flags,
        "isMovement": isMovement,
        "isGroupAssignment": isGroupAssignment,
        "notes": notes,
        "quantity": quantity,
        "reason": reason,
        "method": method,
        "laboratory": laboratory,
        "testType": testType,
        "source": source,
      };
}
