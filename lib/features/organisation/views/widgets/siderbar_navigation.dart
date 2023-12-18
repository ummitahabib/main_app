import 'package:flutter/material.dart';
import 'package:smat_crow/features/organisation/data/models/menu_item_model.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import 'sidebar_item.dart';

class SidebarNavigator extends StatelessWidget {
  const SidebarNavigator({
    super.key,
    required this.items,
    required this.currentIndex,
    this.onChange,
  }) : assert(items.length >= 2, 'items length must be >=2');

  final String currentIndex;
  final List<MenuItemModel> items;
  final ValueChanged<int>? onChange;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => InkWell(
        onTap: () => onChange!(index),
        child: SidebarItem(
          isSelected: items[index].route == currentIndex,
          menuItem: items[index],
          selected: currentIndex,
        ),
      ),
      separatorBuilder: (context, index) =>
          customSizedBoxHeight(SpacingConstants.size10),
      itemCount: items.length,
    );
  }
}
