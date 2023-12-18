// To parse this JSON data, do
//
//     final paginatedPlantsResponse = paginatedPlantsResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

import '../../../features/data/models/afex_commodity/enum_values.dart';

PaginatedPlantsResponse paginatedPlantsResponseFromJson(String str) =>
    PaginatedPlantsResponse.fromJson(json.decode(str));

String paginatedPlantsResponseToJson(PaginatedPlantsResponse data) => json.encode(data.toJson());

class PaginatedPlantsResponse {
  PaginatedPlantsResponse({
    required this.data,
    this.links,
  });

  List<Datum> data;
  PaginatedPlantsResponseLinks? links;

  factory PaginatedPlantsResponse.fromJson(Map<String, dynamic> json) => PaginatedPlantsResponse(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: PaginatedPlantsResponseLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links!.toJson(),
      };
}

class Datum {
  Datum({
    this.id,
    this.type,
    this.links,
    this.attributes,
    this.relationships,
  });

  String? id;
  Type? type;
  DatumLinks? links;
  Attributes? attributes;
  Relationships? relationships;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: typeValues.map![json["type"]],
        links: DatumLinks.fromJson(json["links"]),
        attributes: Attributes.fromJson(json["attributes"]),
        relationships: Relationships.fromJson(json["relationships"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": typeValues.reverse[type],
        "links": links!.toJson(),
        "attributes": attributes!.toJson(),
        "relationships": relationships!.toJson(),
      };
}

class Attributes {
  Attributes({
    this.name,
    this.enWikipediaUrl,
    this.perennial,
    this.medianLifespan,
    this.medianDaysToFirstHarvest,
    this.medianDaysToLastHarvest,
  });

  String? name;
  String? enWikipediaUrl;
  bool? perennial;
  int? medianLifespan;
  int? medianDaysToFirstHarvest;
  int? medianDaysToLastHarvest;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        name: json["name"],
        enWikipediaUrl: json["en-wikipedia-url"],
        perennial: json["perennial"],
        medianLifespan: json["median-lifespan"],
        medianDaysToFirstHarvest: json["median-days-to-first-harvest"],
        medianDaysToLastHarvest: json["median-days-to-last-harvest"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "en-wikipedia-url": enWikipediaUrl,
        "perennial": perennial,
        "median-lifespan": medianLifespan,
        "median-days-to-first-harvest": medianDaysToFirstHarvest,
        "median-days-to-last-harvest": medianDaysToLastHarvest,
      };
}

class DatumLinks {
  DatumLinks({
    this.self,
  });

  String? self;

  factory DatumLinks.fromJson(Map<String, dynamic> json) => DatumLinks(
        self: json["self"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
      };
}

class Relationships {
  Relationships({
    this.plantings,
    this.seeds,
    this.harvests,
    this.photos,
    this.parent,
  });

  Harvests? plantings;
  Harvests? seeds;
  Harvests? harvests;
  Harvests? photos;
  Harvests? parent;

  factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        plantings: Harvests.fromJson(json["plantings"]),
        seeds: Harvests.fromJson(json["seeds"]),
        harvests: Harvests.fromJson(json["harvests"]),
        photos: Harvests.fromJson(json["photos"]),
        parent: Harvests.fromJson(json["parent"]),
      );

  Map<String, dynamic> toJson() => {
        "plantings": plantings!.toJson(),
        "seeds": seeds!.toJson(),
        "harvests": harvests!.toJson(),
        "photos": photos!.toJson(),
        "parent": parent!.toJson(),
      };
}

class Harvests {
  Harvests({
    required this.links,
  });

  HarvestsLinks links;

  factory Harvests.fromJson(Map<String, dynamic> json) => Harvests(
        links: HarvestsLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "links": links.toJson(),
      };
}

class HarvestsLinks {
  HarvestsLinks({
    required this.self,
    required this.related,
  });

  String self;
  String related;

  factory HarvestsLinks.fromJson(Map<String, dynamic> json) => HarvestsLinks(
        self: json["self"],
        related: json["related"],
      );

  Map<String, dynamic> toJson() => {
        "self": self,
        "related": related,
      };
}

enum Type { CROPS }

final typeValues = EnumValues({"crops": Type.CROPS});

class PaginatedPlantsResponseLinks {
  PaginatedPlantsResponseLinks({
    this.first,
    this.next,
    this.last,
  });

  String? first;
  String? next;
  String? last;

  factory PaginatedPlantsResponseLinks.fromJson(Map<String, dynamic> json) => PaginatedPlantsResponseLinks(
        first: json["first"],
        next: json["next"],
        last: json["last"],
      );

  Map<String, dynamic> toJson() => {
        "first": first,
        "next": next,
        "last": last,
      };
}
