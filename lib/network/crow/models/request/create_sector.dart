// To parse this JSON data, do
//
//     final createSectorRequest = createSectorRequestFromJson(jsonString);

import 'dart:convert';

CreateSectorRequest createSectorRequestFromJson(String str) => CreateSectorRequest.fromJson(json.decode(str));

String createSectorRequestToJson(CreateSectorRequest data) => json.encode(data.toJson());

class CreateSectorRequest {
  CreateSectorRequest({
    required this.name,
    required this.description,
    required this.sectorCoordinates,
    required this.site,
  });

  String name;
  String description;
  List<List<List<double>>> sectorCoordinates;
  String site;

  factory CreateSectorRequest.fromJson(Map<String, dynamic> json) => CreateSectorRequest(
        name: json["name"],
        description: json["description"],
        sectorCoordinates: List<List<List<double>>>.from(
          json["sectorCoordinates"].map(
            (x) => List<List<double>>.from(
              x.map((x) => List<double>.from(x.map((x) => x.toDouble()))),
            ),
          ),
        ),
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "sectorCoordinates": List<dynamic>.from(
          sectorCoordinates.map(
            (x) => List<dynamic>.from(
              x.map((x) => List<dynamic>.from(x.map((x) => x))),
            ),
          ),
        ),
        "site": site,
      };
}
