import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_card_bar.dart';
import 'package:smat_crow/features/organisation/views/widgets/set_marker_action.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class CreateSiteMobile extends HookConsumerWidget {
  const CreateSiteMobile({
    super.key,
    required this.controller,
    required this.siteName,
  });

  final PageController controller;
  final String siteName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapNotifier = ref.watch(mapProvider);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (ref.read(siteProvider).subType == SubType.site) {
            mapNotifier.markers.clear();
            mapNotifier.sectorLatLng.clear();
            mapNotifier.markPoint = 0;
            mapNotifier.polygon.clear();
            mapNotifier.siteLatLng.clear();
            mapNotifier.getCurrentPosition();
          }
        });
        return null;
      },
      [],
    );
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          CustomCardBar(
            title: ref.read(siteProvider).subType == SubType.site ? siteLocation : sectorLocation,
            elevation: 0,
            leadingCallback: () {
              controller.previousPage(
                duration: const Duration(milliseconds: SpacingConstants.int400),
                curve: Curves.easeInOut,
              );
              ref.read(mapProvider).allowMapTap = true;
              if (ref.read(mapProvider).automated) {
                ref.read(mapProvider).timer.cancel();
                ref.read(mapProvider).automated = false;
              }
            },
            trailingIcon: TextButton(
              onPressed: () {
                //implement endpoint and got back to one
                ref.read(mapProvider).allowMapTap = true;
                if (ref.read(mapProvider).automated) {
                  ref.read(mapProvider).timer.cancel();
                  ref.read(mapProvider).automated = false;
                }

                if (ref.read(siteProvider).subType == SubType.sector) {
                  ref.read(sectorProvider).createSectorForSite(context, controller, siteName);
                  return;
                }
                ref.read(siteProvider).createSiteForOrg(context, controller, siteName);
              },
              child: Text(
                done,
                style: Styles.smatCrowMediumSubParagraph(
                  color: AppColors.SmatCrowPrimary500,
                ),
              ),
            ),
            center: true,
          ),
          customSizedBoxHeight(SpacingConstants.size40),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size50 : SpacingConstants.size20,
            ),
            child: const SetMarkerAction(),
          )
        ],
      ),
    );
  }
}
