// To parse this JSON data, do
//
//     final getFieldAgentStatisticsResponse = getFieldAgentStatisticsResponseFromJson(jsonString);

import 'dart:convert';

GetFieldAgentStatisticsResponse getFieldAgentStatisticsResponseFromJson(
  String str,
) =>
    GetFieldAgentStatisticsResponse.fromJson(json.decode(str));

String getFieldAgentStatisticsResponseToJson(
  GetFieldAgentStatisticsResponse data,
) =>
    json.encode(data.toJson());

class GetFieldAgentStatisticsResponse {
  GetFieldAgentStatisticsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  List<Datum> data;

  factory GetFieldAgentStatisticsResponse.fromJson(Map<String, dynamic> json) => GetFieldAgentStatisticsResponse(
        status: json["status"],
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.statisticName,
    this.statisticCount,
  });

  String? statisticName;
  int? statisticCount;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        statisticName: json["statisticName"],
        statisticCount: json["statisticCount"],
      );

  Map<String, dynamic> toJson() => {
        "statisticName": statisticName,
        "statisticCount": statisticCount,
      };
}
