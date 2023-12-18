// To parse this JSON data, do
//
//     final afexCommodityResponse = afexCommodityResponseFromJson(jsonString);

// ignore_for_file: constant_identifier_names

import 'dart:convert';

import '../../../features/data/models/afex_commodity/enum_values.dart';

AfexCommodityResponse afexCommodityResponseFromJson(String str) => AfexCommodityResponse.fromJson(json.decode(str));

String afexCommodityResponseToJson(AfexCommodityResponse data) => json.encode(data.toJson());

class AfexCommodityResponse {
  AfexCommodityResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory AfexCommodityResponse.fromJson(Map<String, dynamic> json) => AfexCommodityResponse(
        status: json["status"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data.toJson(),
      };
}

class Data {
  Data({
    this.responseCode,
    this.data,
    this.message,
  });

  String? responseCode;
  List<Datum>? data;
  String? message;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        responseCode: json["responseCode"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "responseCode": responseCode,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
      };
}

class Datum {
  Datum({
    this.commodityCode,
    this.marketPrice,
    this.changePercentage,
    this.type,
    this.date,
  });

  dynamic commodityCode;
  double? marketPrice;
  double? changePercentage;
  Type? type;
  DateTime? date;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        commodityCode: json["commodityCode"],
        marketPrice: json["marketPrice"].toDouble(),
        changePercentage: json["changePercentage"].toDouble(),
        type: typeValues.map![json["type"]],
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "commodityCode": commodityCode,
        "marketPrice": marketPrice,
        "changePercentage": changePercentage,
        "type": typeValues.reverse[type],
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      };
}

enum Type { BUY, SELL, EMPTY }

final typeValues = EnumValues({"Buy": Type.BUY, "": Type.EMPTY, "Sell": Type.SELL});
