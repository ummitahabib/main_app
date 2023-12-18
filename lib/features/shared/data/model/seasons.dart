// To parse this JSON data, do
//
//     final seasons = seasonsFromJson(jsonString);

import 'dart:convert';

Seasons seasonsFromJson(String str) => Seasons.fromJson(json.decode(str));

String seasonsToJson(Seasons data) => json.encode(data.toJson());

class Seasons {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? description;
  dynamic startDate;
  dynamic endDate;
  String? isCurrent;
  SeasonType? seasonType;

  Seasons({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.description,
    this.startDate,
    this.endDate,
    this.isCurrent,
    this.seasonType,
  });

  factory Seasons.fromJson(Map<String, dynamic> json) => Seasons(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        description: json["description"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        isCurrent: json["isCurrent"],
        seasonType: json["seasonType"] == null ? null : SeasonType.fromJson(json["seasonType"]),
      );

  Map<String, dynamic> toJson() => {
        "createdBy": createdBy,
        "modifiedBy": modifiedBy,
        "deleted": deleted,
        "deletedBy": deletedBy,
        "createdDate": createdDate?.toIso8601String(),
        "modifiedDate": modifiedDate?.toIso8601String(),
        "uuid": uuid,
        "description": description,
        "startDate": startDate,
        "endDate": endDate,
        "isCurrent": isCurrent,
        "seasonType": seasonType,
      };
}

class SeasonType {
  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  String? uuid;
  String? type;
  String? description;

  SeasonType({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.uuid,
    this.type,
    this.description,
  });

  factory SeasonType.fromJson(Map<String, dynamic> json) => SeasonType(
        createdBy: json["createdBy"],
        modifiedBy: json["modifiedBy"],
        deleted: json["deleted"],
        deletedBy: json["deletedBy"],
        createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
        modifiedDate: json["modifiedDate"] == null ? null : DateTime.parse(json["modifiedDate"]),
        uuid: json["uuid"],
        type: json["type"],
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
        "type": type,
        "description": description,
      };
}
