import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

//commodity price marquee widget

class CommodityPriceMarqueeItem extends StatelessWidget {
  final price;

  const CommodityPriceMarqueeItem({Key? key, this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        price,
        maxLines: SpacingConstants.int1,
        style: Styles.commodityTextStyle(
          color: (price.contains(buy))
              ? AppColors.SmatCrowGreen400
              : (price.contains(sell))
                  ? AppColors.SmatCrowRed400
                  : AppColors.SmatCrowDefaultBlack,
        ),
      ),
      onTap: () {},
    );
  }
}
