import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  Stream<Position> streamCurrentLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        distanceFilter: 10,
      ),
    );
  }

  Future<Position?> getCurrentLocation() async {
    final permn = await Geolocator.checkPermission();
    if (permn == LocationPermission.denied) {
      final permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
      return Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
      );
    } else {
      return Geolocator.getCurrentPosition(
        forceAndroidLocationManager: true,
      );
    }
  }
}
