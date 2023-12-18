import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_details.dart';
import 'package:smat_crow/features/institution/views/widgets/farm_asset_table.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/utils2/constants.dart';

import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class InstutionFarmAsset extends HookConsumerWidget {
  const InstutionFarmAsset({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController();
    final asset = ref.watch(assetProvider);
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      children: [
        FarmAssetTable(controller: controller),
        HomeWebContainer(
          title: assetDetailsText,
          trailingIcon: const SizedBox.shrink(),
          width: Responsive.xWidth(context),
          leadingCallback: () {
            controller.previousPage(
              duration: const Duration(milliseconds: SpacingConstants.int400),
              curve: Curves.easeOut,
            );
          },
          elevation: 1,
          child: AssetDetails(
            showHead: false,
            id: asset.assetDetails == null
                ? ""
                : asset.assetDetails!.assets!.uuid ?? emptyString,
          ),
        ),
      ],
    );
  }
}
