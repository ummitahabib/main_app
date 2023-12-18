// To parse this JSON data, do
//
//     final chartSampleData = chartSampleDataFromJson(jsonString);

import 'dart:convert';

ChartModelData chartSampleDataFromJson(String str) => ChartModelData.fromJson(json.decode(str));

String chartSampleDataToJson(ChartModelData data) => json.encode(data.toJson());

class ChartModelData {
  ChartModelData({
    this.x,
    this.y,
    this.text,
  });

  String? x;
  double? y;
  String? text;

  factory ChartModelData.fromJson(Map<String, dynamic> json) => ChartModelData(
        x: json["x"],
        y: json["y"],
        text: json["text"],
      );

  Map<String, dynamic> toJson() => {
        "x": x,
        "y": y,
        "text": text,
      };
}
