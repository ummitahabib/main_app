// To parse this JSON data, do
//
//     final soilHistory = soilHistoryFromJson(jsonString);

import 'dart:convert';

SoilHistory soilHistoryFromJson(String str) => SoilHistory.fromJson(json.decode(str));

String soilHistoryToJson(SoilHistory data) => json.encode(data.toJson());

class SoilHistory {
  int dt;
  double t10;
  double moisture;
  double t0;

  SoilHistory({
    required this.dt,
    required this.t10,
    required this.moisture,
    required this.t0,
  });

  factory SoilHistory.fromJson(Map<String, dynamic> json) => SoilHistory(
        dt: json["dt"].toInt(),
        t10: json["t10"].toDouble(),
        moisture: json["moisture"].toDouble(),
        t0: json["t0"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "t10": t10,
        "moisture": moisture,
        "t0": t0,
      };
}
