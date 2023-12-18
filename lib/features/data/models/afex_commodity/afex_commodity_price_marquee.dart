import 'dart:convert';

import 'package:smat_crow/utils2/constants.dart';

import 'afex_commodity_data_model.dart';

//Afex commodity  price marquee Response

AfexCommodityResponse afexCommodityResponseFromJson(String str) =>
    AfexCommodityResponse.fromJson(json.decode(str));

String afexCommodityResponseToJson(AfexCommodityResponse data) =>
    json.encode(data.toJson());

class AfexCommodityResponse {
  AfexCommodityResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  String status;
  String message;
  Data data;

  factory AfexCommodityResponse.fromJson(Map<String, dynamic> json) =>
      AfexCommodityResponse(
        status: json[AfexCommodityModel.status],
        message: json[AfexCommodityModel.message],
        data: Data.fromJson(json[AfexCommodityModel.data]),
      );

  Map<String, dynamic> toJson() => {
        AfexCommodityModel.status: status,
        AfexCommodityModel.message: message,
        AfexCommodityModel.data: data.toJson(),
      };
}
