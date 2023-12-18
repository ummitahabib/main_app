// To parse this JSON data, do
//
//     final getMissionsInSite = getMissionsInSiteFromJson(jsonString);

import 'dart:convert';

List<GetMissionsInSite> getMissionsInSiteFromJson(String str) => List<GetMissionsInSite>.from(
      json.decode(str).map((x) => GetMissionsInSite.fromJson(x)),
    );

String getMissionsInSiteToJson(List<GetMissionsInSite> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetMissionsInSite {
  GetMissionsInSite({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.agent,
    this.organization,
    this.site,
    this.progress,
    this.samples,
  });

  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? description;
  List<dynamic>? agent;
  String? organization;
  String? site;
  String? progress;
  List<dynamic>? samples;

  factory GetMissionsInSite.fromJson(Map<String, dynamic> json) => GetMissionsInSite(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        description: json["description"],
        agent: List<dynamic>.from(json["agent"].map((x) => x)),
        organization: json["organization"],
        site: json["site"],
        progress: json["progress"],
        samples: List<dynamic>.from(json["samples"].map((x) => x)),
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
        "samples": List<dynamic>.from(samples!.map((x) => x)),
      };
}
