// To parse this JSON data, do
//
//     final createMissionRequest = createMissionRequestFromJson(jsonString);

import 'dart:convert';

CreateMissionRequest createMissionRequestFromJson(String str) => CreateMissionRequest.fromJson(json.decode(str));

String createMissionRequestToJson(CreateMissionRequest data) => json.encode(data.toJson());

class CreateMissionRequest {
  CreateMissionRequest({
    required this.name,
    required this.scheduleDate,
    required this.description,
    required this.organization,
    required this.site,
  });

  String name;
  String scheduleDate;
  String description;
  String organization;
  String site;

  factory CreateMissionRequest.fromJson(Map<String, dynamic> json) => CreateMissionRequest(
        name: json["name"],
        scheduleDate: json["scheduleDate"],
        description: json["description"],
        organization: json["organization"],
        site: json["site"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "scheduleDate": scheduleDate,
        "description": description,
        "organization": organization,
        "site": site,
      };
}
