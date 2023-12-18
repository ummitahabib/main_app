import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import 'afex_commodity_data_model.dart';

//Afex commodity datum model

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
        commodityCode: json[datumModel.commodityCode],
        marketPrice: json[datumModel.marketPrice].toDouble(),
        changePercentage: json[datumModel.changePercentage].toDouble(),
        type: typeValues.map![json[datumModel.type]],
        date: DateTime.parse(json[datumModel.date]),
      );

  Map<String, dynamic> toJson() => {
        datumModel.commodityCode: commodityCode,
        datumModel.marketPrice: marketPrice,
        datumModel.changePercentage: changePercentage,
        datumModel.type: typeValues.reverse[type],
        datumModel.date:
            "${date!.year.toString().padLeft(SpacingConstants.int4, datumModel.string0)}-${date!.month.toString().padLeft(SpacingConstants.int2, datumModel.string0)}-${date!.day.toString().padLeft(SpacingConstants.int2, datumModel.string0)}",
      };
}
