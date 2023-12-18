import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils/session.dart';

final fieldProvider = ChangeNotifierProvider<FieldMeasurementPageProvider>((ref) {
  return FieldMeasurementPageProvider();
});

class FieldMeasurementPageProvider extends ChangeNotifier {
  final GeoLocatorService geoService = GeoLocatorService();
  NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');

  Position? _position;
  Position? get position => _position;
  set position(Position? pos) {
    _position = pos;
    notifyListeners();
  }

  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;
  set mapController(GoogleMapController? con) {
    _mapController = con;
    notifyListeners();
  }

  Set<Marker> _markers = <Marker>{};
  Set<Marker> get markers => _markers;
  set markers(Set<Marker> mark) {
    _markers = mark;
    notifyListeners();
  }

  Set<Polygon> _polygon = <Polygon>{};
  Set<Polygon> get polygon => _polygon;
  set polygon(Set<Polygon> poly) {
    _polygon = poly;
    notifyListeners();
  }

  List<LatLng> _measurementPoints = <LatLng>[];
  List<LatLng> get measurementPoints => _measurementPoints;
  set measurementPoints(List<LatLng> measurement) {
    _measurementPoints = measurement;
    notifyListeners();
  }

  Pandora pandora = Pandora();
  int i = 0;
  double area = 0.00000;
  GetSiteById? siteData;
  String field_pro_in_app = 'N';

  CameraPosition userLocation = CameraPosition(
    target: Session.position == null
        ? const LatLng(37.42796133580664, -122.085749655962)
        : LatLng(Session.position!.latitude, Session.position!.longitude),
    zoom: 20,
  );

  bool _automated = false;
  bool get automated => _automated;
  set automated(bool value) {
    _automated = value;
    notifyListeners();
  }

  late Timer timer;
  bool get mounted => false;
  int page = 0;

  void automateSiteMarker() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (automated) {
        markSiteLocation();
      } else {
        timer.cancel();
      }
    });
  }

  Marker? _currentLocationMarker;
  Marker? get currentLocationMarker => _currentLocationMarker;
  set currentLocationMarker(Marker? mrk) {
    _currentLocationMarker = mrk;
    notifyListeners();
  }

  Future<void> markSiteLocation({Position? pos}) async {
    await geoService.getCurrentLocation().then((event) {
      position = event;
      if (position != null) {
        markers.add(
          Marker(
            markerId: MarkerId('${position!.latitude},${position!.longitude}'),
            draggable: true,
            infoWindow: InfoWindow(
              title: 'Point $i : Position lat: ${position!.latitude},lng: ${position!.longitude}',
            ),
            position: LatLng(position!.latitude, position!.longitude),
          ),
        );
        measurementPoints.add(LatLng(position!.latitude, position!.longitude));
        drawPolygon(measurementPoints);
        i++;
      }
      notifyListeners();
    });
  }

  void drawPolygon(List<LatLng> listLatLng) {
    polygon.add(
      Polygon(
        polygonId: PolygonId(i.toString()),
        points: listLatLng,
        fillColor: Colors.transparent,
        strokeColor: Colors.greenAccent,
        strokeWidth: 5,
      ),
    );
  }

  static String convertListLatLngToGeoJson(List<LatLng> latLngs) {
    String geoJson = '{"type":"Polygon","coordinates":[[';
    for (final LatLng latLng in latLngs) {
      geoJson += "[${latLng.latitude},${latLng.longitude}],";
    }
    geoJson = geoJson.substring(0, geoJson.length - 1);
    geoJson += "]]}";
    return geoJson;
  }

  double calculatePolygonArea(List<LatLng> coordinates) {
    final body = json.decode(convertListLatLngToGeoJson(coordinates));

    final area = GeoJSONPolygon.fromMap(body).area;

    return area;
  }

  void removeMarker(String markerId) {
    final Marker marker = markers.firstWhere((marker) => marker.markerId.value == markerId);
    markers.remove(marker);
    notifyListeners();
  }

  bool validateSectorData(String sectorName, String sectorDescription, List<LatLng> sectorLatLng) {
    return (sectorName.isEmpty || sectorDescription.isEmpty || sectorLatLng.isEmpty) ? false : true;
  }
}
