import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/styles.dart';
import '../pages/farmmanagement/fam_management_asset_types_menu.dart';
import '../pages/farmmanagement/fam_management_log_types_menu.dart';

class FarmManagementManageItem extends StatelessWidget {
  final String text, image, route;
  final Color background;
  final FarmManagerSiteManagementArgs siteArgs;

  const FarmManagementManageItem(
      {Key? key,
      required this.text,
      required this.background,
      required this.image,
      required this.route,
      required this.siteArgs,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (route == "/farmLogs") {
          displayModalWithChild(FarmManagementLogTypesMenu(siteArgs: FarmManagementTypeManagementArgs(siteArgs, "ALL")),
              'Farm Log Types', context,);
        } else if (route == "/farmAssets") {
          displayModalWithChild(FarmManagementAssetTypeMenu(siteArgs: siteArgs), 'Farm Asset Types', context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(children: [
          Image.asset(image, width: 25.0, height: 25.0, fit: BoxFit.contain),
          const SizedBox(
            width: 15,
          ),
          Text(text, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
        ],),
      ),
    );
  }
}
