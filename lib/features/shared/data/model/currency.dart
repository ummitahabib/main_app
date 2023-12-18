// To parse this JSON data, do
//
//     final currency = currencyFromJson(jsonString);

import 'dart:convert';

Currency currencyFromJson(String str) => Currency.fromJson(json.decode(str));

String currencyToJson(Currency data) => json.encode(data.toJson());

class Currency {
  String? symbol;
  String? name;
  String? symbolNative;
  int? decimalDigits;
  int? rounding;
  String? code;
  String? namePlural;

  Currency({
    this.symbol,
    this.name,
    this.symbolNative,
    this.decimalDigits,
    this.rounding,
    this.code,
    this.namePlural,
  });

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
        symbol: json["symbol"],
        name: json["name"],
        symbolNative: json["symbol_native"],
        decimalDigits: json["decimal_digits"],
        rounding: json["rounding"],
        code: json["code"],
        namePlural: json["name_plural"],
      );

  Map<String, dynamic> toJson() => {
        "symbol": symbol,
        "name": name,
        "symbol_native": symbolNative,
        "decimal_digits": decimalDigits,
        "rounding": rounding,
        "code": code,
        "name_plural": namePlural,
      };
}
