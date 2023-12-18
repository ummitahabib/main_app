import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/models/sector_by_id.dart';
import 'package:smat_crow/features/shared/data/controller/firebase_controller.dart';

import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SectorOptionMenu extends HookConsumerWidget {
  const SectorOptionMenu({
    super.key,
    required this.pageController,
    this.sector,
  });

  final PageController pageController;
  final SectorById? sector;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton(
      splashRadius: 20,
      position: PopupMenuPosition.under,
      offset: kIsWeb ? const Offset(-100, 0) : Offset.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 12,
      shadowColor: Colors.black.withOpacity(0.07),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {
            if (kIsWeb) {
              pageController.jumpToPage(4);
            } else {
              pageController.jumpToPage(5);
            }
            ref.read(siteProvider).showSiteOptions = false;
            ref.read(firebaseProvider).downloadUrl = null;
          },
          child: PointerInterceptor(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.add,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
                const SizedBox(width: SpacingConstants.size5),
                Text(
                  addBatch,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            if (sector != null) {
              ref.read(sectorProvider).sector = sector;
            }
            ref.read(siteProvider).subType = SubType.sector;
            if (kIsWeb) {
              pageController.jumpToPage(2);
            } else {
              pageController.jumpToPage(8);
            }
          },
          child: PointerInterceptor(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.border_color_outlined,
                  color: AppColors.SmatCrowNeuBlue900,
                ),
                const SizedBox(width: SpacingConstants.size5),
                Text(
                  editSector,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            if (sector != null) {
              ref.read(sectorProvider).deleteSector(sector!.id).then((value) {
                if (value) {
                  ref.read(sectorProvider).getSiteSectors(ref.read(siteProvider).site!.id);
                  ref.read(siteProvider).subType = SubType.sector;
                }
              });
            }
          },
          child: PointerInterceptor(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.delete_outline_outlined,
                  color: AppColors.SmatCrowRed500,
                ),
                const SizedBox(width: SpacingConstants.size5),
                Text(
                  "$delete $sectorText",
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowRed500),
                )
              ],
            ),
          ),
        ),
      ],
      icon: Icon(
        Icons.more_horiz,
        color: (ref.read(siteProvider).subType == SubType.sector) ? null : AppColors.SmatCrowPrimary300,
      ),
    );
  }
}
