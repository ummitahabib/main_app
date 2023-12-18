// To parse this JSON data, do
//
//     final getOrganizationSites = getOrganizationSitesFromJson(jsonString);

import 'dart:convert';

List<GetOrganizationSites> getOrganizationSitesFromJson(String str) => List<GetOrganizationSites>.from(
      json.decode(str).map((x) => GetOrganizationSites.fromJson(x)),
    );

String getOrganizationSitesToJson(List<GetOrganizationSites> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetOrganizationSites {
  GetOrganizationSites({
    this.sectors,
    this.geoJson,
    this.id,
    this.name,
  });

  List<dynamic>? sectors;
  List<List<List<double>>>? geoJson;
  String? id;
  String? name;

  factory GetOrganizationSites.fromJson(Map<String, dynamic> json) => GetOrganizationSites(
        sectors: List<dynamic>.from(json["sectors"].map((x) => x)),
        geoJson: List<List<List<double>>>.from(
          json["geoJson"].map(
            (x) => List<List<double>>.from(
              x.map((x) => List<double>.from(x.map((x) => x.toDouble()))),
            ),
          ),
        ),
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "sectors": List<dynamic>.from(sectors!.map((x) => x)),
        "geoJson": List<dynamic>.from(
          geoJson!.map(
            (x) => List<dynamic>.from(
              x.map((x) => List<dynamic>.from(x.map((x) => x))),
            ),
          ),
        ),
        "_id": id,
        "name": name,
      };
}
