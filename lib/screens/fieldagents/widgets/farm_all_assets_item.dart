import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/farm_management/assets/generic_organization_assets.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/strings.dart';
import '../../../utils/styles.dart';

class FarmAllAssetsItem extends StatelessWidget {
  final Datum asset;
  final FarmManagerSiteManagementArgs assetArgs;

  const FarmAllAssetsItem({
    Key? key,
    required this.asset,
    required this.assetArgs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      child: Card(
        elevation: 0.2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(1),
        color: AppColors.offWhite,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(asset.name ?? "", style: Styles.textBlackMd()),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(asset.type ?? '', style: Styles.textBlackMd()),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: (asset.status == Active)
                          ? AppColors.completedColor
                          : AppColors.inactiveTabTextColor.withOpacity(.2),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      child:
                          Text(asset.status ?? '', style: Styles.textBlackMd()),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        pandora.reRouteUser(context, '/farmManagerAssetsDetails',
            FarmManagementAssetArgs(asset, assetArgs));
      },
    );
  }
}
