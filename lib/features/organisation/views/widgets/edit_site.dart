import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_name.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class EditSite extends HookConsumerWidget {
  const EditSite({
    super.key,
    required this.pageController,
  });

  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeWebContainer(
      title: ref.read(siteProvider).subType == SubType.sector ? "$editSector $nameText" : "$editSite $nameText",
      leadingCallback: () {
        pageController.jumpToPage(0);
      },
      width: Responsive.xWidth(context),
      trailingIcon: const SizedBox.shrink(),
      child: Padding(
        padding: const EdgeInsets.all(SpacingConstants.size20),
        child: SiteName(
          hintText: ref.read(siteProvider).subType == SubType.sector ? "$editSector $nameText" : null,
          controller: ref.read(orgNavigationProvider).pageController,
          buttonName: saveChanges,
          initialValue: (ref.read(siteProvider).subType == SubType.site && ref.read(siteProvider).site != null)
              ? ref.read(siteProvider).site!.name
              : (ref.read(siteProvider).subType == SubType.sector && ref.read(sectorProvider).sector != null)
                  ? ref.read(sectorProvider).sector!.name
                  : null,
          callback: (value) {
            if (value != null && value.trim().isNotEmpty) {
              if (ref.read(siteProvider).subType == SubType.site) {
                ref.read(siteProvider).updateSite(ref.read(siteProvider).site!.id, {
                  "name": value,
                }).then((value) {
                  if (value) {
                    pageController.jumpToPage(0);
                  }
                });
                return;
              }
              if (ref.read(siteProvider).subType == SubType.sector) {
                ref.read(sectorProvider).updateSector(ref.read(sectorProvider).sector!.id, {
                  "name": value,
                }).then((value) {
                  if (value) {
                    pageController.jumpToPage(0);
                  }
                });
                return;
              }
            } else {
              snackBarMsg(nameWarning);
            }
          },
        ),
      ),
    );
  }
}
