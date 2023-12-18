// To parse this JSON data, do
//
//     final createSiteRequest = createSiteRequestFromJson(jsonString);

import 'dart:convert';

CreateSiteRequest createSiteRequestFromJson(String str) => CreateSiteRequest.fromJson(json.decode(str));

String createSiteRequestToJson(CreateSiteRequest data) => json.encode(data.toJson());

class CreateSiteRequest {
  CreateSiteRequest({
    required this.name,
    required this.geoJson,
    required this.organization,
    required this.polygonId,
  });

  String name;
  List<List<List<double>>> geoJson;
  String organization;
  String polygonId;

  factory CreateSiteRequest.fromJson(Map<String, dynamic> json) => CreateSiteRequest(
        name: json["name"],
        geoJson: List<List<List<double>>>.from(
          json["geoJson"].map(
            (x) => List<List<double>>.from(
              x.map((x) => List<double>.from(x.map((x) => x.toDouble()))),
            ),
          ),
        ),
        organization: json["organization"],
        polygonId: json['polygonId'],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "geoJson": List<dynamic>.from(
          geoJson.map(
            (x) => List<dynamic>.from(
              x.map((x) => List<dynamic>.from(x.map((x) => x))),
            ),
          ),
        ),
        "organization": organization,
        "polygonId": polygonId
      };
}
