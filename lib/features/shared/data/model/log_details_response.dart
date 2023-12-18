import 'package:smat_crow/network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import 'package:smat_crow/features/shared/data/model/add_log_response.dart';

class LogDetailsResponse {
  AddLogResponse? log;
  AdditionalInfo? additionalInfo;

  LogDetailsResponse({
    this.log,
    this.additionalInfo,
  });

  factory LogDetailsResponse.fromJson(Map<String, dynamic> json) => LogDetailsResponse(
        log: json["log"] == null ? null : AddLogResponse.fromJson(json["log"]),
        additionalInfo: json["additionalInfo"] == null ? null : AdditionalInfo.fromJson(json["additionalInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "log": log?.toJson(),
        "additionalInfo": additionalInfo?.toJson(),
      };
}

class AdditionalInfo {
  List<LogInfo>? logFiles;
  List<LogInfo>? logMedia;
  List<LogAsset>? logAssets;
  List<LogInfo>? logRemarks;
  List<LogInfo>? logOwnersList;
  List<LogInfo>? logsThreads;

  AdditionalInfo({
    this.logFiles,
    this.logMedia,
    this.logAssets,
    this.logRemarks,
    this.logOwnersList,
    this.logsThreads,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        logFiles: json["logFiles"] == null ? [] : List<LogInfo>.from(json["logFiles"]!.map((x) => LogInfo.fromJson(x))),
        logMedia: json["logMedia"] == null ? [] : List<LogInfo>.from(json["logMedia"]!.map((x) => LogInfo.fromJson(x))),
        logAssets:
            json["logAssets"] == null ? [] : List<LogAsset>.from(json["logAssets"]!.map((x) => LogAsset.fromJson(x))),
        logRemarks:
            json["logRemarks"] == null ? [] : List<LogInfo>.from(json["logRemarks"]!.map((x) => LogInfo.fromJson(x))),
        logOwnersList: json["logOwnersList"] == null
            ? []
            : List<LogInfo>.from(json["logOwnersList"]!.map((x) => LogInfo.fromJson(x))),
        logsThreads:
            json["logsThreads"] == null ? [] : List<LogInfo>.from(json["logsThreads"]!.map((x) => LogInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "logFiles": logFiles == null ? [] : List<dynamic>.from(logFiles!.map((x) => x)),
        "logMedia": logMedia == null ? [] : List<dynamic>.from(logMedia!.map((x) => x)),
        "logAssets": logAssets == null ? [] : List<dynamic>.from(logAssets!.map((x) => x)),
        "logRemarks": logRemarks == null ? [] : List<dynamic>.from(logRemarks!.map((x) => x)),
        "logOwnersList": logOwnersList == null ? [] : List<dynamic>.from(logOwnersList!.map((x) => x)),
        "logsThreads": logsThreads == null ? [] : List<dynamic>.from(logsThreads!.map((x) => x)),
      };
}

class LogInfo {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? ownerName;
  String? ownerRole;
  String? remark;
  String? nextAction;
  String? url;
  String? assetId;
  String? logUuid;

  LogInfo({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.ownerName,
    this.ownerRole,
    this.remark,
    this.nextAction,
    this.url,
    this.assetId,
    this.logUuid,
  });

  factory LogInfo.fromJson(Map<String, dynamic> json) => LogInfo(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        ownerName: json["ownerName"],
        ownerRole: json["ownerRole"],
        remark: json["remark"],
        nextAction: json["nextAction"],
        url: json["url"],
        assetId: json["assetId"],
        logUuid: json["logUuid"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "ownerName": ownerName,
        "ownerRole": ownerRole,
        "remark": remark,
        "nextAction": nextAction,
        "url": url,
        "assetId": assetId,
        "logUuid": logUuid,
      };
}
