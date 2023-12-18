// To parse this JSON data, do
//
//     final getMissionsForAgent = getMissionsForAgentFromJson(jsonString);

import 'dart:convert';

List<GetMissionsForAgent> getMissionsForAgentFromJson(String str) => List<GetMissionsForAgent>.from(
      json.decode(str).map((x) => GetMissionsForAgent.fromJson(x)),
    );

String getMissionsForAgentToJson(List<GetMissionsForAgent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetMissionsForAgent {
  GetMissionsForAgent({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.agent,
    this.organization,
    this.site,
    this.progress,
    this.scheduledDate,
    this.samples,
  });

  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? description;
  List<String>? agent;
  String? organization;
  String? site;
  String? progress;
  dynamic scheduledDate;
  List<Sample>? samples;

  factory GetMissionsForAgent.fromJson(Map<String, dynamic> json) => GetMissionsForAgent(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        description: json["description"],
        agent: List<String>.from(json["agent"].map((x) => x)),
        organization: json["organization"],
        site: json["site"],
        progress: json["progress"],
        scheduledDate: json["scheduledDate"],
        samples: List<Sample>.from(json["samples"].map((x) => Sample.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "name": name,
        "description": description,
        "agent": List<dynamic>.from(agent!.map((x) => x)),
        "organization": organization,
        "site": site,
        "progress": progress,
        "scheduledDate": scheduledDate,
        "samples": List<dynamic>.from(samples!.map((x) => x.toJson())),
      };
}

class Sample {
  Sample({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.image,
    this.soilType,
    this.sampleDepth,
    this.site,
    this.coordinates,
  });

  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  dynamic image;
  String? soilType;
  int? sampleDepth;
  String? site;
  Coordinates? coordinates;

  factory Sample.fromJson(Map<String, dynamic> json) => Sample(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        image: json["image"],
        soilType: json["soilType"],
        sampleDepth: json["sampleDepth"],
        site: json["site"],
        coordinates: Coordinates.fromJson(json["coordinates"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "name": name,
        "image": image,
        "soilType": soilType,
        "sampleDepth": sampleDepth,
        "site": site,
        "coordinates": coordinates!.toJson(),
      };
}

class Coordinates {
  Coordinates({
    required this.lat,
    required this.lng,
  });

  String lat;
  String lng;

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
