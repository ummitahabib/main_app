import 'package:flutter/material.dart';
import 'package:smat_crow/screens/farmshop/widgets/shop_category_body.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../utils/assets/icons.dart';
import '../../../utils/styles.dart';

class ShopHomePage extends StatefulWidget {
  const ShopHomePage({Key? key}) : super(key: key);

  @override
  _ShopHomePageState createState() => _ShopHomePageState();
}

TextEditingController searchInput = TextEditingController();

class _ShopHomePageState extends State<ShopHomePage> with SingleTickerProviderStateMixin {
  List<Tab> categoriesList = [];
  List<ShopCategoryBody> categoriesBodyList = [];
  late TabController _tabController;
  final categories = shopCategoriesDummy;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          shopSearchInput(),
          const SizedBox(
            height: 20,
          ),
          shopCategoriesTabs(),
          Expanded(
            child: TabBarView(controller: _tabController, children: categoriesBodyList),
          ),
        ],
      ),
    );
  }

  Widget shopSearchInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.shopSearchBorder),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  autocorrect: false,
                  controller: searchInput,
                  keyboardType: TextInputType.name,
                  style: Styles.RegularStyle(),
                  decoration: InputDecoration(
                    hintText: "Search for Agricultural products",
                    border: InputBorder.none,
                    hintStyle: Styles.RegularStyle(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.shopOrange,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: ImageIcon(
                    AssetImage(
                      IconsAssets.kSearch,
                    ),
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget shopCategoriesTabs() {
    return Container(
      color: AppColors.shopOrange.withOpacity(0.2),
      child: TabBar(
        unselectedLabelColor: AppColors.unselectedTab,
        labelColor: Colors.black,
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        indicatorColor: Colors.transparent,
        labelStyle: Styles.defaultBlackBold(),
        unselectedLabelStyle: Styles.unselectedTabRegular(),
        tabs: categoriesList,
        controller: _tabController,
        indicatorSize: TabBarIndicatorSize.tab,
      ),
    );
  }

  getShopItemCategories() {
    List<Tab> categoriesList = [];
    List<ShopCategoryBody> categoriesBodyList = [];
    if (categories.isEmpty) {
    } else {
      for (final element in categories) {
        categoriesList.add(Tab(text: element["title"]));
        if (element["id"] == "all") {
          categoriesBodyList.add(ShopCategoryBody(id: element["id"], title: "All Categories"));
        } else {
          categoriesBodyList.add(ShopCategoryBody(id: element["id"], title: element["title"]));
        }
      }
    }
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);

    if (mounted) {
      setState(() {
        categoriesList = categoriesList;
        categoriesBodyList = categoriesBodyList;
      });
    }
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      //final category = categories[_tabController.index];
    }
  }

  @override
  void initState() {
    super.initState();
    getShopItemCategories();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
