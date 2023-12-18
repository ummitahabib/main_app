import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/loaders/loader.dart';
import 'package:smat_crow/network/feeds/network/commodity_price_operations.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/commodity_price_marquee_item.dart';
import 'package:smat_crow/screens/widgets/header_with_subheader.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../../network/feeds/models/afex_commodity_prices.dart';
import 'commodity_small_item.dart';

class CommodityPricesList extends StatefulWidget {
  const CommodityPricesList({super.key});

  @override
  State<StatefulWidget> createState() {
    return _CommodityPricesListState();
  }
}

class _CommodityPricesListState extends State<CommodityPricesList> {
  bool loading = true;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  AfexCommodityResponse? commodityPricesResponse;
  List<Widget> commodityPrices = [];
  List<Widget> gainers = [];
  List<Widget> losers = [];

  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('yyyy-MM-dd');
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = formatter.format(now);
    getCurrentExchangePrices();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColors.headerTopHalf,
            child: const Center(
              child: LoaderAnim(),
            ),
          );
        }
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.fieldAgentDashboard,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderWithSubHeader(
                      canGoBack: true,
                      hasSubHeader: true,
                      headerText: 'Exchange Prices',
                      subHeaderText: (commodityPricesResponse != null) ? formattedDate : "",
                      headerColor: AppColors.blueGreyColor,
                      subHeaderColor: AppColors.fieldAgentText,
                      press: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 500,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: commodityPrices.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: commodityPrices[index],
                          );
                        },
                      ),
                    )
                  ],
                ),
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
      List<Widget> gainers = [];
      List<Widget> losers = [];
      if (data != null) {
        if (data.data.data!.isEmpty) {
          commodityPrices.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
          gainers.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
          losers.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
        } else {
          for (final price in data.data.data!) {
            if (price.type.toString().contains("BUY")) {
              gainers.add(
                CommodityPriceSmallItem(
                  commodity: price.commodityCode,
                  date: price.date,
                  percentage: price.changePercentage,
                  pricePerTon: price.marketPrice,
                  type: price.type,
                ),
              );
            } else if (price.type.toString().contains("SELL")) {
              losers.add(
                CommodityPriceSmallItem(
                  commodity: price.commodityCode,
                  date: price.date,
                  percentage: price.changePercentage,
                  pricePerTon: price.marketPrice,
                  type: price.type,
                ),
              );
            }
            commodityPrices.add(
              CommodityPriceSmallItem(
                commodity: price.commodityCode,
                date: price.date,
                percentage: price.changePercentage,
                pricePerTon: price.marketPrice,
                type: price.type,
              ),
            );
          }
        }
      } else {
        commodityPrices.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
        gainers.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
        losers.add(const CommodityPriceMarqueeItem(price: 'No Commodities'));
      }

      if (mounted) {
        setState(() {
          commodityPrices = commodityPrices;
          gainers = gainers;
          losers = losers;
        });
      }
      return data;
    });
  }
}
