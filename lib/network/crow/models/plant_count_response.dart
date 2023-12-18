import 'dart:convert';

PlantCountResponse plantCountResponseFromJson(String str) => PlantCountResponse.fromJson(json.decode(str));

String plantCountResponseToJson(PlantCountResponse data) => json.encode(data.toJson());

class PlantCountResponse {
  PlantCountResponse({
    required this.success,
    required this.resultUrl,
    required this.data,
  });

  bool success;
  String resultUrl;
  Data data;

  factory PlantCountResponse.fromJson(Map<String, dynamic> json) => PlantCountResponse(
        success: json["success"],
        resultUrl: json["resultUrl"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "resultUrl": resultUrl,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    required this.path,
    required this.plantCount,
    required this.filename,
  });

  String path;
  String plantCount;
  String filename;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        path: json["Path"],
        plantCount: json["PlantCount"],
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "Path": path,
        "PlantCount": plantCount,
        "filename": filename,
      };
}
