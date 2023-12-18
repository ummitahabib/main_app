import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';

class CustomGoogleMap extends StatefulHookConsumerWidget {
  const CustomGoogleMap({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CustomGoogleMapState();
}

class _CustomGoogleMapState extends ConsumerState<CustomGoogleMap> {
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 20,
  );
  final GeoLocatorService geoService = GeoLocatorService();

  final _pandora = Pandora();
  @override
  void initState() {
    _getCurrentLocation();
    super.initState();
  }

  final polygon = <Polygon>{};
  LatLng? currentLocation;

  Future<void> _getCurrentLocation() async {
    try {
      final position = await geoService.getCurrentLocation();
      if (position != null) {
        setState(() {
          currentLocation = LatLng(position.latitude, position.longitude);
        });
        await ref.watch(mapProvider).mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation!));
        await Future.delayed(const Duration(seconds: 1), () => ref.watch(mapProvider).position = position);
      }
    } catch (e) {
      _pandora.logAPIEvent(
        "GET_USER_CURRENT_LOCATION",
        e.toString(),
        "error",
        e.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final map = ref.watch(mapProvider);

    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: (ref.watch(mapProvider).position != null)
          ? CameraPosition(
              target: LatLng(
                ref.watch(mapProvider).position!.latitude,
                ref.watch(mapProvider).position!.latitude,
              ),
              zoom: ref.watch(mapProvider).zoom,
            )
          : _kGooglePlex,
      indoorViewEnabled: true,
      onMapCreated: (GoogleMapController controller) async {
        ref.watch(mapProvider).mapController = controller;
        setState(() {
          if (currentLocation != null) {
            ref.watch(mapProvider).mapController!.animateCamera(CameraUpdate.newLatLng(currentLocation!));
          } else {
            if (ref.watch(mapProvider).position != null) {
              ref.watch(mapProvider).mapController!.animateCamera(
                    CameraUpdate.newLatLng(
                      LatLng(
                        ref.watch(mapProvider).position!.latitude,
                        ref.watch(mapProvider).position!.latitude,
                      ),
                    ),
                  );
            }
          }
        });
      },
      minMaxZoomPreference: const MinMaxZoomPreference(16, 20),
      myLocationEnabled: true,
      onTap: (argument) {
        _pandora.logAPPButtonClicksEvent("SET_MARKER_ON_MAP");
        if (ref.read(mapProvider).allowMapTap) {
          if (ref.read(siteProvider).subType == SubType.site) {
            map.siteLatLng.add(argument);
            map.markers.add(
              Marker(
                markerId: MarkerId("$pointText ${map.markPoint}"),
                position: argument,
              ),
            );
            ref.read(mapProvider).markPoint++;
            map.polygon.add(
              Polygon(
                fillColor: AppColors.SmatCrowGreen100.withOpacity(0.3),
                polygonId: PolygonId("$pointText ${map.markPoint}"),
                points: map.siteLatLng,
                strokeColor: const Color.fromARGB(255, 211, 211, 211),
                strokeWidth: 3,
              ),
            );
          } else {
            if (map.isPointInPolygon(argument, map.siteLatLng)) {
              ref.read(mapProvider).markPoint = map.siteLatLng.length;
              map.sectorLatLng.add(argument);
              map.markers.add(
                Marker(
                  markerId: MarkerId("$pointText ${map.markPoint}"),
                  position: argument,
                ),
              );
              ref.read(mapProvider).markPoint++;
              setState(() {
                polygon.add(
                  Polygon(
                    fillColor: AppColors.SmatCrowGreen100.withOpacity(0.3),
                    polygonId: PolygonId("$pointText ${map.markPoint}"),
                    points: map.sectorLatLng,
                    strokeColor: const Color.fromARGB(255, 211, 211, 211),
                    strokeWidth: 3,
                  ),
                );
              });
            } else {
              snackBarMsg(markerOutOfRange);
            }
          }
        }
      },
      zoomControlsEnabled: false,
      markers: map.markers.isEmpty && ref.watch(mapProvider).currentLocationMarker != null
          ? {ref.watch(mapProvider).currentLocationMarker!}
          : map.markers,
      polygons: map.showSitePolygon ? map.polygon : polygon,
    );
  }
}
