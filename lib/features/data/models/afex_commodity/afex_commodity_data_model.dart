// ignore_for_file: constant_identifier_names

import 'package:smat_crow/utils2/constants.dart';

import 'afex_commodity_datum_model.dart';
import 'enum_values.dart';

//Afex commodity data model

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
        responseCode: json[dataModel.responseCode],
        data: json[dataModel.data] == null
            ? []
            : List<Datum>.from(
                json[dataModel.data].map((x) => Datum.fromJson(x)),
              ),
        message: json[dataModel.message],
      );

  Map<String, dynamic> toJson() => {
        dataModel.responseCode: responseCode,
        dataModel.data: List<dynamic>.from(data!.map((x) => x.toJson())),
        dataModel.message: message,
      };
}

enum Type { BUY, SELL, EMPTY }

final typeValues = EnumValues({buy: Type.BUY, doubleEmptyString: Type.EMPTY, sell: Type.SELL});
