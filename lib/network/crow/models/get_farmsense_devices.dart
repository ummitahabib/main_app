// To parse this JSON data, do
//
//     final userDevicesResponse = userDevicesResponseFromJson(jsonString);

import 'dart:convert';

List<UserDevicesResponse> userDevicesResponseFromJson(String str) => List<UserDevicesResponse>.from(
      json.decode(str).map((x) => UserDevicesResponse.fromJson(x)),
    );

String userDevicesResponseToJson(List<UserDevicesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UserDevicesResponse {
  UserDevicesResponse({
    this.id,
    this.details,
    this.settingsId,
    this.notifyName,
    this.notifyDestroy,
    this.notifyStop,
    this.notifyStart,
    this.shortDescription,
    this.longDescription,
    this.deviceId,
    this.userId,
    this.deviceName,
    this.name,
    this.v,
  });

  String? id;
  List<Detail>? details;
  String? settingsId;
  String? notifyName;
  bool? notifyDestroy;
  bool? notifyStop;
  bool? notifyStart;
  String? shortDescription;
  String? longDescription;
  String? deviceId;
  String? userId;
  String? deviceName;
  String? name;
  int? v;

  factory UserDevicesResponse.fromJson(Map<String, dynamic> json) => UserDevicesResponse(
        id: json["_id"],
        details: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
        settingsId: json["settingsId"],
        notifyName: json["notifyName"],
        notifyDestroy: json["notifyDestroy"],
        notifyStop: json["notifyStop"],
        notifyStart: json["notifyStart"],
        shortDescription: json["shortDescription"],
        longDescription: json["longDescription"],
        deviceId: json["deviceId"],
        userId: json["userId"],
        deviceName: json["deviceName"],
        name: json["name"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "details": List<dynamic>.from(details!.map((x) => x.toJson())),
        "settingsId": settingsId,
        "notifyName": notifyName,
        "notifyDestroy": notifyDestroy,
        "notifyStop": notifyStop,
        "notifyStart": notifyStart,
        "shortDescription": shortDescription,
        "longDescription": longDescription,
        "deviceId": deviceId,
        "userId": userId,
        "deviceName": deviceName,
        "name": name,
        "__v": v,
      };
}

class Detail {
  Detail({
    this.id,
    this.time,
    this.deviceCoordinates,
    this.backUpSupply,
    this.mainSupply,
    this.power,
    this.temperature,
    this.moisture,
    this.v,
    this.humidity,
    this.batteryPercentage,
    this.latitude,
    this.longitude,
    this.ti,
    this.la,
    this.lo,
    this.bs,
    this.ms,
    this.p,
    this.bp,
    this.h,
    this.t,
    this.m,
  });

  String? id;
  DateTime? time;
  List<double>? deviceCoordinates;
  bool? backUpSupply;
  bool? mainSupply;
  bool? power;
  String? temperature;
  String? moisture;
  int? v;
  String? humidity;
  String? batteryPercentage;
  double? latitude;
  double? longitude;
  DateTime? ti;
  double? la;
  double? lo;
  bool? bs;
  bool? ms;
  bool? p;
  String? bp;
  String? h;
  String? t;
  String? m;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
        id: json["_id"],
        time: json["time"] == null ? null : DateTime.parse(json["time"]),
        deviceCoordinates: json["deviceCoordinates"] == null
            ? null
            : List<double>.from(
                json["deviceCoordinates"].map((x) => x?.toDouble()),
              ),
        backUpSupply: json["backUpSupply"],
        mainSupply: json["mainSupply"],
        power: json["power"],
        temperature: json["temperature"],
        moisture: json["moisture"],
        v: json["__v"],
        humidity: json["humidity"],
        batteryPercentage: json["batteryPercentage"],
        latitude: json["latitude"] == null ? null : json["latitude"].toDouble(),
        longitude: json["longitude"] == null ? null : json["longitude"].toDouble(),
        ti: json["ti"] == null ? null : DateTime.parse(json["ti"]),
        la: json["la"] == null ? null : json["la"].toDouble(),
        lo: json["lo"] == null ? null : json["lo"].toDouble(),
        bs: json["bs"],
        ms: json["ms"],
        p: json["p"],
        bp: json["bp"],
        h: json["h"],
        t: json["t"],
        m: json["m"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "time": time == null ? null : time!.toIso8601String(),
        "deviceCoordinates": deviceCoordinates == null
            ? null
            : List<dynamic>.from(
                deviceCoordinates!.map((x) => x),
              ),
        "backUpSupply": backUpSupply,
        "mainSupply": mainSupply,
        "power": power,
        "temperature": temperature,
        "moisture": moisture,
        "__v": v,
        "humidity": humidity,
        "batteryPercentage": batteryPercentage,
        "latitude": latitude,
        "longitude": longitude,
        "ti": ti == null ? null : ti!.toIso8601String(),
        "la": la,
        "lo": lo,
        "bs": bs,
        "ms": ms,
        "p": p,
        "bp": bp,
        "h": h,
        "t": t,
        "m": m,
      };
}
