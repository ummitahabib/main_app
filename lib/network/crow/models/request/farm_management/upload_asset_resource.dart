// To parse this JSON data, do
//
//     final uploadAssetResource = uploadAssetResourceFromJson(jsonString);

import 'dart:convert';

UploadAssetResource uploadAssetResourceFromJson(String str) => UploadAssetResource.fromJson(json.decode(str));

String uploadAssetResourceToJson(UploadAssetResource data) => json.encode(data.toJson());

class UploadAssetResource {
  UploadAssetResource({
    required this.itemId,
    required this.url,
  });

  int itemId;
  String url;

  factory UploadAssetResource.fromJson(Map<String, dynamic> json) => UploadAssetResource(
        itemId: json["itemId"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "itemId": itemId,
        "url": url,
      };
}
