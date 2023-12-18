import 'dart:convert';

PlantCanopyResponse plantCanopyResponseFromJson(String str) =>
    PlantCanopyResponse.fromJson(json.decode(str));

String plantCanopyResponseToJson(PlantCanopyResponse data) =>
    json.encode(data.toJson());

class PlantCanopyResponse {
  PlantCanopyResponse({
   required this.success,
   required this.data,
  });

  bool success;
  Data data;

  factory PlantCanopyResponse.fromJson(Map<String, dynamic> json) =>
      PlantCanopyResponse(
        success: json["success"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": data.toJson(),
      };
}

class Data {
  Data({
  required  this.plantCanopy,
  });

  String plantCanopy;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        plantCanopy: json["PlantCanopy"],
      );

  Map<String, dynamic> toJson() => {
        "PlantCanopy": plantCanopy,
      };
}
