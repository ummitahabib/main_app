// To parse this JSON data, do
//
//     final weatherHistory = weatherHistoryFromJson(jsonString);

import 'dart:convert';

WeatherHistory weatherHistoryFromJson(String str) => WeatherHistory.fromJson(json.decode(str));

String weatherHistoryToJson(WeatherHistory data) => json.encode(data.toJson());

class WeatherHistory {
  int dt;
  List<Weather> weather;
  Main main;
  Wind wind;
  Rain? rain;
  Clouds clouds;

  WeatherHistory({
    required this.dt,
    required this.weather,
    required this.main,
    required this.wind,
    this.rain,
    required this.clouds,
  });

  factory WeatherHistory.fromJson(Map<String, dynamic> json) => WeatherHistory(
        dt: json["dt"].toInt(),
        weather: List<Weather>.from(json["weather"].map((x) => Weather.fromJson(x))),
        main: Main.fromJson(json["main"]),
        wind: Wind.fromJson(json["wind"]),
        rain: json["rain"] == null ? null : Rain.fromJson(json["rain"]),
        clouds: Clouds.fromJson(json["clouds"]),
      );

  Map<String, dynamic> toJson() => {
        "dt": dt,
        "weather": List<dynamic>.from(weather.map((x) => x.toJson())),
        "main": main.toJson(),
        "wind": wind.toJson(),
        "rain": rain!.toJson(),
        "clouds": clouds.toJson(),
      };
}

class Clouds {
  double all;

  Clouds({
    required this.all,
  });

  factory Clouds.fromJson(Map<String, dynamic> json) => Clouds(
        all: json["all"] ?? 0.00,
      );

  Map<String, dynamic> toJson() => {
        "all": all,
      };
}

class Main {
  double temp;
  double feelsLike;
  double pressure;
  double humidity;
  double tempMin;
  double tempMax;
  double seaLevel;
  double grndLevel;
  double tempKf;

  Main({
    required this.temp,
    required this.feelsLike,
    required this.pressure,
    required this.humidity,
    required this.tempMin,
    required this.tempMax,
    required this.seaLevel,
    required this.grndLevel,
    required this.tempKf,
  });

  factory Main.fromJson(Map<String, dynamic> json) => Main(
        temp: json["temp"].toDouble(),
        feelsLike: json["feels_like"].toDouble(),
        pressure: json["pressure"].toDouble(),
        humidity: json["humidity"].toDouble(),
        tempMin: json["temp_min"].toDouble(),
        tempMax: json["temp_max"].toDouble(),
        seaLevel: json["sea_level"] ?? 0.0,
        grndLevel: json["grnd_level"] ?? 0.0,
        tempKf: json["temp_kf"] ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "temp": temp,
        "feels_like": feelsLike,
        "pressure": pressure,
        "humidity": humidity,
        "temp_min": tempMin,
        "temp_max": tempMax,
        "sea_level": seaLevel,
        "grnd_level": grndLevel,
        "temp_kf": tempKf,
      };
}

class Rain {
  double the1H;

  Rain({
    required this.the1H,
  });

  factory Rain.fromJson(Map<String, dynamic> json) => Rain(
        the1H: json["1h"] ?? 0.00,
      );

  Map<String, dynamic> toJson() => {
        "1h": the1H,
      };
}

class Weather {
  int id;
  String main;
  String description;
  String icon;

  Weather({
    required this.id,
    required this.main,
    required this.description,
    required this.icon,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        id: json["id"].toInt(),
        main: json["main"],
        description: json["description"],
        icon: json["icon"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "main": main,
        "description": description,
        "icon": icon,
      };
}

class Wind {
  double speed;
  double deg;
  double gust;

  Wind({
    required this.speed,
    required this.deg,
    required this.gust,
  });

  factory Wind.fromJson(Map<String, dynamic> json) => Wind(
        speed: json["speed"].toDouble(),
        deg: json["deg"].toDouble(),
        gust: json["gust"] ?? 0.00,
      );

  Map<String, dynamic> toJson() => {
        "speed": speed,
        "deg": deg,
        "gust": gust,
      };
}
