// ignore_for_file: use_build_context_synchronously

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/crow/models/farm_management/assets/generic_organization_assets.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../network/crow/farm_manager_operations.dart';
import '../../../network/crow/models/request/farm_management/create_log_asset.dart';
import '../../../utils/strings.dart';
import '../../../utils/styles.dart';
import '../pages/farmmanagement/fam_management_select_boolean_menu.dart';

class FarmLogAddAssetsItem extends StatelessWidget {
  final Datum asset;
  final FileUploadDetailsArgs uploadArgs;

  const FarmLogAddAssetsItem({Key? key, required this.asset, required this.uploadArgs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: AppColors.whiteColor,
        elevation: 0.1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            asset.name ?? "",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflowMd()),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inactiveTabTextColor.withOpacity(.2),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            child: Text(
                              asset.type ?? "",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: (asset.status == Active)
                                    ? AppColors.greenColor.withOpacity(.2)
                                    : AppColors.redColor.withOpacity(.2),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                child: Text(
                                  asset.status ?? "",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: (asset.flags == "Monitor")
                                    ? AppColors.redColor.withOpacity(.2)
                                    : AppColors.greenColor.withOpacity(.2),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                child: Text(
                                  asset.flags ?? "",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: (asset.deleted == "Y")
                                    ? AppColors.userProfileBackground.withOpacity(.2)
                                    : AppColors.completedColor.withOpacity(.2),
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                child: Text(
                                  (asset.deleted == "Y") ? "Draft" : "Published",
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(EvaIcons.pricetagsOutline, color: AppColors.userProfileBackground, size: 13),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "NGN ${asset.cost} Each",
                                maxLines: 1,
                                style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Text(
                            "Quantity:  ${asset.quantity} Pcs",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflowBold()),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.inactiveTabTextColor.withOpacity(.2),
                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                            child: Text(
                              (asset.canExpire ?? false) ? "Can Expire" : "Cannot Expire",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Styles.outlineCalender(),
                            const SizedBox(
                              width: 5,
                            ),
                            Flexible(
                              child: Text(
                                "Purchase Date",
                                maxLines: 1,
                                style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: Text(
                            "${asset.acquisitionDate!.day}-${asset.acquisitionDate!.month}-${asset.acquisitionDate!.year}",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        displayModalWithChild(
          FarmManagementSelectBooleanMenu(
            selectedOption: (value) async {
              if (value) {
                final added =
                    await attachLogAsset(CreateLogAsset(assetId: asset.id!, logId: uploadArgs.logDetailsResponse!.id!));
                if (added) {
                  Navigator.pop(context);
                }
              }
            },
          ),
          'Are you Sure ?',
          context,
        );
      },
    );
  }
}
