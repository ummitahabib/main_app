import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:money_formatter/money_formatter.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/draggable_sheet.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_google_map.dart';
import 'package:smat_crow/features/organisation/views/widgets/item_card.dart';
import 'package:smat_crow/features/organisation/views/widgets/top_search_card.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmSiteViewMobile extends StatefulHookConsumerWidget {
  const FarmSiteViewMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SiteDetailMobileState();
}

class _SiteDetailMobileState extends ConsumerState<FarmSiteViewMobile> {
  final GeoLocatorService geoService = GeoLocatorService();

  final _pandora = Pandora();
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  LatLng? currentLocation;

  Future<void> _getCurrentLocation() async {
    try {
      final position = await geoService.getCurrentLocation();

      if (position != null) {
        await Future.delayed(const Duration(seconds: 1), () async {
          setState(() {
            ref.watch(mapProvider).position = position;
            currentLocation = LatLng(position.latitude, position.longitude);
            ref.watch(mapProvider).currentLocationMarker = Marker(
              markerId: MarkerId(
                currentLocationText.toLowerCase().replaceAll(" ", "_"),
              ),
              position: LatLng(position.latitude, position.longitude),
              infoWindow: const InfoWindow(title: currentLocationText),
            );
          });
        });
      }
    } catch (e) {
      _pandora.logAPIEvent(
        "GET_USER_CURRENT_LOCATION",
        emptyString,
        "error",
        e.toString(),
      );
    }
  }

  String moneyFormatter(int amount) {
    final MoneyFormatter fmf = MoneyFormatter(amount: amount.toDouble());

    return fmf.output.nonSymbol;
  }

  @override
  Widget build(BuildContext context) {
    final map = ref.watch(mapProvider);
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    const CustomGoogleMap(),
                    Positioned(
                      bottom: Responsive.yHeight(context, percent: 0.4),
                      right: SpacingConstants.size20,
                      child: ItemCard(
                        asset: AppAssets.landSize,
                        name: "${moneyFormatter(map.polygonArea.floorToDouble().toInt())} sqm",
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding:
                      Responsive.isMobile(context) ? EdgeInsets.zero : const EdgeInsets.all(SpacingConstants.size20),
                  child: const Row(
                    children: [
                      Expanded(
                        child: TopSearchCard(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const FieldDraggableSheet()
        ],
      ),
    );
  }
}
