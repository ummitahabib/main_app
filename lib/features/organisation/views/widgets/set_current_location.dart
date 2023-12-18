import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SetCurrentLocation extends StatefulHookConsumerWidget {
  const SetCurrentLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetCurrentLocationState();
}

class _SetCurrentLocationState extends ConsumerState<SetCurrentLocation> {
  final GeoLocatorService geoService = GeoLocatorService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SpacingConstants.size20),
      child: InkWell(
        onTap: () {
          try {
            ref.read(mapProvider).markers.clear();
            ref.read(mapProvider).siteLatLng.clear();
            ref.read(mapProvider).getCurrentPosition();
            setState(() {});
          } catch (e) {
            Pandora().logAPIEvent(
              "GET_USER_CURRENT_LOCATION",
              emptyString,
              "error",
              e.toString(),
            );
          }
        },
        child: PointerInterceptor(
          child: Container(
            width: SpacingConstants.size40,
            height: SpacingConstants.size40,
            decoration: const ShapeDecoration(
              color: Colors.white,
              shape: OvalBorder(),
            ),
            child: const Center(
              child: Icon(
                Icons.my_location,
                size: SpacingConstants.size30,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
