// To parse this JSON data, do
//
//     final pnLResponse = pnLResponseFromJson(jsonString);

import 'dart:convert';

PnLResponse pnLResponseFromJson(String str) => PnLResponse.fromJson(json.decode(str));

String pnLResponseToJson(PnLResponse data) => json.encode(data.toJson());

class PnLResponse {
  String month;
  double income;
  double expense;

  PnLResponse({
    required this.month,
    required this.income,
    required this.expense,
  });

  factory PnLResponse.fromJson(Map<String, dynamic> json) => PnLResponse(
        month: json["month"] ?? "",
        income: json["income"] ?? 0,
        expense: json["expense"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "month": month,
        "income": income,
        "expense": expense,
      };
}
