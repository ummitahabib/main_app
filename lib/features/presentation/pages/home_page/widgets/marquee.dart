import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:smat_crow/features/data/repository/commodity_price_remository.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/afex_commodity_price_marquee_item.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/commodity_price_marquee.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

//marquee widget

class MarqueeWidget extends StatefulWidget {
  const MarqueeWidget({Key? key}) : super(key: key);

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> with SingleTickerProviderStateMixin {
  List<Widget> commodityPrices = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    getCurrentExchangePrices();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: SpacingConstants.int5),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMarquee();
    });
  }

  void _startMarquee() {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double textWidth = _calculateTextWidth(commodityPrices.join(splitString));
    final double totalWidth = textWidth * commodityPrices.length;
    final double marqueeDuration = totalWidth / screenWidth * SpacingConstants.int2;

    _controller.animateTo(
      -(totalWidth - screenWidth),
      duration: Duration(seconds: marqueeDuration.floor()),
    );
  }

  double _calculateTextWidth(String text) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: SpacingConstants.size14),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    return textPainter.width;
  }

  List marqueeItems = <String>[];

  @override
  Widget build(BuildContext context) {
    if (commodityPrices.isNotEmpty) {
      marqueeItems = commodityPrices.map((item) {
        if (item is AfexCommodityPriceMarqueeItem) {
          return item.toMarqueeString();
        }
        return item.toString();
      }).toList();
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.SmatCrowPrimary50,
      height: SpacingConstants.size45,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: SpacingConstants.size10),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Marquee(
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: SpacingConstants.size20,
              velocity: SpacingConstants.size80,
              pauseAfterRound: const Duration(seconds: SpacingConstants.int1),
              startPadding: SpacingConstants.size10,
              accelerationDuration: const Duration(seconds: SpacingConstants.int1),
              accelerationCurve: Curves.linear,
              decelerationDuration: const Duration(milliseconds: SpacingConstants.sizeInt500),
              decelerationCurve: Curves.easeOut,
              text: marqueeItems.isEmpty
                  ? "Cocoa (SCOC) ₦ 28,380 0.0 %.Deliverable Ginger Dried Split (DGNG) ₦ 9,781,395,348,837,209 1.21 %.Maize (SMAZ) ₦ 33,792 0.06 %.Paddy Rice (SPRL) ₦ 3,750 0.0 %.Spot Cashew Nuts (SCSN) ₦ 6,380 9.01 %.Deliverable Sesame Seed (DSSM) ₦ 8,505,116,279,069,767 27.1 %.Sorghum (SSGM) ₦ 3,375 9.07 %.Soybean (SSBS) ₦ 3,290 24.4 %"
                  : marqueeItems.join(splitString),
              style: const TextStyle(fontSize: SpacingConstants.size14),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<List<Widget>> getCurrentExchangePrices() async {
    final data = await getAFEXCommodityPrices();

    List<Widget> commodityPrices = [];
    if (data != null) {
      if (data.data.data?.isEmpty ?? true) {
        commodityPrices.add(const CommodityPriceMarqueeItem(price: noCommodoties));
      } else {
        for (final price in data.data.data!) {
          commodityPrices.add(
            AfexCommodityPriceMarqueeItem(price: price),
          );
        }
      }
    } else {
      commodityPrices.add(const CommodityPriceMarqueeItem(price: noCommodoties));
    }

    if (mounted) {
      setState(() {
        this.commodityPrices = commodityPrices;
      });
    }
    return commodityPrices;
  }
}
