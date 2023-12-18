// To parse this JSON data, do
//
//     final publishAsset = publishAssetFromJson(jsonString);

import 'dart:convert';

PublishAsset publishAssetFromJson(String str) => PublishAsset.fromJson(json.decode(str));

String publishAssetToJson(PublishAsset data) => json.encode(data.toJson());

class PublishAsset {
  PublishAsset({
    required this.activityId,
  });

  int activityId;

  factory PublishAsset.fromJson(Map<String, dynamic> json) => PublishAsset(
        activityId: json["activityId"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
      };
}
