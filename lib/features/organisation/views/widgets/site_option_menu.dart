import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/models/site_by_id.dart';

import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SiteOptionMenu extends HookConsumerWidget {
  const SiteOptionMenu({
    super.key,
    required this.pageController,
    this.site,
    this.fromSite = false,
  });

  final PageController pageController;
  final SiteById? site;
  final bool fromSite;

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
            ref.read(siteProvider).subType = SubType.sector;
            if (site != null) {
              ref.read(siteProvider).site = site;
              ref.read(sectorProvider).getSiteSectors(site!.id);
              ref.read(mapProvider).getSiteBounds(false);
            }
            pageController.jumpToPage(1);
            ref.read(mapProvider).allowMapTap = true;
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
                  addSector,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            if (site != null) {
              ref.read(siteProvider).site = site;
            }
            if (fromSite) {
              ref.read(siteProvider).subType = SubType.site;
            }
            if (kIsWeb) {
              pageController.jumpToPage(2);
            } else {
              pageController.jumpToPage(3);
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
                  editSite,
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                )
              ],
            ),
          ),
        ),
        PopupMenuItem(
          onTap: () {
            if (site != null) {
              ref.read(siteProvider).deleteSite(site!.id).then((value) {
                if (value) {
                  ref.read(siteProvider).getOrganizationSites(ref.read(organizationProvider).organization!.id ?? "");
                  ref.read(siteProvider).subType = SubType.site;
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
                  "$delete $siteText",
                  style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowRed500),
                )
              ],
            ),
          ),
        ),
      ],
      icon: Icon(
        Icons.more_horiz,
        color: (ref.read(siteProvider).subType == SubType.site) ? null : AppColors.SmatCrowPrimary300,
      ),
    );
  }
}
