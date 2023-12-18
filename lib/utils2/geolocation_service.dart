import 'package:geolocator/geolocator.dart';

class GeoLocatorService {
  Stream<Position> streamCurrentLocation() {
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  Future<Position> getCurrentLocation() {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
