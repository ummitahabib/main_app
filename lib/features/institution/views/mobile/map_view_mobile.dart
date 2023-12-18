import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/top_search_card.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class MapViewMobile extends StatefulHookConsumerWidget {
  const MapViewMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MapViewMobileState();
}

class _MapViewMobileState extends ConsumerState<MapViewMobile> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  LatLng? currentLocation;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () => ref.watch(mapProvider).getSiteBounds());
  }

  @override
  Widget build(BuildContext context) {
    final map = ref.watch(mapProvider);
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: (ref.read(mapProvider).position != null)
                  ? CameraPosition(
                      target: LatLng(
                        ref.read(mapProvider).position!.latitude,
                        ref.read(mapProvider).position!.latitude,
                      ),
                      zoom: 14.4746,
                    )
                  : _kGooglePlex,
              indoorViewEnabled: true,
              onMapCreated: (GoogleMapController controller) async {
                ref.watch(mapProvider).mapController = controller;
              },
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: map.markers.isEmpty && ref.read(mapProvider).currentLocationMarker != null
                  ? {ref.watch(mapProvider).currentLocationMarker!}
                  : map.markers,
              polygons: map.polygon,
            ),
            Padding(
              padding: Responsive.isMobile(context) ? EdgeInsets.zero : const EdgeInsets.all(SpacingConstants.size20),
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
    );
  }
}
