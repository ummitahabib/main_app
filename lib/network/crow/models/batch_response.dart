// To parse this JSON data, do
//
//     final getSectorBatches = getSectorBatchesFromJson(jsonString);

import 'dart:convert';

List<GetSectorBatches> getSectorBatchesFromJson(String str) => List<GetSectorBatches>.from(
      json.decode(str).map((x) => GetSectorBatches.fromJson(x)),
    );

String getSectorBatchesToJson(List<GetSectorBatches> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSectorBatches {
  GetSectorBatches({
    this.images,
    this.id,
    this.name,
  });

  List<dynamic>? images;
  String? id;
  String? name;

  factory GetSectorBatches.fromJson(Map<String, dynamic> json) => GetSectorBatches(
        images: List<dynamic>.from(json["images"].map((x) => x)),
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "images": List<dynamic>.from(images!.map((x) => x)),
        "_id": id,
        "name": name,
      };
}
