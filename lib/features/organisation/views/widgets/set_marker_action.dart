import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_latlng_label.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SetMarkerAction extends StatefulHookConsumerWidget {
  const SetMarkerAction({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetMarkerActionState();
}

class _SetMarkerActionState extends ConsumerState<SetMarkerAction> {
  final _pandora = Pandora();
  late MapNotifier mapNotifier;

  @override
  void didChangeDependencies() {
    mapNotifier = ref.watch(mapProvider);
    Future(() {
      mapNotifier.allowMapTap = true;
      if (mapNotifier.automated) {
        mapNotifier.timer.cancel();
        mapNotifier.automated = false;
      }
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final siteController = ref.watch(siteProvider);
    final mapController = ref.watch(mapProvider);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (siteController.subType == SubType.site)
              SiteLatLngLabel(
                head: starting,
                lat:
                    mapController.siteLatLng.isEmpty ? "0.00" : mapController.siteLatLng[0].latitude.toStringAsFixed(5),
                lng: mapController.siteLatLng.isEmpty
                    ? "0.00"
                    : mapController.siteLatLng[0].longitude.toStringAsFixed(5),
              )
            else
              SiteLatLngLabel(
                head: starting,
                lat: mapController.sectorLatLng.isEmpty
                    ? "0.00"
                    : mapController.sectorLatLng[0].latitude.toStringAsFixed(5),
                lng: mapController.sectorLatLng.isEmpty
                    ? "0.00"
                    : mapController.sectorLatLng[0].longitude.toStringAsFixed(5),
              ),
            if (siteController.subType == SubType.site)
              SiteLatLngLabel(
                head: ending,
                lat: mapController.siteLatLng.isEmpty
                    ? "0.00"
                    : mapController.siteLatLng.last.latitude.toStringAsFixed(5),
                lng: mapController.siteLatLng.isEmpty
                    ? "0.00"
                    : mapController.siteLatLng.last.longitude.toStringAsPrecision(5),
              )
            else
              SiteLatLngLabel(
                head: ending,
                lat: mapController.sectorLatLng.isEmpty
                    ? "0.00"
                    : mapController.sectorLatLng.last.latitude.toStringAsFixed(5),
                lng: mapController.sectorLatLng.isEmpty
                    ? "0.00"
                    : mapController.sectorLatLng.last.longitude.toStringAsPrecision(5),
              ),
          ],
        ),
        customSizedBoxHeight(SpacingConstants.size20),
        Container(
          padding: const EdgeInsets.all(SpacingConstants.size10),
          decoration: BoxDecoration(
            color: AppColors.SmatCrowNeuBlue50,
            borderRadius: BorderRadius.circular(SpacingConstants.size8),
          ),
          child: Row(
            children: [
              Text(
                automate,
                style: Styles.smatCrowMediumCaption(AppColors.SmatCrowNeuBlue900).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: SpacingConstants.size5),
              const Icon(
                Icons.error_outline,
                color: AppColors.SmatCrowPrimary300,
                size: SpacingConstants.size16,
              ),
              const Spacer(),
              SizedBox(
                height: SpacingConstants.size17,
                child: Switch.adaptive(
                  value: mapController.automated,
                  activeColor: AppColors.SmatCrowGreen300,
                  onChanged: (value) {
                    _pandora.logAPPButtonClicksEvent('SET_AUTOMATION');
                    ref.read(mapProvider).automated = value;
                    if (value) {
                      ref.read(mapProvider).allowMapTap = false;
                      if (siteController.subType == SubType.site) {
                        mapNotifier.markSiteLocation();
                        _pandora.logAPPButtonClicksEvent('MARK_SITE_LOCATIONS');
                        return;
                      }
                      if (siteController.subType == SubType.sector) {
                        mapNotifier.markSectorLocation();
                        _pandora.logAPPButtonClicksEvent('MARK_SECTOR_LOCATIONS');
                        return;
                      }
                      setState(() {});
                    } else {
                      ref.read(mapProvider).allowMapTap = true;
                    }
                  },
                ),
              )
            ],
          ),
        ),
        customSizedBoxHeight(SpacingConstants.size20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                text: resetMarker,
                onPressed: () {
                  if (siteController.subType == SubType.sector) {
                    _pandora.logAPPButtonClicksEvent('RESET_SECTOR_MARKERS');
                  }
                  if (siteController.subType == SubType.site) {
                    _pandora.logAPPButtonClicksEvent('RESET_SITE_MARKERS');
                  }

                  mapNotifier.markers.clear();
                  mapNotifier.sectorLatLng.clear();
                  mapNotifier.markPoint = 0;
                  mapNotifier.polygon.clear();
                  mapNotifier.siteLatLng.clear();
                },
                leftIcon: Icons.clear,
                height: SpacingConstants.size44,
                fontSize: SpacingConstants.font14,
                iconColor: Colors.white,
                textColor: Colors.white,
                color: AppColors.SmatCrowRed500,
              ),
            ),
            customSizedBoxWidth(SpacingConstants.size10),
            Expanded(
              child: CustomButton(
                text: mapController.automated ? stopAutomatic : markLocation,
                onPressed: () {
                  if (mapNotifier.automated) {
                    mapNotifier.automated = false;
                  } else {
                    if (siteController.subType == SubType.site) {
                      mapNotifier.markSiteLocation();
                      _pandora.logAPPButtonClicksEvent('MARK_SITE_LOCATIONS');
                      return;
                    }
                    if (siteController.subType == SubType.sector) {
                      mapNotifier.markSectorLocation();
                      _pandora.logAPPButtonClicksEvent('MARK_SECTOR_LOCATIONS');
                      return;
                    }
                  }
                },
                height: SpacingConstants.size44,
                fontSize: SpacingConstants.font14,
                leftIcon: mapController.automated ? Icons.stop : Icons.add,
                color: AppColors.SmatCrowPrimary500,
              ),
            )
          ],
        ),
      ],
    );
  }
}
