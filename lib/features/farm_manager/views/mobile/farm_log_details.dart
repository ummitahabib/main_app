import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/asset_details_info.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/head_down.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmLogDetails extends HookConsumerWidget {
  const FarmLogDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logController = ref.watch(logProvider);
    final logResp = logController.logResponse!;
    final data = [
      FormatAsset(currencyText, logResp.log!.currency ?? ""),
      FormatAsset(costText, Pandora().newMoneyFormat(logResp.log!.cost ?? 0)),
      FormatAsset("Type", logResp.log!.type ?? ""),
      FormatAsset("Status", logResp.log!.status ?? ""),
      FormatAsset("Is Movement", (logResp.log!.isMovement ?? false).toString()),
      FormatAsset("Is Group Assignment", (logResp.log!.isGroupAssignment ?? false).toString()),
      FormatAsset("Quantity", logResp.log!.quantity ?? ""),
      FormatAsset("Method", logResp.log!.method ?? ""),
      FormatAsset("Laboratory", logResp.log!.laboratory ?? ""),
      FormatAsset("Source", logResp.log!.source ?? ""),
    ]
        .where(
          (element) => element.subtitle != "0.0" && element.subtitle != "null" && element.subtitle.trim().isNotEmpty,
        )
        .toList();

    return !Responsive.isMobile(context)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoldHeaderText(
                text: "${logController.logResponse!.log!.name ?? ""} Log",
                fontSize: SpacingConstants.font24,
              ),
              const Ymargin(SpacingConstants.double20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        AppMaterial(
                          width: Responsive.xWidth(context),
                          child: Container(
                            height: 300,
                            padding: const EdgeInsets.all(SpacingConstants.font16),
                            child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 2.7,
                              ),
                              itemBuilder: (context, index) {
                                return HeadDownWidget(head: data[index].title, down: data[index].subtitle);
                              },
                              itemCount: data.length,
                            ),
                          ),
                        ),
                        const Ymargin(SpacingConstants.double20),
                        AppMaterial(
                          width: Responsive.xWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.all(SpacingConstants.double20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const BoldHeaderText(text: remarkText),
                                const Ymargin(SpacingConstants.double20),
                                Container(
                                  padding: const EdgeInsets.all(SpacingConstants.font16),
                                  decoration: BoxDecoration(
                                    color: AppColors.SmatCrowNeuBlue50,
                                    borderRadius: BorderRadius.circular(SpacingConstants.font10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Color600Text(text: remarkText),
                                      Color600Text(text: actionText),
                                    ],
                                  ),
                                ),
                                ...List.generate(
                                  logResp.additionalInfo!.logRemarks!.length,
                                  (index) => Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child:
                                            Color600Text(text: logResp.additionalInfo!.logRemarks![index].remark ?? ""),
                                      ),
                                      Flexible(
                                        child: BoldHeaderText(
                                          text: logResp.additionalInfo!.logRemarks![index].nextAction ?? "",
                                          fontSize: SpacingConstants.font14,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Ymargin(SpacingConstants.double20),
                        AppMaterial(
                          width: Responsive.xWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.all(SpacingConstants.double20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const BoldHeaderText(text: fileUploadedText),
                                const Ymargin(SpacingConstants.double20),
                                ...List.generate(
                                  logResp.additionalInfo!.logFiles!.length,
                                  (index) => ListTile(
                                    leading: Image.asset(AppAssets.pdf),
                                    title: Text(
                                      "$fileText ${index + 1}",
                                      style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
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
                          width: Responsive.xWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.all(SpacingConstants.double20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const BoldHeaderText(text: noteText),
                                const Ymargin(SpacingConstants.size20),
                                Color600Text(text: logResp.log!.notes.toString())
                              ],
                            ),
                          ),
                        ),
                        const Ymargin(SpacingConstants.double20),
                        AppMaterial(
                          width: Responsive.xWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.all(SpacingConstants.double20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const BoldHeaderText(text: ownersText),
                                const Ymargin(SpacingConstants.double20),
                                Container(
                                  padding: const EdgeInsets.all(SpacingConstants.font16),
                                  decoration: BoxDecoration(
                                    color: AppColors.SmatCrowNeuBlue50,
                                    borderRadius: BorderRadius.circular(SpacingConstants.font10),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Color600Text(text: nameText),
                                      Color600Text(text: roleText),
                                    ],
                                  ),
                                ),
                                ...List.generate(
                                  logResp.additionalInfo!.logOwnersList!.length,
                                  (index) => ListTile(
                                    leading: Color600Text(
                                      text: logResp.additionalInfo!.logOwnersList![index].ownerName ?? "",
                                    ),
                                    trailing: BoldHeaderText(
                                      text: logResp.additionalInfo!.logOwnersList![index].ownerRole ?? "",
                                      fontSize: SpacingConstants.font14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Ymargin(SpacingConstants.double20),
                        AppMaterial(
                          width: Responsive.xWidth(context),
                          child: Padding(
                            padding: const EdgeInsets.all(SpacingConstants.double20),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const BoldHeaderText(text: imagesText),
                                const Ymargin(SpacingConstants.double20),
                                Wrap(
                                  runSpacing: SpacingConstants.double20,
                                  spacing: SpacingConstants.double20,
                                  children: List.generate(
                                    logResp.additionalInfo!.logMedia!.length,
                                    (index) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: SpacingConstants.size140,
                                          height: SpacingConstants.size124,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(SpacingConstants.font10),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                logResp.additionalInfo!.logMedia![index].url ?? DEFAULT_IMAGE,
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
                  )
                ],
              ),
            ],
          )
        : Wrap(
            spacing: SpacingConstants.double20,
            runSpacing: SpacingConstants.double20,
            children: [
              SizedBox(
                width: Responsive.xWidth(context),
                child: BoldHeaderText(
                  text: "${logController.logResponse!.log!.name ?? ""} Logs",
                  fontSize: SpacingConstants.font24,
                ),
              ),
              AppMaterial(
                child: Container(
                  height: 300,
                  padding: const EdgeInsets.all(SpacingConstants.font16),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.7,
                    ),
                    itemBuilder: (context, index) {
                      return HeadDownWidget(head: data[index].title, down: data[index].subtitle);
                    },
                    itemCount: data.length,
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
                      const BoldHeaderText(text: noteText),
                      const Ymargin(SpacingConstants.size20),
                      Color600Text(
                        text: logResp.log!.notes.toString(),
                      )
                    ],
                  ),
                ),
              ),
              AppMaterial(
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BoldHeaderText(text: remarkText),
                      const Ymargin(SpacingConstants.double20),
                      Container(
                        padding: const EdgeInsets.all(SpacingConstants.font16),
                        decoration: BoxDecoration(
                          color: AppColors.SmatCrowNeuBlue50,
                          borderRadius: BorderRadius.circular(SpacingConstants.font10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Color600Text(text: remarkText),
                            Color600Text(text: actionText),
                          ],
                        ),
                      ),
                      const Ymargin(SpacingConstants.font10),
                      ...List.generate(
                        logResp.additionalInfo!.logRemarks!.length,
                        (index) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Color600Text(text: logResp.additionalInfo!.logRemarks![index].remark ?? ""),
                            ),
                            Flexible(
                              child: BoldHeaderText(
                                text: logResp.additionalInfo!.logRemarks![index].nextAction ?? "",
                                fontSize: SpacingConstants.font14,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppMaterial(
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BoldHeaderText(text: ownersText),
                      const Ymargin(SpacingConstants.double20),
                      Container(
                        padding: const EdgeInsets.all(SpacingConstants.font16),
                        decoration: BoxDecoration(
                          color: AppColors.SmatCrowNeuBlue50,
                          borderRadius: BorderRadius.circular(SpacingConstants.font10),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Color600Text(text: nameText),
                            Color600Text(text: roleText),
                          ],
                        ),
                      ),
                      ...List.generate(
                        logResp.additionalInfo!.logOwnersList!.length,
                        (index) => ListTile(
                          leading: Color600Text(text: logResp.additionalInfo!.logOwnersList![index].ownerName ?? ""),
                          trailing: BoldHeaderText(
                            text: logResp.additionalInfo!.logOwnersList![index].ownerRole ?? "",
                            fontSize: SpacingConstants.font14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppMaterial(
                width: Responsive.xWidth(context),
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BoldHeaderText(text: imagesText),
                      const Ymargin(SpacingConstants.double20),
                      Wrap(
                        runSpacing: SpacingConstants.double20,
                        spacing: SpacingConstants.double20,
                        children: List.generate(
                          logResp.additionalInfo!.logMedia!.length,
                          (index) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: SpacingConstants.size140,
                                height: SpacingConstants.size124,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(SpacingConstants.font10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      logResp.additionalInfo!.logMedia![index].url ?? DEFAULT_IMAGE,
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
              AppMaterial(
                width: double.maxFinite,
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const BoldHeaderText(text: fileUploadedText),
                      const Ymargin(SpacingConstants.double20),
                      ...List.generate(
                        logResp.additionalInfo!.logFiles!.length,
                        (index) => ListTile(
                          leading: Image.asset(AppAssets.pdf),
                          title: Text(
                            "$fileText ${index + 1}",
                            style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
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
