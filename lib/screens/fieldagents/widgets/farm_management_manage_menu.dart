import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'farm_management_manage_item.dart';

class FarmManagementManageMenu extends StatelessWidget {
  final FarmManagerSiteManagementArgs siteArgs;

  const FarmManagementManageMenu({
    Key? key,
    required this.siteArgs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> farmManagementItem = [];

    if (farmManagementMenu.isNotEmpty) {
      for (final item in farmManagementMenu) {
        farmManagementItem.add(
          FarmManagementManageItem(
            route: item["route"],
            image: item["image"],
            text: item["text"],
            background: item["background"],
            siteArgs: siteArgs,
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: farmManagementItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return farmManagementItem[index];
      },
    );
  }
}
