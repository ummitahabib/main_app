import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/features/institution/views/widgets/table_unit.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmAssetTable extends HookConsumerWidget {
  const FarmAssetTable({
    super.key,
    required this.controller,
  });

  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asset = ref.watch(assetProvider);
    final shared = ref.watch(sharedProvider);
    return HomeWebContainer(
      title: "${shared.assetTypes != null ? (shared.assetTypes!.types ?? emptyString) : ""} Asset",
      trailingIcon: const SizedBox.shrink(),
      width: Responsive.xWidth(context),
      elevation: 1,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100),
                    ),
                  ),
                  children: [
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpacingConstants.double20,
                          vertical: SpacingConstants.font10,
                        ),
                        child: BoldHeaderText(
                          text: assetNameText,
                          fontSize: SpacingConstants.font14,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpacingConstants.double20,
                          vertical: SpacingConstants.font10,
                        ),
                        child: BoldHeaderText(
                          text: assetTypeText,
                          fontSize: SpacingConstants.font14,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpacingConstants.double20,
                          vertical: SpacingConstants.font10,
                        ),
                        child: BoldHeaderText(
                          text: assetFlagText,
                          fontSize: SpacingConstants.font14,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpacingConstants.double20,
                          vertical: SpacingConstants.font10,
                        ),
                        child: BoldHeaderText(
                          text: purchaseDateText,
                          fontSize: SpacingConstants.font14,
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpacingConstants.double20,
                          vertical: SpacingConstants.font10,
                        ),
                        child: BoldHeaderText(
                          text: assetStatusText,
                          fontSize: SpacingConstants.font14,
                        ),
                      ),
                    ),
                  ],
                ),
                ...List.generate(
                  asset.orgAssetList.length,
                  (index) => TableRow(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100),
                      ),
                    ),
                    children: [
                      TableCell(
                        child: TableUnit(
                          onTap: () {
                            asset.assetDetails = asset.orgAssetList[index];
                            controller.animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: SpacingConstants.int400,
                              ),
                              curve: Curves.easeIn,
                            );
                          },
                          text: asset.orgAssetList[index].assets!.name ?? "",
                        ),
                      ),
                      TableCell(
                        child: TableUnit(
                          onTap: () {
                            asset.assetDetails = asset.orgAssetList[index];
                            controller.animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: SpacingConstants.int400,
                              ),
                              curve: Curves.easeIn,
                            );
                          },
                          text: asset.orgAssetList[index].assets!.type ?? "",
                        ),
                      ),
                      TableCell(
                        child: TableUnit(
                          onTap: () {
                            asset.assetDetails = asset.orgAssetList[index];
                            controller.animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: SpacingConstants.int400,
                              ),
                              curve: Curves.easeIn,
                            );
                          },
                          text: (asset.orgAssetList[index].assets!.assetFlags!.isNotEmpty && shared.flagList.isNotEmpty)
                              ? shared.flagList
                                      .firstWhere(
                                        (element) =>
                                            element.uuid == asset.orgAssetList[index].assets!.assetFlags!.first,
                                        orElse: () => shared.flagList.first,
                                      )
                                      .flag ??
                                  ""
                              : "null",
                        ),
                      ),
                      TableCell(
                        child: TableUnit(
                          onTap: () {
                            asset.assetDetails = asset.orgAssetList[index];
                            controller.animateToPage(
                              1,
                              duration: const Duration(
                                milliseconds: SpacingConstants.int400,
                              ),
                              curve: Curves.easeIn,
                            );
                          },
                          text: DateFormat.yMMMd().format(
                            asset.orgAssetList[index].assets!.acquisitionDate ?? DateTime.now(),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingConstants.double20,
                            vertical: SpacingConstants.font10,
                          ),
                          child: ColoredContainer(
                            color: dummyAssetStatusList
                                .firstWhere(
                                  (e) => e.name == asset.orgAssetList[index].assets!.status,
                                  orElse: () => dummyAssetStatusList.last,
                                )
                                .color,
                            text: asset.orgAssetList[index].assets!.status ?? "",
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
