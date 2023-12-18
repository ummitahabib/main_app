// To parse this JSON data, do
//
//     final assetTypes = assetTypesFromJson(jsonString);

import 'dart:convert';

AssetTypes assetTypesFromJson(String str) => AssetTypes.fromJson(json.decode(str));

String assetTypesToJson(AssetTypes data) => json.encode(data.toJson());

class AssetTypes {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? types;
  String? description;

  AssetTypes({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.types,
    this.description,
  });

  factory AssetTypes.fromJson(Map<String, dynamic> json) => AssetTypes(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        types: json["types"],
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
        "types": types,
        "description": description,
      };
}
