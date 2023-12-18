class SiteById {
  List<dynamic> sectors;
  List<List<List<double>>> geoJson;
  String id;
  String name;
  String polygonId;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  SiteById({
    required this.sectors,
    required this.geoJson,
    required this.id,
    required this.name,
    required this.polygonId,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SiteById.fromJson(Map<String, dynamic> json) => SiteById(
        sectors: List<dynamic>.from(json["sectors"].map((x) => x)),
        geoJson: List<List<List<double>>>.from(
          json["geoJson"]
              .map((x) => List<List<double>>.from(x.map((x) => List<double>.from(x.map((x) => x.toDouble()))))),
        ),
        id: json["_id"],
        name: json["name"],
        polygonId: json["polygonId"] ?? "0",
        createdAt: json["createdAt"] == null ? DateTime.now() : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? DateTime.now() : DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "sectors": List<dynamic>.from(sectors.map((x) => x)),
        "geoJson": List<dynamic>.from(
          geoJson.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x))))),
        ),
        "_id": id,
        "name": name,
        "docktarPolygonId": polygonId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
