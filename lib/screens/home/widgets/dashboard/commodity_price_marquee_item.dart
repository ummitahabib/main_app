import 'package:flutter/material.dart';

class CommodityPriceMarqueeItem extends StatelessWidget {
  final price;

  const CommodityPriceMarqueeItem({Key? key, this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Text(
        price,
        maxLines: 1,
        style: TextStyle(
            fontFamily: "regular",
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: (price.contains('BUY'))
                ? Colors.green
                : (price.contains('SELL'))
                    ? Colors.red
                    : Colors.black,),
      ),
      onTap: () {
        // pandora.reRouteUser(context, '/commodityPrice', 'null');
      },
    );
  }
}
