import 'package:async/async.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/feeds/network/commodity_price_operations.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/commodity_price_marquee_item.dart';

import '../../../../network/feeds/models/afex_commodity_prices.dart';
import '../../../../pandora/pandora.dart';
import 'afex_commodity_price_marquee_item.dart';

class CommodityPricesMarquee extends StatefulWidget {
  const CommodityPricesMarquee({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CommodityPricesMarqueeState();
  }
}

class _CommodityPricesMarqueeState extends State<CommodityPricesMarquee> {
  bool loading = true;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  AfexCommodityResponse? commodityPricesResponse;
  List<Widget> commodityPrices = [];
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    getCurrentExchangePrices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return Container();
        }
        return Container(
          color: Colors.white,
          height: 35,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: CarouselSlider(
              items: commodityPrices,
              options: CarouselOptions(
                height: 30,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayCurve: Curves.easeInOutBack,
              ),
            ),
          ),
        );
      },
      future: getCurrentExchangePrices(),
    );
  }

  Future getCurrentExchangePrices() async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getAFEXCommodityPrices();
      commodityPricesResponse = data;
      List<Widget> commodityPrices = [];
      if (data != null) {
        if (data.data.data!.isEmpty) {
          commodityPrices.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
        } else {
          for (final price in data.data.data!) {
            commodityPrices.add(
              AfexCommodityPriceMarqueeItem(
                price: price,
                pandora: _pandora,
              ),
            );
          }
        }
      } else {
        commodityPrices.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
      }

      if (mounted) {
        setState(() {
          commodityPrices = commodityPrices;
        });
      }
      return data;
    });
  }
}
