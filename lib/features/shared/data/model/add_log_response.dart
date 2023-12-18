class AddLogResponse {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? organizationId;
  String? siteId;
  String? type;
  String? name;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  String? status;
  String? flags;
  List<String>? logFlags;
  bool? isMovement;
  bool? isGroupAssignment;
  String? notes;
  String? quantity;
  String? reason;
  String? method;
  String? laboratory;
  String? testType;
  String? source;
  String? readyForApproval;
  dynamic farmingSeasonId;
  dynamic publishedBy;
  String? currency;
  double? cost;

  AddLogResponse({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.organizationId,
    this.siteId,
    this.type,
    this.name,
    this.startDate,
    this.endDate,
    this.startTime,
    this.endTime,
    this.status,
    this.flags,
    this.logFlags,
    this.isMovement,
    this.isGroupAssignment,
    this.notes,
    this.quantity,
    this.reason,
    this.method,
    this.laboratory,
    this.testType,
    this.source,
    this.readyForApproval,
    this.farmingSeasonId,
    this.publishedBy,
    this.currency,
    this.cost,
  });

  factory AddLogResponse.fromJson(Map<String, dynamic> json) => AddLogResponse(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        organizationId: json["organizationId"],
        siteId: json["siteId"],
        type: json["type"],
        name: json["name"],
        startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
        endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
        startTime: json["startTime"] == null ? null : DateTime.parse(json["startTime"]),
        endTime: json["endTime"] == null ? null : DateTime.parse(json["endTime"]),
        status: json["status"],
        flags: json["flags"],
        logFlags: json["logFlags"] == null ? [] : List<String>.from(json["logFlags"].map((e) => e)),
        isMovement: json["isMovement"],
        isGroupAssignment: json["isGroupAssignment"],
        notes: json["notes"],
        quantity: json["quantity"],
        reason: json["reason"],
        method: json["method"],
        laboratory: json["laboratory"],
        testType: json["testType"],
        source: json["source"],
        readyForApproval: json["readyForApproval"],
        farmingSeasonId: json["farmingSeasonId"],
        publishedBy: json["publishedBy"],
        currency: json["currency"],
        cost: json["cost"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "organizationId": organizationId,
        "siteId": siteId,
        "type": type,
        "name": name,
        "startDate": startDate?.toIso8601String(),
        "endDate": endDate?.toIso8601String(),
        "startTime": startTime?.toIso8601String(),
        "endTime": endTime?.toIso8601String(),
        "status": status,
        "flags": flags,
        "logFlags": logFlags,
        "isMovement": isMovement,
        "isGroupAssignment": isGroupAssignment,
        "notes": notes,
        "quantity": quantity,
        "reason": reason,
        "method": method,
        "laboratory": laboratory,
        "testType": testType,
        "source": source,
        "readyForApproval": readyForApproval,
        "farmingSeasonId": farmingSeasonId,
        "publishedBy": publishedBy,
        "currency": currency,
        "cost": cost,
      };
}
