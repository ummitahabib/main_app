// To parse this JSON data, do
//
//     final plantDetailResponse = plantDetailResponseFromJson(jsonString);

import 'dart:convert';

PlantDetailResponse plantDetailResponseFromJson(String str) => PlantDetailResponse.fromJson(json.decode(str));

String plantDetailResponseToJson(PlantDetailResponse data) => json.encode(data.toJson());

class PlantDetailResponse {
  PlantDetailResponse({
    this.id,
    this.name,
    this.enWikipediaUrl,
    this.createdAt,
    this.updatedAt,
    this.slug,
    this.parentId,
    this.plantingsCount,
    this.creatorId,
    this.requesterId,
    this.approvalStatus,
    this.reasonForRejection,
    this.requestNotes,
    this.rejectionNotes,
    this.perennial,
    this.medianLifespan,
    this.medianDaysToFirstHarvest,
    this.medianDaysToLastHarvest,
    this.openfarmData,
    this.harvestsCount,
    this.photoAssociationsCount,
    this.plantings,
    this.scientificNames,
    this.alternateNames,
  });

  int? id;
  String? name;
  String? enWikipediaUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? slug;
  dynamic parentId;
  int? plantingsCount;
  int? creatorId;
  dynamic requesterId;
  String? approvalStatus;
  dynamic reasonForRejection;
  dynamic requestNotes;
  dynamic rejectionNotes;
  bool? perennial;
  int? medianLifespan;
  int? medianDaysToFirstHarvest;
  int? medianDaysToLastHarvest;
  OpenfarmData? openfarmData;
  int? harvestsCount;
  int? photoAssociationsCount;
  List<dynamic>? plantings;
  List<ScientificName>? scientificNames;
  List<dynamic>? alternateNames;

  factory PlantDetailResponse.fromJson(Map<String, dynamic> json) => PlantDetailResponse(
        id: json["id"],
        name: json["name"],
        enWikipediaUrl: json["en_wikipedia_url"],
        createdAt: DateTime.tryParse(json["created_at"]),
        updatedAt: DateTime.tryParse(json["updated_at"]),
        slug: json["slug"],
        parentId: json["parent_id"],
        plantingsCount: json["plantings_count"],
        creatorId: json["creator_id"],
        requesterId: json["requester_id"],
        approvalStatus: json["approval_status"],
        reasonForRejection: json["reason_for_rejection"],
        requestNotes: json["request_notes"],
        rejectionNotes: json["rejection_notes"],
        perennial: json["perennial"],
        medianLifespan: json["median_lifespan"],
        medianDaysToFirstHarvest: json["median_days_to_first_harvest"],
        medianDaysToLastHarvest: json["median_days_to_last_harvest"],
        openfarmData: json["openfarm_data"] == null ? null : OpenfarmData.fromJson(json["openfarm_data"]),
        harvestsCount: json["harvests_count"],
        photoAssociationsCount: json["photo_associations_count"],
        plantings: json["plantings"] == null ? [] : List<dynamic>.from(json["plantings"].map((x) => x)),
        scientificNames: json["scientific_names"] == null
            ? []
            : List<ScientificName>.from(
                json["scientific_names"].map((x) => ScientificName.fromJson(x)),
              ),
        alternateNames:
            json["alternate_names"] == null ? [] : List<dynamic>.from(json["alternate_names"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "en_wikipedia_url": enWikipediaUrl,
        "created_at": createdAt!.toIso8601String(),
        "updated_at": updatedAt!.toIso8601String(),
        "slug": slug,
        "parent_id": parentId,
        "plantings_count": plantingsCount,
        "creator_id": creatorId,
        "requester_id": requesterId,
        "approval_status": approvalStatus,
        "reason_for_rejection": reasonForRejection,
        "request_notes": requestNotes,
        "rejection_notes": rejectionNotes,
        "perennial": perennial,
        "median_lifespan": medianLifespan,
        "median_days_to_first_harvest": medianDaysToFirstHarvest,
        "median_days_to_last_harvest": medianDaysToLastHarvest,
        "openfarm_data": openfarmData!.toJson(),
        "harvests_count": harvestsCount,
        "photo_associations_count": photoAssociationsCount,
        "plantings": List<dynamic>.from(plantings!.map((x) => x)),
        "scientific_names": List<dynamic>.from(scientificNames!.map((x) => x.toJson())),
        "alternate_names": List<dynamic>.from(alternateNames!.map((x) => x)),
      };
}

class OpenfarmData {
  OpenfarmData({
    this.id,
    this.type,
    this.links,
    this.attributes,
    this.relationships,
  });

  String? id;
  String? type;
  OpenfarmDataLinks? links;
  Attributes? attributes;
  Relationships? relationships;

  factory OpenfarmData.fromJson(Map<String, dynamic> json) => OpenfarmData(
        id: json["id"],
        type: json["type"],
        links: OpenfarmDataLinks.fromJson(json["links"]),
        attributes: Attributes.fromJson(json["attributes"]),
        relationships: Relationships.fromJson(json["relationships"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "links": links!.toJson(),
        "attributes": attributes!.toJson(),
        "relationships": relationships!.toJson(),
      };
}

class Attributes {
  Attributes({
    this.name,
    this.slug,
    this.taxon,
    this.height,
    this.spread,
    this.svgIcon,
    this.tagsArray,
    this.description,
    this.rowSpacing,
    this.commonNames,
    this.guidesCount,
    this.binomialName,
    this.sowingMethod,
    this.mainImagePath,
    this.sunRequirements,
    this.growingDegreeDays,
    this.processingPictures,
  });

  String? name;
  String? slug;
  String? taxon;
  int? height;
  int? spread;
  String? svgIcon;
  List<dynamic>? tagsArray;
  String? description;
  dynamic rowSpacing;
  dynamic commonNames;
  int? guidesCount;
  String? binomialName;
  String? sowingMethod;
  String? mainImagePath;
  String? sunRequirements;
  dynamic growingDegreeDays;
  int? processingPictures;

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        name: json["name"],
        slug: json["slug"],
        taxon: json["taxon"],
        height: json["height"],
        spread: json["spread"],
        svgIcon: json["svg_icon"],
        tagsArray: List<dynamic>.from(json["tags_array"].map((x) => x)),
        description: json["description"],
        rowSpacing: json["row_spacing"],
        commonNames: json["common_names"],
        guidesCount: json["guides_count"],
        binomialName: json["binomial_name"],
        sowingMethod: json["sowing_method"],
        mainImagePath: json["main_image_path"],
        sunRequirements: json["sun_requirements"],
        growingDegreeDays: json["growing_degree_days"],
        processingPictures: json["processing_pictures"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "taxon": taxon,
        "height": height,
        "spread": spread,
        "svg_icon": svgIcon,
        "tags_array": List<dynamic>.from(tagsArray!.map((x) => x)),
        "description": description,
        "row_spacing": rowSpacing,
        "common_names": commonNames,
        "guides_count": guidesCount,
        "binomial_name": binomialName,
        "sowing_method": sowingMethod,
        "main_image_path": mainImagePath,
        "sun_requirements": sunRequirements,
        "growing_degree_days": growingDegreeDays,
        "processing_pictures": processingPictures,
      };
}

class OpenfarmDataLinks {
  OpenfarmDataLinks({
    required this.self,
  });

  Self self;

  factory OpenfarmDataLinks.fromJson(Map<String, dynamic> json) => OpenfarmDataLinks(
        self: Self.fromJson(json["self"]),
      );

  Map<String, dynamic> toJson() => {
        "self": self.toJson(),
      };
}

class Self {
  Self({
    required this.api,
    required this.website,
  });

  String api;
  String website;

  factory Self.fromJson(Map<String, dynamic> json) => Self(
        api: json["api"],
        website: json["website"],
      );

  Map<String, dynamic> toJson() => {
        "api": api,
        "website": website,
      };
}

class Relationships {
  Relationships({
    this.pictures,
    this.companions,
  });

  Companions? pictures;
  Companions? companions;

  factory Relationships.fromJson(Map<String, dynamic> json) => Relationships(
        pictures: Companions.fromJson(json["pictures"]),
        companions: Companions.fromJson(json["companions"]),
      );

  Map<String, dynamic> toJson() => {
        "pictures": pictures!.toJson(),
        "companions": companions!.toJson(),
      };
}

class Companions {
  Companions({
    required this.data,
    required this.links,
  });

  List<Datum> data;
  CompanionsLinks links;

  factory Companions.fromJson(Map<String, dynamic> json) => Companions(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        links: CompanionsLinks.fromJson(json["links"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "links": links.toJson(),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.type,
  });

  String id;
  String type;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
      };
}

class CompanionsLinks {
  CompanionsLinks({
    required this.related,
  });

  String related;

  factory CompanionsLinks.fromJson(Map<String, dynamic> json) => CompanionsLinks(
        related: json["related"],
      );

  Map<String, dynamic> toJson() => {
        "related": related,
      };
}

class ScientificName {
  ScientificName({
    required this.name,
  });

  String name;

  factory ScientificName.fromJson(Map<String, dynamic> json) => ScientificName(
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
