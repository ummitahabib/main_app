import 'dart:convert';

GeoJson geoJsonFromJson(String str) => GeoJson.fromJson(json.decode(str));

String geoJsonToJson(GeoJson data) => json.encode(data.toJson());

class GeoJson {
  GeoJson({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<List<List<double>>> coordinates;

  factory GeoJson.fromJson(Map<String, dynamic> json) => GeoJson(
        type: json["type"],
        coordinates: List<List<List<double>>>.from(
          json["coordinates"].map(
            (x) => List<List<double>>.from(
              x.map((x) => List<double>.from(x.map((x) => x.toDouble()))),
            ),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(
          coordinates.map(
            (x) => List<dynamic>.from(
              x.map((x) => List<dynamic>.from(x.map((x) => x))),
            ),
          ),
        ),
      };
}
