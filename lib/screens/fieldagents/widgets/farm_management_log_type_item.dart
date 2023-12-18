import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/farm_management/config/generic_type_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/assets/images.dart';
import '../../../utils/styles.dart';

class FarmManagementLogTypeItem extends StatelessWidget {
  final Color? background;
  final FarmManagementTypeManagementArgs siteArgs;
  final Data logType;
  final Pandora pandora;

  const FarmManagementLogTypeItem({
    Key? key,
    this.background,
    required this.siteArgs,
    required this.logType,
    required this.pandora,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pandora.reRouteUserPopCurrent(
          context,
          "/farmManagerLogsPage",
          FarmManagementLogDetailsArgs(siteArgs, logType.types ?? ""),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Image.asset(ImagesAssets.kSun, width: 25.0, height: 25.0, fit: BoxFit.contain),
            const SizedBox(
              width: 15,
            ),
            Text(logType.types ?? "", overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
          ],
        ),
      ),
    );
  }
}
