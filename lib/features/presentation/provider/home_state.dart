import 'package:flutter/material.dart';
import 'package:smat_crow/network/feeds/models/afex_commodity_prices.dart';
import 'package:smat_crow/network/feeds/network/commodity_price_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/afex_commodity_price_marquee_item.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/commodity_price_marquee_item.dart';
import 'package:smat_crow/utils2/constants.dart';

class HomeStateProvider extends ChangeNotifier {
  String? firstName, lastName, email;
  late AfexCommodityResponse commodityPricesResponse;
  List<Widget> commodityPrices = [];
  final Pandora _pandora = Pandora();

  bool? get mounted => null;

  void getProfileInformation() {
    firstName = firstName;
    lastName = lastName;
    email = email;
  }

  Future<void> getCurrentExchangePrices() async {
    final data = await getAFEXCommodityPrices();
    commodityPricesResponse = data!;
    commodityPrices.clear();

    if (data.data.data!.isEmpty) {
      commodityPrices.add(const CommodityPriceMarqueeItem(price: noCommodoties));
    } else {
      for (final price in data.data.data!) {
        commodityPrices.add(
          AfexCommodityPriceMarqueeItem(price: price, pandora: _pandora),
        );
      }
    }

    notifyListeners();
  }
}
