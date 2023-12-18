// To parse this JSON data, do
//
//     final getSectorById = getSectorByIdFromJson(jsonString);

import 'dart:convert';

GetSectorById getSectorByIdFromJson(String str) => GetSectorById.fromJson(json.decode(str));

String getSectorByIdToJson(GetSectorById data) => json.encode(data.toJson());

class GetSectorById {
  GetSectorById({
    required this.batches,
    required this.sectorCoordinates,
    required this.id,
    required this.name,
    required this.v,
  });

  List<dynamic> batches;
  List<List<List<double>>> sectorCoordinates;
  String id;
  String name;
  int v;

  factory GetSectorById.fromJson(Map<String, dynamic> json) => GetSectorById(
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
        v: json["__v"],
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
        "__v": v,
      };
}
