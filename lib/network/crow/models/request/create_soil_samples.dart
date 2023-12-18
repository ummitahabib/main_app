// To parse this JSON data, do
//
//     final createSoilSamples = createSoilSamplesFromJson(jsonString);

import 'dart:convert';

CreateSoilSamples createSoilSamplesFromJson(String str) => CreateSoilSamples.fromJson(json.decode(str));

String createSoilSamplesToJson(CreateSoilSamples data) => json.encode(data.toJson());

class CreateSoilSamples {
  CreateSoilSamples({
    required this.name,
    required this.coordinate,
    required this.soilType,
    required this.sampleDepth,
    required this.image,
    required this.mission,
    required this.site,
  });

  String name;
  Coordinate coordinate;
  String soilType;
  int sampleDepth;
  String image;
  String mission;
  String site;

  factory CreateSoilSamples.fromJson(Map<String, dynamic> json) => CreateSoilSamples(
        name: json["name"],
        coordinate: Coordinate.fromJson(json["coordinate"]),
        soilType: json["soilType"],
        sampleDepth: json["sampleDepth"],
        image: json["image"],
        mission: json["mission"],
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "coordinate": coordinate.toJson(),
        "soilType": soilType,
        "sampleDepth": sampleDepth,
        "image": image,
        "mission": mission,
        "site": site,
      };
}

class Coordinate {
  Coordinate({
    required this.lat,
    required this.lng,
  });

  double lat;
  double lng;

  factory Coordinate.fromJson(Map<String, dynamic> json) => Coordinate(
        lat: json["lat"],
        lng: json["lng"],
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}
