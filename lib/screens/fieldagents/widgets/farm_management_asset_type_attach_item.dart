import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/farm_management/config/generic_type_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/assets/images.dart';
import '../../../utils/styles.dart';
import '../pages/farmmanagement/farm_management_assets_selector_page.dart';

class FarmManagementAssetTypeAttachItem extends StatelessWidget {
  final Color? background;
  final FileUploadDetailsArgs uploadArgs;
  final Data assetType;
  final Pandora pandora;

  const FarmManagementAssetTypeAttachItem({
    Key? key,
    this.background,
    required this.uploadArgs,
    required this.assetType,
    required this.pandora,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        displayModalWithChild(
          FarmManagerAssetsSelectorPage(
              assetType: assetType.types ?? '', uploadArgs: uploadArgs),
          'Select Farm ${assetType.types} Asset',
          context,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            Image.asset(ImagesAssets.kTree,
                width: 25.0, height: 25.0, fit: BoxFit.contain),
            const SizedBox(
              width: 15,
            ),
            Text(assetType.types ?? "",
                overflow: TextOverflow.fade,
                style: Styles.textStyleGridColor()),
          ],
        ),
      ),
    );
  }
}
