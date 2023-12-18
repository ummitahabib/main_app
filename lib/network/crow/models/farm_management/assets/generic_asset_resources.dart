// To parse this JSON data, do
//
//     final assetsResourcesResponse = assetsResourcesResponseFromJson(jsonString);

import 'dart:convert';

AssetsResourcesResponse assetsResourcesResponseFromJson(String str) =>
    AssetsResourcesResponse.fromJson(json.decode(str));

String assetsResourcesResponseToJson(AssetsResourcesResponse data) => json.encode(data.toJson());

class AssetsResourcesResponse {
  AssetsResourcesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory AssetsResourcesResponse.fromJson(Map<String, dynamic> json) => AssetsResourcesResponse(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x)) ?? []),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.createdBy,
    this.modifiedBy,
    this.deleted,
    this.deletedBy,
    this.createdDate,
    this.modifiedDate,
    this.id,
    this.url,
    this.assetId,
  });

  String? createdBy;
  dynamic modifiedBy;
  String? deleted;
  dynamic deletedBy;
  DateTime? createdDate;
  DateTime? modifiedDate;
  int? id;
  String? url;
  int? assetId;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        createdBy: json["created_by"],
        modifiedBy: json["modified_by"],
        deleted: json["deleted"],
        deletedBy: json["deleted_by"],
        createdDate: DateTime.parse(json["created_date"]),
        modifiedDate: DateTime.parse(json["modified_date"]),
        id: json["id"],
        url: json["url"],
        assetId: json["assetId"],
      );

  Map<String, dynamic> toJson() => {
        "created_by": createdBy,
        "modified_by": modifiedBy,
        "deleted": deleted,
        "deleted_by": deletedBy,
        "created_date": createdDate!.toIso8601String(),
        "modified_date": modifiedDate!.toIso8601String(),
        "id": id,
        "url": url,
        "assetId": assetId,
      };
}
