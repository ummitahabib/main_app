// To parse this JSON data, do
//
//     final soilHistoryResponse = soilHistoryResponseFromJson(jsonString);

import 'dart:convert';

SoilHistoryResponse soilHistoryResponseFromJson(String str) => SoilHistoryResponse.fromJson(json.decode(str));

String soilHistoryResponseToJson(SoilHistoryResponse data) => json.encode(data.toJson());

class SoilHistoryResponse {
  SoilHistoryResponse({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory SoilHistoryResponse.fromJson(Map<String, dynamic> json) => SoilHistoryResponse(
        success: json["success"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.statusCode,
    this.isSuccess,
    this.message,
    this.data,
  });

  int? statusCode;
  bool? isSuccess;
  dynamic message;
  List<Datum>? data;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        statusCode: json["StatusCode"],
        isSuccess: json["IsSuccess"],
        message: json["Message"],
        data: List<Datum>.from(json["Data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "StatusCode": statusCode,
        "IsSuccess": isSuccess,
        "Message": message,
        "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.temperature,
    this.surfaceTemperature,
    this.moisture,
    this.date,
    this.temperatureUnit,
    this.moistureUnit,
  });

  double? temperature;
  double? surfaceTemperature;
  double? moisture;
  DateTime? date;
  String? temperatureUnit;
  String? moistureUnit;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        temperature: json["Temperature"].toDouble(),
        surfaceTemperature: json["SurfaceTemperature"].toDouble(),
        moisture: json["Moisture"].toDouble(),
        date: DateTime.parse(json["Date"]),
        temperatureUnit: json["TemperatureUnit"],
        moistureUnit: json["MoistureUnit"],
      );

  Map<String, dynamic> toJson() => {
        "Temperature": temperature,
        "SurfaceTemperature": surfaceTemperature,
        "Moisture": moisture,
        "Date": date!.toIso8601String(),
        "TemperatureUnit": temperatureUnit,
        "MoistureUnit": moistureUnit,
      };
}
