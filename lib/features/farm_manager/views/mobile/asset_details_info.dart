import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/head_down.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class AssetDetailsInfo extends HookConsumerWidget {
  const AssetDetailsInfo({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider);

    return !Responsive.isMobile(context)
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    AppMaterial(
                      child: Padding(
                        padding: const EdgeInsets.all(SpacingConstants.font16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeadDownWidget(
                                  head: canExpire,
                                  down: asset.assetDetails!.assets!.canExpire.toString(),
                                ),
                                HeadDownWidget(
                                  head: typeText,
                                  down: asset.assetDetails!.assets!.structureType,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                HeadDownWidget(
                                  head: quantityText,
                                  down: asset.assetDetails!.assets!.quantity.toString(),
                                ),
                                HeadDownWidget(
                                  head: costText,
                                  down: Pandora().newMoneyFormat(asset.assetDetails!.assets!.cost ?? 0),
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Color600Text(text: statusText),
                                    const Ymargin(SpacingConstants.size5),
                                    ColoredContainer(
                                      text: asset.assetDetails!.assets!.status,
                                      color: dummyAssetStatusList
                                          .firstWhere(
                                            (element) => element.name == asset.assetDetails!.assets!.status!,
                                            orElse: () => dummyAssetStatusList.last,
                                          )
                                          .color,
                                    )
                                  ],
                                ),
                                HeadDownWidget(
                                  head: isLocationText,
                                  down: asset.assetDetails!.assets!.location.toString(),
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Ymargin(SpacingConstants.double20),
                    AppMaterial(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(SpacingConstants.double20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BoldHeaderText(text: fileUploadedText),
                            const Ymargin(SpacingConstants.double20),
                            ...List.generate(
                              asset.assetDetails!.additionalInfo!.assetFiles!.length,
                              (index) => ListTile(
                                leading: Image.asset(AppAssets.pdf),
                                title: Text(
                                  "$fileText ${index + 1}",
                                  style: Styles.smatCrowSubParagraphRegular(
                                    color: AppColors.SmatCrowNeuBlue900,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Xmargin(SpacingConstants.double20),
              Expanded(
                child: Column(
                  children: [
                    AppMaterial(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(SpacingConstants.double20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const BoldHeaderText(text: noteText),
                            const Ymargin(SpacingConstants.size20),
                            Color600Text(
                              text: asset.assetDetails!.assets!.notes ?? emptyString,
                            )
                          ],
                        ),
                      ),
                    ),
                    const Ymargin(SpacingConstants.double20),
                    AppMaterial(
                      width: double.maxFinite,
                      child: Padding(
                        padding: const EdgeInsets.all(SpacingConstants.double20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const BoldHeaderText(text: imagesText),
                            const Ymargin(SpacingConstants.double20),
                            Wrap(
                              runSpacing: SpacingConstants.double20,
                              spacing: SpacingConstants.double20,
                              children: List.generate(
                                asset.assetDetails!.additionalInfo!.assetMedia!.length,
                                (index) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: SpacingConstants.size140,
                                      height: SpacingConstants.size124,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          SpacingConstants.font10,
                                        ),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            asset.assetDetails!.additionalInfo!.assetMedia![index].url ?? DEFAULT_IMAGE,
                                          ),
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                    ),
                                    const Ymargin(SpacingConstants.font16),
                                    Color600Text(
                                      text: "$imageText ${index + 1}",
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        : Wrap(
            spacing: SpacingConstants.size20,
            runSpacing: SpacingConstants.size20,
            children: [
              AppMaterial(
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.font16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadDownWidget(
                            head: canExpire,
                            down: asset.assetDetails!.assets!.canExpire.toString(),
                          ),
                          HeadDownWidget(
                            head: typeText,
                            down: asset.assetDetails!.assets!.structureType,
                            crossAxisAlignment: CrossAxisAlignment.end,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeadDownWidget(
                            head: quantityText,
                            down: asset.assetDetails!.assets!.quantity.toString(),
                          ),
                          HeadDownWidget(
                            head: costText,
                            down: Pandora().newMoneyFormat(asset.assetDetails!.assets!.cost ?? 0),
                            crossAxisAlignment: CrossAxisAlignment.end,
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Color600Text(text: "Status"),
                              const Ymargin(SpacingConstants.size5),
                              ColoredContainer(
                                text: asset.assetDetails!.assets!.status,
                                color: dummyAssetStatusList
                                    .firstWhere(
                                      (element) => element.name == asset.assetDetails!.assets!.status!,
                                      orElse: () => dummyAssetStatusList.last,
                                    )
                                    .color,
                              )
                            ],
                          ),
                          HeadDownWidget(
                            head: isLocationText,
                            down: asset.assetDetails!.assets!.location.toString(),
                            crossAxisAlignment: CrossAxisAlignment.end,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              AppMaterial(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BoldHeaderText(text: noteText),
                      const Ymargin(SpacingConstants.size20),
                      Color600Text(
                        text: asset.assetDetails!.assets!.notes ?? emptyString,
                      )
                    ],
                  ),
                ),
              ),
              AppMaterial(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BoldHeaderText(text: imagesText),
                      const Ymargin(SpacingConstants.double20),
                      Wrap(
                        runSpacing: SpacingConstants.double20,
                        spacing: SpacingConstants.double20,
                        children: List.generate(
                          asset.assetDetails!.additionalInfo!.assetMedia!.length,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: SpacingConstants.size140,
                                height: SpacingConstants.size124,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    SpacingConstants.font10,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      asset.assetDetails!.additionalInfo!.assetMedia![index].url ?? DEFAULT_IMAGE,
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              const Ymargin(SpacingConstants.font16),
                              Color600Text(text: "$imageText ${index + 1}")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              AppMaterial(
                width: Responsive.isTablet(context)
                    ? Responsive.xWidth(
                        context,
                        percent: SpacingConstants.size0point4,
                      )
                    : null,
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BoldHeaderText(text: fileUploadedText),
                      const Ymargin(SpacingConstants.double20),
                      ...List.generate(
                        asset.assetDetails!.additionalInfo!.assetFiles!.length,
                        (index) => ListTile(
                          leading: Image.asset(AppAssets.pdf),
                          title: Text(
                            "$fileText ${index + 1}",
                            style: Styles.smatCrowSubParagraphRegular(
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}

class FormatAsset {
  final String title;
  final String subtitle;

  FormatAsset(this.title, this.subtitle);
}
