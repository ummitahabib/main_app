import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/models/sector_item.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/export_map.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/soil_info.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/soil_test.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/weather_info.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/item_card.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/screens/subscription/components/subscription_model.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../pages/site_map_options/satellite_imagery.dart';

class SiteMapOptions extends StatefulHookConsumerWidget {
  const SiteMapOptions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SiteMapOptionsState();
}

class _SiteMapOptionsState extends ConsumerState<SiteMapOptions> {
  void mapOption(String name) {
    switch (name) {
      case soilTest:
        customDialogAndModal(context, const SoilTest());
        return;
      case weatherInfo:
        if (ref.read(siteProvider).site!.polygonId == '0') {
          snackBarMsg(polygonSizeWarning);
          return;
        }
        if (Responsive.isDesktop(context)) {
          ref.read(orgNavigationProvider).mapPageController.jumpToPage(2);
          return;
        }
        customDialogAndModal(context, const WeatherInfo());
        return;
      case soilInfo:
        if (ref.read(siteProvider).site!.polygonId == '0') {
          snackBarMsg(polygonSizeWarning);
          return;
        }
        if (Responsive.isDesktop(context)) {
          ref.read(orgNavigationProvider).mapPageController.jumpToPage(1);
          return;
        }
        customDialogAndModal(context, const SoilInfo());
        return;
      case exportMap:
        customDialogAndModal(context, const ExportMap());
        return;
      case satelliteImagery:
        customDialogAndModal(context, const SatelliteImagery());
        return;
      case siteReport:
        if (ref.read(sharedProvider).userInfo != null &&
            ref.read(sharedProvider).userInfo!.perks.contains(AppPermissions.site_report)) {
          ref.read(siteProvider).generateSiteReport();
          return;
        } else {
          SubscriptionModal.showSubscriptionModal(context);
          return;
        }
      default:
        customDialogAndModal(context, Container());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: kIsWeb
          ? const EdgeInsets.symmetric(horizontal: SpacingConstants.size20)
          : const EdgeInsets.only(left: SpacingConstants.size20),
      child: kIsWeb
          ? Center(
              child: Wrap(
                runSpacing: SpacingConstants.size10,
                spacing: SpacingConstants.size10,
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  ...sectorItemList.map(
                    (e) => InkWell(
                      onTap: () {
                        mapOption(e.name);
                      },
                      child: ItemCard(
                        asset: e.asset,
                        name: e.name,
                      ),
                    ),
                  )
                ],
              ),
            )
          : SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: sectorItemList.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    mapOption(sectorItemList[index].name);
                  },
                  child: ItemCard(
                    asset: sectorItemList[index].asset,
                    name: sectorItemList[index].name,
                  ),
                ),
              ),
            ),
    );
  }
}

final sectorItemList = [
  SectorItem(AppAssets.weatherInfo, weatherInfo),
  SectorItem(AppAssets.view, soilTest),
  SectorItem(AppAssets.soilInfo, soilInfo),
  SectorItem(AppAssets.compass, satelliteImagery),
  SectorItem(AppAssets.report, siteReport),
  SectorItem(AppAssets.download, exportMap),
];
