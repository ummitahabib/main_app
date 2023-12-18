import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/features/data/models/afex_commodity/afex_commodity_datum_model.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

//afex commodity widget
final appHelpers = ApplicationHelpers();

class AfexCommodityPriceMarqueeItem extends StatelessWidget {
  final Datum price;

  const AfexCommodityPriceMarqueeItem({
    Key? key,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: SpacingConstants.size13,
              color: Colors.black,
            ),
          ),
          text: '${price.commodityCode}',
          children: <TextSpan>[
            TextSpan(
              text: ' $nairaSign ${appHelpers.moneyFormatNew(price.marketPrice.toString())}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: ' ${price.changePercentage} $percentSign',
              style: TextStyle(
                color: (price.type.toString().contains(buy))
                    ? AppColors.SmatCrowGreen400
                    : (price.type.toString().contains(sell))
                        ? AppColors.SmatCrowRed400
                        : AppColors.SmatCrowDefaultBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String toMarqueeString() {
    return '${price.commodityCode} $nairaSign ${appHelpers.moneyFormatNew(price.marketPrice.toString())} ${price.changePercentage} $percentSign';
  }
}
