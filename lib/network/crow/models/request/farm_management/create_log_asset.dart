// To parse this JSON data, do
//
//     final createLogAsset = createLogAssetFromJson(jsonString);

import 'dart:convert';

CreateLogAsset createLogAssetFromJson(String str) => CreateLogAsset.fromJson(json.decode(str));

String createLogAssetToJson(CreateLogAsset data) => json.encode(data.toJson());

class CreateLogAsset {
  CreateLogAsset({
    required this.assetId,
    required this.logId,
  });

  int assetId;
  int logId;

  factory CreateLogAsset.fromJson(Map<String, dynamic> json) => CreateLogAsset(
        assetId: json["assetId"],
        logId: json["logId"],
      );

  Map<String, dynamic> toJson() => {
        "assetId": assetId,
        "logId": logId,
      };
}
