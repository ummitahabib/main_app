import 'package:smat_crow/features/shared/data/model/add_asset_response.dart';

class AssetDetailsResponse {
  AddAssetResponse? assets;
  AdditionalInfo? additionalInfo;

  AssetDetailsResponse({
    this.assets,
    this.additionalInfo,
  });

  factory AssetDetailsResponse.fromJson(Map<String, dynamic> json) => AssetDetailsResponse(
        assets: json["assets"] == null ? null : AddAssetResponse.fromJson(json["assets"]),
        additionalInfo: json["additionalInfo"] == null ? null : AdditionalInfo.fromJson(json["additionalInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "assets": assets?.toJson(),
        "additionalInfo": additionalInfo?.toJson(),
      };
}

class AdditionalInfo {
  List<AssetInfo>? assetFiles;
  List<AssetInfo>? assetThreads;
  List<AssetInfo>? assetMedia;

  AdditionalInfo({
    this.assetFiles,
    this.assetThreads,
    this.assetMedia,
  });

  factory AdditionalInfo.fromJson(Map<String, dynamic> json) => AdditionalInfo(
        assetFiles: json["assetFiles"] == null
            ? []
            : List<AssetInfo>.from(json["assetFiles"]!.map((x) => AssetInfo.fromJson(x))),
        assetThreads: json["assetThreads"] == null
            ? []
            : List<AssetInfo>.from(json["assetThreads"]!.map((x) => AssetInfo.fromJson(x))),
        assetMedia: json["assetMedia"] == null
            ? []
            : List<AssetInfo>.from(json["assetMedia"]!.map((x) => AssetInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "assetFiles": assetFiles == null ? [] : List<dynamic>.from(assetFiles!.map((x) => x)),
        "assetThreads": assetThreads == null ? [] : List<dynamic>.from(assetThreads!.map((x) => x)),
        "assetMedia": assetMedia == null ? [] : List<dynamic>.from(assetMedia!.map((x) => x)),
      };
}

class AssetInfo {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? url;
  String? assetUuid;

  AssetInfo({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.url,
    this.assetUuid,
  });

  factory AssetInfo.fromJson(Map<String, dynamic> json) => AssetInfo(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        url: json["url"],
        assetUuid: json["assetUuid"],
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "url": url,
        "assetUuid": assetUuid,
      };
}
