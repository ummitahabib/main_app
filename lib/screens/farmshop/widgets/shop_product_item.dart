import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../utils/styles.dart';

class ShopProductItem extends StatelessWidget {
  final String? name, category, image, id;
  final double? price, discount;
  final bool isFavourite;

  const ShopProductItem({
    Key? key,
    this.name,
    this.category,
    this.image,
    this.id,
    this.price,
    this.discount,
    this.isFavourite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      onTap: () {
        /*pandora.logAPPButtonClicksEvent(
            'FARM_TOOLS_ITEM_${route.replaceAll('/', emptyString).toUpperCase()}_CLICKED');
        pandora.reRouteUser(context, route, 'null');*/
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        color: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.6),
        child: SizedBox(
          width: 160,
          height: 210,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0)),
                child: Image.network(
                  image ?? "",
                  fit: BoxFit.cover,
                  height: 119,
                  width: 160,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name ?? "",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.rubik(
                          textStyle: Styles.textBlueGreyBold(),
                        ),
                      ),
                      Text(
                        category ?? "",
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.rubik(
                            textStyle: Styles.unselectedTabItalic()),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        pandora.moneyFormat(price!),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.rubik(
                          textStyle: Styles.textStyleBlueGreyMd(),
                        ),
                      ),
                      Text(
                        pandora.moneyFormat(price! * (discount! / 100)),
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: GoogleFonts.rubik(
                          textStyle: Styles.textStyleLineThrough(),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
