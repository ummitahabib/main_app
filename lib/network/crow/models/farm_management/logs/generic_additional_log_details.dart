// To parse this JSON data, do
//
//     final additionalLogDetails = additionalLogDetailsFromJson(jsonString);

import 'dart:convert';

AdditionalLogDetails additionalLogDetailsFromJson(String str) => AdditionalLogDetails.fromJson(json.decode(str));

String additionalLogDetailsToJson(AdditionalLogDetails data) => json.encode(data.toJson());

class AdditionalLogDetails {
  AdditionalLogDetails({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory AdditionalLogDetails.fromJson(Map<String, dynamic> json) => AdditionalLogDetails(
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
    required this.logFiles,
    required this.logMedia,
    required this.logAssets,
    required this.logRemarks,
    required this.logOwnersList,
  });

  List<Log> logFiles = [];
  List<Log> logMedia = [];
  List<LogAsset> logAssets = [];
  List<Log> logRemarks = [];
  List<Log> logOwnersList = [];

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        logFiles: List<Log>.from(json["logFiles"].map((x) => Log.fromJson(x)) ?? []),
        logMedia: List<Log>.from(json["logMedia"].map((x) => Log.fromJson(x)) ?? []),
        logAssets: List<LogAsset>.from(
          json["logAssets"].map((x) => LogAsset.fromJson(x)) ?? [],
        ),
        logRemarks: List<Log>.from(
          json["logRemarks"].map((x) => Log.fromJson(x)) ?? [],
        ),
        logOwnersList: List<Log>.from(
          json["logOwnersList"].map((x) => Log.fromJson(x)) ?? [],
        ),
      );

  Map<String, dynamic> toJson() => {
        "logFiles": List<dynamic>.from(logFiles.map((x) => x.toJson())),
        "logMedia": List<dynamic>.from(logMedia.map((x) => x.toJson())),
        "logAssets": List<dynamic>.from(logAssets.map((x) => x.toJson())),
        "logRemarks": List<dynamic>.from(logRemarks.map((x) => x.toJson())),
        "logOwnersList": List<dynamic>.from(logOwnersList.map((x) => x.toJson())),
      };
}

class LogAsset {
  LogAsset({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.organizationId,
    this.name,
    this.status,
    this.flags,
    this.type,
    this.canExpire,
    this.notes,
    this.serialnumber,
    this.manufacturer,
    this.model,
    this.cropFamily,
    this.daysToTransplant,
    this.daysToMaturity,
    this.structureType,
    this.manufactureDate,
    this.expiryDate,
    this.cost,
    this.quantity,
    this.acquisitionDate,
    this.location,
  });

  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  int? id;
  String? organizationId;
  String? name;
  String? status;
  String? flags;
  String? type;
  bool? canExpire;
  String? notes;
  String? serialnumber;
  String? manufacturer;
  String? model;
  String? cropFamily;
  int? daysToTransplant;
  int? daysToMaturity;
  String? structureType;
  DateTime? manufactureDate;
  DateTime? expiryDate;
  dynamic cost;
  int? quantity;
  DateTime? acquisitionDate;
  bool? location;

  factory LogAsset.fromJson(Map<String, dynamic> json) => LogAsset(
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
        id: json["id"],
        organizationId: json["organizationId"],
        name: json["name"],
        status: json["status"],
        flags: json["flags"],
        type: json["type"],
        canExpire: json["canExpire"],
        notes: json["notes"],
        serialnumber: json["serialnumber"],
        manufacturer: json["manufacturer"],
        model: json["model"],
        cropFamily: json["cropFamily"],
        daysToTransplant: json["daysToTransplant"],
        daysToMaturity: json["daysToMaturity"],
        structureType: json["structureType"],
        manufactureDate: json["manufactureDate"] == null ? null : DateTime.parse(json["manufactureDate"]),
        expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
        cost: json["cost"],
        quantity: json["quantity"],
        acquisitionDate: json["acquisitionDate"] == null ? null : DateTime.parse(json["acquisitionDate"]),
        location: json["location"],
      );

  Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "deleted": deleted,
        "deleted_by": deletedBy,
        "id": id,
        "organizationId": organizationId,
        "name": name,
        "status": status,
        "flags": flags,
        "type": type,
        "canExpire": canExpire,
        "notes": notes,
        "serialnumber": serialnumber,
        "manufacturer": manufacturer,
        "model": model,
        "cropFamily": cropFamily,
        "daysToTransplant": daysToTransplant,
        "daysToMaturity": daysToMaturity,
        "structureType": structureType,
        "cost": cost,
        "quantity": quantity,
        "location": location,
      };
}

class Log {
  Log({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.url,
    this.logId,
    this.ownerName,
    this.ownerRole,
    this.remark,
    this.nextAction,
  });

  String? createdBy;
  dynamic modifiedBy;
  dynamic deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  int? id;
  dynamic url;
  int? logId;
  dynamic ownerName;
  dynamic ownerRole;
  dynamic remark;
  dynamic nextAction;

  factory Log.fromJson(Map<String, dynamic> json) => Log(
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: DateTime.parse(json["modified_date"]),
        id: json["id"],
        url: json["url"],
        logId: json["logId"],
        ownerName: json["ownerName"],
        ownerRole: json["ownerRole"],
        remark: json["remark"],
        nextAction: json["nextAction"],
      );

  Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "deleted": deleted,
        "deleted_by": deletedBy,
        "id": id,
        "url": url,
        "logId": logId,
        "ownerName": ownerName,
        "ownerRole": ownerRole,
        "remark": remark,
        "nextAction": nextAction,
      };
}
