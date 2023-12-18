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
    if (json['data'] != null) {
      List<Data> data = List<Data>.from([]);
      // data = new List<Data>();
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
    source = json['source'];
    sourceUrl = json['source_url'];
    sourceDate = json['source_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = this.data!.map((v) => v.toJson()).toList();
    data['source'] = source;
    data['source_url'] = sourceUrl;
    data['source_date'] = sourceDate;
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
    market = json['market'];
    date = json['date'];
    commodity = json['commodity'];
    pricePerTon = json['price_per_ton'];
    percentage = json['percentage'];
    state = json['state'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['market'] = market;
    data['date'] = date;
    data['commodity'] = commodity;
    data['price_per_ton'] = pricePerTon;
    data['percentage'] = percentage;
    data['state'] = state;
    return data;
  }
}
