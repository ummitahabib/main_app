// To parse this JSON data, do
//
//     final popularPlantsResponse = popularPlantsResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

import '../../../features/data/models/afex_commodity/enum_values.dart';

List<PopularPlantsResponse> popularPlantsResponseFromJson(String str) => List<PopularPlantsResponse>.from(
      json.decode(str).map((x) => PopularPlantsResponse.fromJson(x)),
    );

String popularPlantsResponseToJson(List<PopularPlantsResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PopularPlantsResponse {
  PopularPlantsResponse({
    this.index,
    this.type,
    this.id,
    this.score,
    this.name,
    this.description,
    this.slug,
    this.alternateNames,
    this.scientificNames,
    this.photosCount,
    this.plantingsCount,
    this.harvestsCount,
    this.plantersIds,
    this.hasPhotos,
    this.thumbnailUrl,
    this.scientificName,
    this.createdAt,
    this.popularPlantsResponseId,
  });

  Index? index;
  Type? type;
  String? id;
  double? score;
  String? name;
  String? description;
  String? slug;
  List<String>? alternateNames;
  List<String>? scientificNames;
  int? photosCount;
  int? plantingsCount;
  int? harvestsCount;
  List<int>? plantersIds;
  bool? hasPhotos;
  String? thumbnailUrl;
  String? scientificName;
  int? createdAt;
  String? popularPlantsResponseId;

  factory PopularPlantsResponse.fromJson(Map<String, dynamic> json) => PopularPlantsResponse(
        index: indexValues.map![json["_index"]],
        type: typeValues.map![json["_type"]],
        id: json["_id"],
        score: json["_score"].toDouble(),
        name: json["name"],
        description: json["description"],
        slug: json["slug"],
        alternateNames: List<String>.from(json["alternate_names"].map((x) => x)),
        scientificNames: List<String>.from(json["scientific_names"].map((x) => x)),
        photosCount: json["photos_count"],
        plantingsCount: json["plantings_count"],
        harvestsCount: json["harvests_count"],
        plantersIds: List<int>.from(json["planters_ids"].map((x) => x)),
        hasPhotos: json["has_photos"],
        thumbnailUrl: json["thumbnail_url"],
        scientificName: json["scientific_name"],
        createdAt: json["created_at"],
        popularPlantsResponseId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_index": indexValues.reverse[index],
        "_type": typeValues.reverse[type],
        "_id": id,
        "_score": score,
        "name": name,
        "description": description,
        "slug": slug,
        "alternate_names": List<dynamic>.from(alternateNames!.map((x) => x)),
        "scientific_names": List<dynamic>.from(scientificNames!.map((x) => x)),
        "photos_count": photosCount,
        "plantings_count": plantingsCount,
        "harvests_count": harvestsCount,
        "planters_ids": List<dynamic>.from(plantersIds!.map((x) => x)),
        "has_photos": hasPhotos,
        "thumbnail_url": thumbnailUrl,
        "scientific_name": scientificName,
        "created_at": createdAt,
        "id": popularPlantsResponseId,
      };
}

enum Index { CROPS_PRODUCTION_20200824003628370 }

final indexValues = EnumValues({"crops_production_20200824003628370": Index.CROPS_PRODUCTION_20200824003628370});

enum Type { DOC }

final typeValues = EnumValues({"_doc": Type.DOC});
