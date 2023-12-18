import 'dart:convert';

WeedCountResponse weedCountResponseFromJson(String str) => WeedCountResponse.fromJson(json.decode(str));

String weedCountResponseToJson(WeedCountResponse data) => json.encode(data.toJson());

class WeedCountResponse {
  WeedCountResponse({
    this.success,
    this.resultUrl,
    this.data,
  });

  bool? success;
  String? resultUrl;
  Data? data;

  factory WeedCountResponse.fromJson(Map<String, dynamic> json) => WeedCountResponse(
        success: json["success"],
        resultUrl: json["resultUrl"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "resultUrl": resultUrl,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.path,
    this.weedCount,
    this.filename,
  });

  String? path;
  String? weedCount;
  String? filename;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        path: json["Path"],
        weedCount: json["WeedCount"],
        filename: json["filename"],
      );

  Map<String, dynamic> toJson() => {
        "Path": path,
        "WeedCount": weedCount,
        "filename": filename,
      };
}
