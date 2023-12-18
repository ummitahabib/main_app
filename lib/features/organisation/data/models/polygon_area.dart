// To parse this JSON data, do
//
//     final polygonArea = polygonAreaFromJson(jsonString);

import 'dart:convert';

PolygonArea polygonAreaFromJson(String str) => PolygonArea.fromJson(json.decode(str));

String polygonAreaToJson(PolygonArea data) => json.encode(data.toJson());

class PolygonArea {
  String type;
  List<List<List<double>>> geoJson;

  PolygonArea({
    required this.type,
    required this.geoJson,
  });

  factory PolygonArea.fromJson(Map<String, dynamic> json) => PolygonArea(
        type: json["type"],
        geoJson: List<List<List<double>>>.from(
          json["geoJson"]
              .map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x.toDouble()))))),
        ),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(
          geoJson.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x))))),
        ),
      };
}
