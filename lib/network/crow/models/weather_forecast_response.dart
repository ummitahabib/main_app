import 'dart:convert';

WeatherForecastResponse getWeatherForecastFromJson(String str) => WeatherForecastResponse.fromJson(json.decode(str));

String getWeatherForecastToJson(WeatherForecastResponse data) => json.encode(data.toJson());

class WeatherForecastResponse {
  WeatherForecastResponse({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory WeatherForecastResponse.fromJson(Map<String, dynamic> json) => WeatherForecastResponse(
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
    this.maxTemperature,
    this.minTemperature,
    this.pressureSea,
    this.relativeHumidity,
    this.windSpeed,
    this.windDirection,
    this.cloudCover,
    this.precipitation,
    this.forecastDate,
    this.dataCalculationDate,
    this.weatherStatus,
    this.description,
    this.icon,
    this.uvi,
  });

  int? maxTemperature;
  int? minTemperature;
  int? pressureSea;
  int? relativeHumidity;
  int? windSpeed;
  int? windDirection;
  int? cloudCover;
  double? precipitation;
  int? forecastDate;
  int? dataCalculationDate;
  String? weatherStatus;
  String? description;
  String? icon;
  int? uvi;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        maxTemperature: json["MaxTemperature"],
        minTemperature: json["MinTemperature"],
        pressureSea: json["PressureSea"],
        relativeHumidity: json["RelativeHumidity"],
        windSpeed: json["WindSpeed"],
        windDirection: json["WindDirection"],
        cloudCover: json["CloudCover"],
        precipitation: json["Precipitation"].toDouble(),
        forecastDate: json["ForecastDate"],
        dataCalculationDate: json["DataCalculationDate"],
        weatherStatus: json["WeatherStatus"],
        description: json["Description"],
        icon: json["Icon"],
        uvi: json["UVI"],
      );

  Map<String, dynamic> toJson() => {
        "MaxTemperature": maxTemperature,
        "MinTemperature": minTemperature,
        "PressureSea": pressureSea,
        "RelativeHumidity": relativeHumidity,
        "WindSpeed": windSpeed,
        "WindDirection": windDirection,
        "CloudCover": cloudCover,
        "Precipitation": precipitation,
        "ForecastDate": forecastDate,
        "DataCalculationDate": dataCalculationDate,
        "WeatherStatus": weatherStatus,
        "Description": description,
        "Icon": icon,
        "UVI": uvi,
      };
}
