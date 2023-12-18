// To parse this JSON data, do
//
//     final sectorById = sectorByIdFromJson(jsonString);

import 'dart:convert';

SectorById sectorByIdFromJson(String str) => SectorById.fromJson(json.decode(str));

String sectorByIdToJson(SectorById data) => json.encode(data.toJson());

class SectorById {
  List<dynamic> batches;
  List<List<List<double>>> sectorCoordinates;
  String id;
  String name;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  SectorById({
    required this.batches,
    required this.sectorCoordinates,
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SectorById.fromJson(Map<String, dynamic> json) => SectorById(
        batches: List<dynamic>.from(json["batches"].map((x) => x)),
        sectorCoordinates: List<List<List<double>>>.from(
          json["sectorCoordinates"]
              .map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x.toDouble()))))),
        ),
        id: json["_id"],
        name: json["name"],
        createdAt: json["createdAt"] == null ? DateTime.now() : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? DateTime.now() : DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "batches": List<dynamic>.from(batches.map((x) => x)),
        "sectorCoordinates": List<dynamic>.from(
          sectorCoordinates.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x))))),
        ),
        "_id": id,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
