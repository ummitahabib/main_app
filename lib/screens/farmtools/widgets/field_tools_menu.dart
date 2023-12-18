import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/screens/farmtools/widgets/farm_tools_list_item.dart';
import 'package:smat_crow/utils/constants.dart';

class FarmToolsMenu extends StatelessWidget {
  const FarmToolsMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldAgentListItem = [];
    const farmMenu = farmTools;

    if (farmMenu.isEmpty) {
    } else {
      for (final item in farmMenu) {
        fieldAgentListItem.add(FarmToolsListItem(
          route: item["route"],
          image: item["image"],
          text: item["text"],
          background: item["background"],
        ),);
      }
    }

    return ListView.builder(
      itemCount: fieldAgentListItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return fieldAgentListItem[index];
      },
    );
  }
}
