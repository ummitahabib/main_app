// To parse this JSON data, do
//
//     final getOrganizationSectors = getOrganizationSectorsFromJson(jsonString);

import 'dart:convert';

List<GetOrganizationSectors> getOrganizationSectorsFromJson(String str) => List<GetOrganizationSectors>.from(
      json.decode(str).map((x) => GetOrganizationSectors.fromJson(x)),
    );

String getOrganizationSectorsToJson(List<GetOrganizationSectors> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetOrganizationSectors {
  GetOrganizationSectors({
    required this.batches,
    required this.sectorCoordinates,
    required this.id,
    required this.name,
  });

  List<dynamic> batches;
  List<List<List<double>>> sectorCoordinates;
  String id;
  String name;

  factory GetOrganizationSectors.fromJson(Map<String, dynamic> json) => GetOrganizationSectors(
        batches: List<dynamic>.from(json["batches"].map((x) => x)),
        sectorCoordinates: List<List<List<double>>>.from(
          json["sectorCoordinates"].map(
            (x) => List<List<double>>.from(
              x.map((x) => List<double>.from(x.map((x) => x.toDouble()))),
            ),
          ),
        ),
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "batches": List<dynamic>.from(batches.map((x) => x)),
        "sectorCoordinates": List<dynamic>.from(
          sectorCoordinates.map(
            (x) => List<dynamic>.from(
              x.map((x) => List<dynamic>.from(x.map((x) => x))),
            ),
          ),
        ),
        "_id": id,
        "name": name,
      };
}
