// To parse this JSON data, do
//
//     final plantedResponse = plantedResponseFromJson(jsonString);

import 'dart:convert';

PlantedResponse plantedResponseFromJson(String str) => PlantedResponse.fromJson(json.decode(str));

String plantedResponseToJson(PlantedResponse data) => json.encode(data.toJson());

class PlantedResponse {
  PlantedResponse({
    this.advancedPlant,
    this.bareRootPlant,
    this.seed,
    this.seedling,
  });

  int? advancedPlant;
  int? bareRootPlant;
  int? seed;
  int? seedling;

  factory PlantedResponse.fromJson(Map<String, dynamic> json) => PlantedResponse(
        advancedPlant: json["advanced plant"],
        bareRootPlant: json["bare root plant"],
        seed: json["seed"],
        seedling: json["seedling"],
      );

  Map<String, dynamic> toJson() => {
        "advanced plant": advancedPlant,
        "bare root plant": bareRootPlant,
        "seed": seed,
        "seedling": seedling,
      };
}
