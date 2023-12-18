import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/screens/farmshop/widgets/category_dash_menu_item.dart';
import 'package:smat_crow/utils/constants.dart';

class ShopCategoryBody extends StatefulWidget {
  final String title, id;

  const ShopCategoryBody({Key? key, required this.title, required this.id}) : super(key: key);

  @override
  _ShopCategoryBodyState createState() => _ShopCategoryBodyState();
}

class _ShopCategoryBodyState extends State<ShopCategoryBody> {
  final groups = shopCategoriesGroupDummy;
  List<CategoryDashMenuItem> groupsList = [];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: groupsList,
        ),
      ),
    );
  }

  getCategoryGroups() {
    List<CategoryDashMenuItem> groupsList = [];
    if (groups.isEmpty) {
    } else {
      for (final element in groups) {
        if (widget.id == "all") {
          groupsList.add(
            CategoryDashMenuItem(
              title: getActualGroupTitle("Agricultural", element["title"]),
              id: element["id"],
            ),
          );
        } else {
          groupsList.add(
            CategoryDashMenuItem(
              title: getActualGroupTitle(widget.title, element["title"]),
              id: element["id"],
            ),
          );
        }
      }
    }

    if (mounted) {
      setState(() {
        groupsList = groupsList;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCategoryGroups();
  }

  String getActualGroupTitle(String title, String groupTitle) {
    final int idx = groupTitle.indexOf(" ");
    return "${groupTitle.substring(0, idx).trim()} $title ${groupTitle.substring(idx + 1).trim()}";
  }
}
