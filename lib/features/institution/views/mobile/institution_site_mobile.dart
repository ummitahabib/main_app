import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/views/web/institution_site.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_google_map.dart';
import 'package:smat_crow/features/organisation/views/widgets/top_search_card.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class InstitutionSiteMobile extends StatefulHookConsumerWidget {
  const InstitutionSiteMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InstitutionSiteMobileState();
}

class _InstitutionSiteMobileState extends ConsumerState<InstitutionSiteMobile> {
  final GeoLocatorService geoService = GeoLocatorService();

  final _pandora = Pandora();
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  final draggableScrollableController = DraggableScrollableController();

  LatLng? currentLocation;

  late MapNotifier mapNotifier;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    mapNotifier = ref.watch(mapProvider);
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await geoService.getCurrentLocation();
      if (position != null) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          mapNotifier.position = position;
          setState(() {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: [
                const CustomGoogleMap(),
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
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            maxChildSize: 0.9,
            controller: draggableScrollableController,
            builder: (context, scrollController) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(SpacingConstants.size20),
                  topRight: Radius.circular(SpacingConstants.size20),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(SpacingConstants.size20),
                      topRight: Radius.circular(SpacingConstants.size20),
                    ),
                  ),
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    children: [
                      const ModalStick(),
                      const Ymargin(SpacingConstants.font10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back_ios),
                          ),
                          BoldHeaderText(
                            text: ref.watch(institutionProvider).instOrganization != null
                                ? (ref.watch(institutionProvider).instOrganization!.organizationName ?? "")
                                : emptyString,
                          ),
                          Container(width: 50)
                        ],
                      ),
                      const Ymargin(SpacingConstants.double20),
                      const InstitutionSite()
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
