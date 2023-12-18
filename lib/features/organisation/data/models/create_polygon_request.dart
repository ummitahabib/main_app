class CreatePolygonRequest {
  GeoJson geoJson;
  String name;

  CreatePolygonRequest({
    required this.geoJson,
    required this.name,
  });

  factory CreatePolygonRequest.fromJson(Map<String, dynamic> json) => CreatePolygonRequest(
        geoJson: GeoJson.fromJson(json["geoJson"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "geoJson": geoJson.toJson(),
        "name": name,
      };
}

class GeoJson {
  Geometry geometry;
  String type;

  GeoJson({
    required this.geometry,
    required this.type,
  });

  factory GeoJson.fromJson(Map<String, dynamic> json) => GeoJson(
        geometry: Geometry.fromJson(json["geometry"]),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "geometry": geometry.toJson(),
        "type": type,
      };
}

class Geometry {
  List<List<List<double>>> coordinates;
  String type;

  Geometry({
    required this.coordinates,
    required this.type,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        coordinates: List<List<List<double>>>.from(
          json["coordinates"].map((x) => List<List<int>>.from(x.map((x) => List<int>.from(x.map((x) => x))))),
        ),
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(
          coordinates.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x))))),
        ),
        "type": type,
      };
}
