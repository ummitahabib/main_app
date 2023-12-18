import 'package:smat_crow/utils2/constants.dart';

//afex commodity price response

class CommodityPricesResponse {
  List<Data>? data;
  String? source;
  String? sourceUrl;
  String? sourceDate;

  CommodityPricesResponse({
    this.data,
    this.source,
    this.sourceUrl,
    this.sourceDate,
  });

  CommodityPricesResponse.fromJson(Map<String, dynamic> json) {
    if (json[CommodityPricesModel.data] != null) {
      List<Data> data = List<Data>.from([]);
      json[CommodityPricesModel.data].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    source = json[CommodityPricesModel.source];
    sourceUrl = json[CommodityPricesModel.source_url];
    sourceDate = json[CommodityPricesModel.source_date];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[CommodityPricesModel.data] =
        this.data!.map((v) => v.toJson()).toList();
    data[CommodityPricesModel.source] = source;
    data[CommodityPricesModel.source_url] = sourceUrl;
    data[CommodityPricesModel.source_date] = sourceDate;
    return data;
  }
}

class Data {
  String? market;
  String? date;
  String? commodity;
  String? pricePerTon;
  String? percentage;
  String? state;

  Data({
    this.market,
    this.date,
    this.commodity,
    this.pricePerTon,
    this.percentage,
    this.state,
  });

  Data.fromJson(Map<String, dynamic> json) {
    market = json[CommodityPricesModel.market];
    date = json[CommodityPricesModel.date];
    commodity = json[CommodityPricesModel.commodity];
    pricePerTon = json[CommodityPricesModel.price_per_ton];
    percentage = json[CommodityPricesModel.percentage];
    state = json[CommodityPricesModel.state];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data[CommodityPricesModel.market] = market;
    data[CommodityPricesModel.date] = date;
    data[CommodityPricesModel.commodity] = commodity;
    data[CommodityPricesModel.price_per_ton] = pricePerTon;
    data[CommodityPricesModel.percentage] = percentage;
    data[CommodityPricesModel.state] = state;
    return data;
  }
}
