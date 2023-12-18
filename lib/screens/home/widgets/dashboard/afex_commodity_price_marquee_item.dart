import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../network/feeds/models/afex_commodity_prices.dart';

class AfexCommodityPriceMarqueeItem extends StatelessWidget {
  final Datum price;
  final Pandora pandora;

  const AfexCommodityPriceMarqueeItem({Key? key, required this.price, required this.pandora}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: RichText(
        text: TextSpan(
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 13.0,
              color: Colors.black,
            ),
          ),
          text: '${price.commodityCode}',
          children: <TextSpan>[
            TextSpan(
              text: '    ₦ ${pandora.moneyFormatNew(price.marketPrice.toString())}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '    ${price.changePercentage} %',
              style: TextStyle(
                color: (price.type.toString().contains('BUY'))
                    ? Colors.green
                    : (price.type.toString().contains('SELL'))
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        // pandora.reRouteUser(context, '/commodityPrice', 'null');
      },
    );
  }
}
