// To parse this JSON data, do
//
//     final getSiteById = getSiteByIdFromJson(jsonString);

import 'dart:convert';

GetSiteById getSiteByIdFromJson(String str) => GetSiteById.fromJson(json.decode(str));

String getSiteByIdToJson(GetSiteById data) => json.encode(data.toJson());

class GetSiteById {
  GetSiteById({
    required this.sectors,
    required this.geoJson,
    required this.id,
    required this.name,
    required this.docktarPolygonId,
    required this.v,
  });

  List<dynamic> sectors;
  List<List<List<double>>> geoJson;
  String id;
  String name;
  int docktarPolygonId;
  int v;

  factory GetSiteById.fromJson(Map<String, dynamic> json) => GetSiteById(
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
        docktarPolygonId: json["docktarPolygonId"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "sectors": List<dynamic>.from(sectors.map((x) => x)),
        "geoJson": List<dynamic>.from(
          geoJson.map(
            (x) => List<dynamic>.from(
              x.map((x) => List<dynamic>.from(x.map((x) => x))),
            ),
          ),
        ),
        "_id": id,
        "name": name,
        "docktarPolygonId": docktarPolygonId,
        "__v": v,
      };
}
