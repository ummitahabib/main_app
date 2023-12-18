class AddLogRequest {
  String createdBy;
  String? modifiedBy;
  String deleted;
  String? deletedBy;
  DateTime createdDate;
  DateTime modifiedDate;
  String organizationId;
  String siteId;
  String type;
  String name;
  DateTime startDate;
  DateTime endDate;
  DateTime startTime;
  DateTime endTime;
  String status;
  List<String> logFlags;
  bool isMovement;
  bool isGroupAssignment;
  String notes;
  String? quantity;
  String? reason;
  String? method;
  String? laboratory;
  String? testType;
  String? source;
  double? cost;
  String? currency;
  String? flags;
  String? farmingSeason;

  AddLogRequest({
    required this.createdBy,
    this.modifiedBy,
    required this.deleted,
    this.deletedBy,
    required this.createdDate,
    required this.modifiedDate,
    required this.organizationId,
    required this.siteId,
    required this.type,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.logFlags,
    required this.isMovement,
    required this.isGroupAssignment,
    required this.notes,
    this.quantity,
    this.reason,
    this.method,
    this.laboratory,
    this.testType,
    this.source,
    this.cost,
    this.currency,
    this.farmingSeason,
    this.flags,
  });

  factory AddLogRequest.fromJson(Map<String, dynamic> json) => AddLogRequest(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        organizationId: json["organizationId"],
        siteId: json["siteId"],
        type: json["type"],
        name: json["name"],
        startDate: DateTime.parse(json["startDate"]),
        endDate: DateTime.parse(json["endDate"]),
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        status: json["status"],
        logFlags: List<String>.from(json["logFlags"].map((x) => x)),
        isMovement: json["isMovement"],
        isGroupAssignment: json["isGroupAssignment"],
        notes: json["notes"],
        flags: json["flags"],
        farmingSeason: json["farmingSeasonId"],
        quantity: json["quantity"],
        reason: json["reason"],
        method: json["method"],
        laboratory: json["laboratory"],
        testType: json["testType"],
        source: json["source"],
        cost: json["cost"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
        "organizationId": organizationId,
        "siteId": siteId,
        "type": type,
        "name": name,
        "startDate": startDate.toIso8601String(),
        "endDate": endDate.toIso8601String(),
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "status": status,
        "logFlags": List<dynamic>.from(logFlags.map((x) => x)),
        "isMovement": isMovement,
        "isGroupAssignment": isGroupAssignment,
        "notes": notes,
        "quantity": quantity,
        "reason": reason,
        "method": method,
        "laboratory": laboratory,
        "testType": testType,
        "source": source,
        "cost": cost,
        "currency": currency,
        "flags": flags,
        "farmingSeasonId": farmingSeason
      };
}
