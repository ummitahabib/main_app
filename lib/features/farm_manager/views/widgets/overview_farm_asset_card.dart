import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/item_row.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class OverviewFarmAssetCard extends HookConsumerWidget {
  const OverviewFarmAssetCard({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    log(ref.watch(farmManagerProvider).getAgentUserType().toString());
    if (ref.watch(farmManagerProvider).getAgentUserType() != AgentTypeEnum.field) {
      return const SizedBox.shrink();
    }
    final shared = ref.watch(sharedProvider);
    final asset = ref.watch(assetProvider);
    useEffect(
      () {
        Future(() {
          asset.getOrgAssets();
          if (shared.flagList.isEmpty) {
            shared.getFlags();
          }
        });
        return null;
      },
      [],
    );
    if (asset.orgAssetList.isEmpty) {
      return const EmptyListWidget(text: "No Farm Asset at the moment");
    }
    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: kIsWeb ? SpacingConstants.double20 : 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BoldHeaderText(text: farmAssetText),
                const Spacer(),
                InkWell(
                  onTap: () {
                    if (kIsWeb) {
                      final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;
                      Pandora().reRouteUser(context, "${ConfigRoute.farmAsset}/${path.last}", path.last);
                    } else {
                      Pandora().reRouteUser(context, ConfigRoute.farmAsset, "id");
                    }
                  },
                  child: Text(
                    viewAllText,
                    style: Styles.smatCrowSubRegularUnderline(color: AppColors.SmatCrowNeuBlue500),
                  ),
                )
              ],
            ),
          ),
          const Ymargin(SpacingConstants.double20),
          Wrap(
            spacing: SpacingConstants.double20,
            runSpacing: SpacingConstants.double20,
            children: List.generate(
              asset.orgAssetList.length,
              (index) => InkWell(
                onTap: () {
                  if (kIsWeb) {
                    asset.assetDetails = asset.orgAssetList[index];
                    final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;
                    Pandora().reRouteUser(
                      context,
                      "${ConfigRoute.assetDetails}/${path.last}?assetId=${asset.orgAssetList[index].assets!.uuid}",
                      asset.orgAssetList[index].assets!.uuid,
                    );
                  } else {
                    asset.assetDetails = asset.orgAssetList[index];

                    Pandora().reRouteUser(context, ConfigRoute.assetDetails, asset.orgAssetList[index].assets!.uuid);
                  }
                },
                child: AppMaterial(
                  width: Responsive.isMobile(context)
                      ? null
                      : Responsive.xWidth(context, percent: SpacingConstants.size0point33),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SpacingConstants.font16,
                      vertical: SpacingConstants.font10,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${asset.orgAssetList[index].assets!.name}",
                              style: Styles.smatCrowMediumBody(color: AppColors.SmatCrowOffBlackLabel),
                            ),
                            const Spacer(),
                            ColoredContainer(
                              color: dummyAssetStatusList
                                  .firstWhere(
                                    (element) => element.name == (asset.orgAssetList[index].assets!.status ?? ""),
                                    orElse: () => dummyAssetStatusList.first,
                                  )
                                  .color,
                              text: asset.orgAssetList[index].assets!.status ?? "",
                            )
                          ],
                        ),
                        const Ymargin(SpacingConstants.font16),
                        ItemRow(
                          asset: AppAssets.compass,
                          title: assetTypeText,
                          body: asset.orgAssetList[index].assets!.type ?? "",
                        ),
                        ItemRow(
                          asset: AppAssets.flag,
                          title: assetFlagText,
                          body: (asset.orgAssetList[index].assets!.assetFlags!.isNotEmpty && shared.flagList.isNotEmpty)
                              ? shared.flagList
                                      .firstWhere(
                                        (element) =>
                                            element.uuid == asset.orgAssetList[index].assets!.assetFlags!.first,
                                        orElse: () => shared.flagList.first,
                                      )
                                      .flag ??
                                  ""
                              : null,
                        ),
                        ItemRow(
                          asset: AppAssets.calendar,
                          title: purchaseDateText,
                          body: DateFormat("dd/MM/yyyy")
                              .format(asset.orgAssetList[index].assets!.acquisitionDate ?? DateTime.now()),
                        ),
                        ItemRow(
                          asset: AppAssets.flash,
                          title: "Status",
                          body: asset.orgAssetList[index].assets!.deleted == "N" ? "Published" : "Draft",
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
