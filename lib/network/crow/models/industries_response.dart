// To parse this JSON data, do
//
//     final getIndustriesResponse = getIndustriesResponseFromJson(jsonString);

import 'dart:convert';

List<GetIndustriesResponse> getIndustriesResponseFromJson(String str) => List<GetIndustriesResponse>.from(
      json.decode(str).map((x) => GetIndustriesResponse.fromJson(x)),
    );

String getIndustriesResponseToJson(List<GetIndustriesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetIndustriesResponse {
  GetIndustriesResponse({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.name,
    this.description,
    this.industryService,
    this.serviceUrl,
  });

  String? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? name;
  String? description;
  List<GetIndustriesResponse>? industryService;
  String? serviceUrl;

  factory GetIndustriesResponse.fromJson(Map<String, dynamic> json) => GetIndustriesResponse(
        id: json["id"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
        description: json["description"],
        industryService: json["industryService"] == null
            ? null
            : List<GetIndustriesResponse>.from(
                json["industryService"].map((x) => GetIndustriesResponse.fromJson(x)),
              ),
        serviceUrl: json["serviceUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "name": name,
        "description": description,
        "industryService": industryService == null ? null : List<dynamic>.from(industryService!.map((x) => x.toJson())),
        "serviceUrl": serviceUrl,
      };
}
