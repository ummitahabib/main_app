// To parse this JSON data, do
//
//     final getLogsResponse = getLogsResponseFromJson(jsonString);

import 'dart:convert';

GetLogsResponse getLogsResponseFromJson(String str) => GetLogsResponse.fromJson(json.decode(str));

String getLogsResponseToJson(GetLogsResponse data) => json.encode(data.toJson());

class GetLogsResponse {
  GetLogsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory GetLogsResponse.fromJson(Map<String, dynamic> json) => GetLogsResponse(
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
    required this.completed,
    required this.ongoing,
    required this.upcoming,
    required this.missed,
  });

  List<Completed> completed = [];
  List<Completed> ongoing = [];
  List<Completed> upcoming = [];
  List<Completed> missed = [];

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        completed: json["Completed"] == null
            ? []
            : List<Completed>.from(
                json["Completed"].map((x) => Completed.fromJson(x)),
              ),
        ongoing: json["Ongoing"] == null
            ? []
            : List<Completed>.from(
                json["Ongoing"].map((x) => Completed.fromJson(x)),
              ),
        upcoming: json["Upcoming"] == null
            ? []
            : List<Completed>.from(
                json["Upcoming"].map((x) => Completed.fromJson(x)),
              ),
        missed: json["Missed"] == null
            ? []
            : List<Completed>.from(
                json["Missed"].map((x) => Completed.fromJson(x)),
              ),
      );

  Map<String, dynamic> toJson() => {
        "Completed": List<dynamic>.from(completed.map((x) => x.toJson())),
        "Ongoing": List<dynamic>.from(ongoing.map((x) => x.toJson())),
        "Upcoming": List<dynamic>.from(upcoming.map((x) => x.toJson())),
        "Missed": List<dynamic>.from(missed.map((x) => x.toJson())),
      };
}

class Completed {
  Completed({
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
  String? modifiedBy;
  String? deleted;
  String? deletedBy;
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

  factory Completed.fromJson(Map<String, dynamic> json) => Completed(
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
        "created_date": createdDate!.toIso8601String(),
        "modified_date": modifiedDate!.toIso8601String(),
        "id": id,
        "organizationId": organizationId,
        "siteId": siteId,
        "type": type,
        "name": name,
        "farmingSeason": farmingSeason,
        "startDate":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "endDate":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "startTime":
            "${startTime!.year.toString().padLeft(4, '0')}-${startTime!.month.toString().padLeft(2, '0')}-${startTime!.day.toString().padLeft(2, '0')}",
        "endTime":
            "${endTime!.year.toString().padLeft(4, '0')}-${endTime!.month.toString().padLeft(2, '0')}-${endTime!.day.toString().padLeft(2, '0')}",
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
