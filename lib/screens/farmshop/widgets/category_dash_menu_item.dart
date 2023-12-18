import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/screens/farmshop/widgets/shop_product_item.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../utils/styles.dart';

class CategoryDashMenuItem extends StatefulWidget {
  final String title, id;

  const CategoryDashMenuItem({Key? key, required this.title, required this.id}) : super(key: key);

  @override
  _CategoryDashMenuItemState createState() => _CategoryDashMenuItemState();
}

class _CategoryDashMenuItemState extends State<CategoryDashMenuItem> {
  List<ShopProductItem> productList = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rubik(textStyle: Styles.styleBlackBold()),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'See All',
                style: GoogleFonts.rubik(
                  textStyle: Styles.boldOrangeBold(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        if (productList.isEmpty)
          Container(
            height: 50,
            width: 50,
            color: Colors.black,
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: 220,
              child: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: productList.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    width: 8,
                  );
                },
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return productList[index];
                },
              ),
            ),
          )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getCategoryData(widget.id);
  }

  void getCategoryData(String id) {
    List<ShopProductItem> productList = [];
    if (shopDummyProductItems.isNotEmpty) {
      for (final element in shopDummyProductItems) {
        productList.add(
          ShopProductItem(
            name: element["name"],
            category: element["category"],
            image: element["image"],
            price: element["price"],
            discount: element["discount"],
            isFavourite: element["isFavourite"],
            id: element["id"],
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        productList = productList;
      });
    }
  }
}
