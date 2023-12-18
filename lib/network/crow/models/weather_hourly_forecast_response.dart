// ignore_for_file: constant_identifier_names

import 'dart:convert';

HourlyWeatherForecast getHourlyWeatherForecastFromJson(String str) => HourlyWeatherForecast.fromJson(json.decode(str));

String getHourlyWeatherForecastToJson(HourlyWeatherForecast data) => json.encode(data.toJson());

class HourlyWeatherForecast {
  HourlyWeatherForecast({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  Data? data;

  factory HourlyWeatherForecast.fromJson(Map<String, dynamic> json) => HourlyWeatherForecast(
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
    this.pressureSea,
    this.relativeHumidity,
    this.windSpeed,
    this.windDirection,
    this.cloudCover,
    this.precipitation,
    this.date,
    this.weatherStatus,
    this.description,
    this.icon,
    this.uvi,
  });

  int? temperature;
  int? pressureSea;
  int? relativeHumidity;
  int? windSpeed;
  int? windDirection;
  int? cloudCover;
  double? precipitation;
  int? date;
  WeatherStatus? weatherStatus;
  Description? description;
  String? icon;
  int? uvi;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        temperature: json["Temperature"],
        pressureSea: json["PressureSea"],
        relativeHumidity: json["RelativeHumidity"],
        windSpeed: json["WindSpeed"],
        windDirection: json["WindDirection"],
        cloudCover: json["CloudCover"],
        precipitation: json["Precipitation"].toDouble(),
        date: json["Date"],
        weatherStatus: weatherStatusValues.map[json["WeatherStatus"]],
        description: descriptionValues.map[json["Description"]],
        icon: json["Icon"],
        uvi: json["UVI"],
      );

  Map<String, dynamic> toJson() => {
        "Temperature": temperature,
        "PressureSea": pressureSea,
        "RelativeHumidity": relativeHumidity,
        "WindSpeed": windSpeed,
        "WindDirection": windDirection,
        "CloudCover": cloudCover,
        "Precipitation": precipitation,
        "Date": date,
        "WeatherStatus": weatherStatusValues.reverse[weatherStatus],
        "Description": descriptionValues.reverse[description],
        "Icon": icon,
        "UVI": uvi,
      };
}

enum Description { PARTLY_CLOUDY, CLOUDY_PARTLY_SUNNY, HEAVY_RAIN, CLEAR_SKY }

final descriptionValues = EnumValues({
  "Clear Sky": Description.CLEAR_SKY,
  "Cloudy / Partly Sunny": Description.CLOUDY_PARTLY_SUNNY,
  "Heavy Rain": Description.HEAVY_RAIN,
  "Partly Cloudy": Description.PARTLY_CLOUDY
});

enum WeatherStatus { PARTLY_CLOUDY_DAY, RAIN }

final weatherStatusValues =
    EnumValues({"partly-cloudy-day": WeatherStatus.PARTLY_CLOUDY_DAY, "rain": WeatherStatus.RAIN});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    return reverseMap;
  }
}
