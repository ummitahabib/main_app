// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmshop/pages/shop_add_item_page.dart';
import 'package:smat_crow/screens/farmshop/pages/shop_cart_page.dart';
import 'package:smat_crow/screens/farmshop/pages/shop_categories_page.dart';
import 'package:smat_crow/screens/farmshop/pages/shop_favourites_page.dart';
import 'package:smat_crow/screens/farmshop/pages/shop_home_page.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../utils/assets/shop_svgs.dart';
import '../../utils/styles.dart';

class FarmShopPage extends StatefulWidget {
  const FarmShopPage({Key? key}) : super(key: key);

  @override
  _FarmShopPageState createState() => _FarmShopPageState();
}

class _FarmShopPageState extends State<FarmShopPage> {
  int currentTab = 0;
  final List<Widget> screens = [
    const ShopHomePage(),
    const ShopCategoriesPage(),
    const ShopAddItemPage(),
    const ShopFavouritesPage(),
    const ShopCartPage(),
  ];

  late Widget currentScreen;
  final Pandora _pandora = Pandora();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    currentScreen = const ShopHomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.shopOrange,
        title: Center(
          child: Text(
            'SmatShop',
            overflow: TextOverflow.fade,
            style: GoogleFonts.poppins(textStyle: Styles.boldTextStyle()),
          ),
        ),
        actions: const [
          SizedBox(
            width: 50,
          )
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: PageStorage(bucket: bucket, child: currentScreen),
      drawer: navigationDrawer(),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (int index) {
        switchPage(index);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: currentTab,
      selectedItemColor: AppColors.shopOrange,
      elevation: 0,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontFamily: 'regular', color: AppColors.shopOrange),
      unselectedLabelStyle: Styles.unSelectedStyle(),
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kHome,
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kHome,
              color: AppColors.shopOrange,
            ),
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kCategories,
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kCategories,
              color: AppColors.shopOrange,
            ),
          ),
          label: 'Categories',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kAdd,
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kAdd,
              color: AppColors.shopOrange,
            ),
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kFavourites,
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kFavourites,
              color: AppColors.shopOrange,
            ),
          ),
          label: 'Favourites',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kCart,
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              ShopAssets.kCart,
              color: AppColors.shopOrange,
            ),
          ),
          label: 'Cart',
        ),
      ],
    );
  }

  Drawer navigationDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('Drawer Header'),
          ),
          ListTile(
            title: const Text('Item 1'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void switchPage(int index) {
    switch (index) {
      case 0:
        _pandora.logAPPButtonClicksEvent('SHOP_DASH_BTN_CLICK');
        setState(() {
          currentScreen = const ShopHomePage();
          currentTab = 0;
        });
        break;
      case 1:
        _pandora.logAPPButtonClicksEvent('SHOP_CAT_BTN_CLICK');
        setState(() {
          currentScreen = const ShopCategoriesPage();
          currentTab = 1;
        });
        break;
      case 2:
        _pandora.logAPPButtonClicksEvent('SHOP_ADD_BTN_CLICK');
        setState(() {
          currentScreen = const ShopAddItemPage();
          currentTab = 2;
        });
        break;
      case 3:
        _pandora.logAPPButtonClicksEvent('SHOP_FAV_BTN_CLICK');
        setState(() {
          currentScreen = const ShopFavouritesPage();
          currentTab = 3;
        });
        break;
      case 4:
        setState(() {
          _pandora.logAPPButtonClicksEvent('SHOP_CART_BTN_CLICK');
          currentScreen = const ShopCartPage();
          currentTab = 4;
        });
        break;
    }
  }
}
