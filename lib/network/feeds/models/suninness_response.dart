// To parse this JSON data, do
//
//     final sunninessResponse = sunninessResponseFromJson(jsonString);

import 'dart:convert';

SunninessResponse sunninessResponseFromJson(String str) => SunninessResponse.fromJson(json.decode(str));

String sunninessResponseToJson(SunninessResponse data) => json.encode(data.toJson());

class SunninessResponse {
  SunninessResponse({
    this.semiShade,
    this.shade,
    this.sun,
  });

  int? semiShade;
  int? shade;
  int? sun;

  factory SunninessResponse.fromJson(Map<String, dynamic> json) => SunninessResponse(
        semiShade: json["semi-shade"],
        shade: json["shade"],
        sun: json["sun"],
      );

  Map<String, dynamic> toJson() => {
        "semi-shade": semiShade,
        "shade": shade,
        "sun": sun,
      };
}
