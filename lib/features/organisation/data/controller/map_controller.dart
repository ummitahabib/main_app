import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/models/polygon_area.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils/strings.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';

final mapProvider = ChangeNotifierProvider<MapNotifier>((ref) {
  return MapNotifier(ref);
});

class MapNotifier extends ChangeNotifier {
  final Ref ref;

  MapNotifier(this.ref);

  final Set<Marker> markers = HashSet<Marker>();
  final Set<Polygon> polygon = HashSet<Polygon>();
  final List<LatLng> siteLatLng = <LatLng>[];
  final List<LatLng> sectorLatLng = <LatLng>[];
  Marker? _currentLocationMarker;
  Marker? get currentLocationMarker => _currentLocationMarker;
  GoogleMapController? _mapController;
  GoogleMapController? get mapController => _mapController;

  late Timer timer;
  Position? _position;
  Position? get position => _position;
  final Pandora _pandora = Pandora();
  bool _automated = false;
  bool get automated => _automated;

  bool _showSitePolygon = true;

  bool get showSitePolygon => _showSitePolygon;

  bool _allowMapTap = false;
  bool get allowMapTap => _allowMapTap;
  double oldZoom = 14.4746;
  double _zoom = 20;
  double get zoom => _zoom;
  set zoom(double value) {
    _zoom = value;
    notifyListeners();
  }

  //marking start point
  int _markPoint = 0;
  int get markPoint => _markPoint;

  double polygonArea = 0.0;

  set automated(bool state) {
    _automated = state;
    notifyListeners();
  }

  set allowMapTap(bool state) {
    _allowMapTap = state;
    notifyListeners();
  }

  set mapController(GoogleMapController? con) {
    _mapController = con;
    notifyListeners();
  }

  set showSitePolygon(bool state) {
    _showSitePolygon = state;
    notifyListeners();
  }

  set currentLocationMarker(Marker? mrk) {
    _currentLocationMarker = mrk;
    notifyListeners();
  }

  set markPoint(int point) {
    _markPoint = point;
    notifyListeners();
  }

  set position(Position? pos) {
    _position = pos;
    notifyListeners();
  }

  void markSiteLocation() {
    if (automated) {
      automateSiteMarker();
    } else {
      addSiteMarker();
    }
  }

  Future<List<List<List<double>>>?> getGeoJsonList(BuildContext context, List<LatLng> listCoord) async {
    final List<List<double>> coordinates = [];
    final List<List<List<double>>> list = [];

    list.insert(0, coordinates);

    if (listCoord.length < 4) {
      _pandora.showToast(Errors.sectorPolygonError, context, MessageTypes.WARNING.toString().split('.').last);
      return null;
    }
    for (int i = 0; i < listCoord.length; i++) {
      List<double> coord = [];
      coord.add(listCoord[i].latitude);
      coord.add(listCoord[i].longitude);
      coordinates.insert(i, coord);
    }
    if (listCoord.first != listCoord.last) {
      coordinates.add([listCoord.first.latitude, listCoord.first.longitude]);
      listCoord.add(LatLng(listCoord.first.latitude, listCoord.first.longitude));
    }

    if (listCoord.first != listCoord.last) {
      _pandora.showToast(Errors.inCorrectPointError, context, MessageTypes.WARNING.toString().split('.').last);
      return null;
    }

    return list;
  }

  void automateSiteMarker() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (automated) {
        addSiteMarker();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> addSiteMarker() async {
    position = await GeoLocatorService().getCurrentLocation();
    if (position != null) {
      markers.add(
        getMarkers(LatLng(_position!.latitude, _position!.longitude), markPoint),
      );

      siteLatLng.add(LatLng(_position!.latitude, _position!.longitude));
      markPoint++;
      polygon.add(
        getPolygon(siteLatLng, sitePolygon),
      );
    } else {
      position = await GeoLocatorService().getCurrentLocation();
    }
  }

  void markSectorLocation() {
    if (automated) {
      automateSectorMarker();
    } else {
      addSectorMarker();
    }
  }

  void automateSectorMarker() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (automated) {
        addSectorMarker();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> addSectorMarker() async {
    position = await GeoLocatorService().getCurrentLocation();
    if (position != null) {
      if (isPointInPolygon(LatLng(position!.latitude, position!.longitude), siteLatLng)) {
        markPoint = siteLatLng.length;
        markers.add(
          getMarkers(LatLng(position!.latitude, position!.longitude), markPoint),
        );
        sectorLatLng.add(LatLng(position!.latitude, position!.longitude));
        markPoint++;
        polygon.add(
          getPolygon(sectorLatLng, sectorPolygon),
        );
      } else {
        snackBarMsg(markerOutOfRange);
      }
    } else {
      position = await GeoLocatorService().getCurrentLocation();
    }
  }

  Polygon getPolygon(List<LatLng> list, String id) {
    return Polygon(
      polygonId: PolygonId(id),
      points: list,
      strokeWidth: 5,
      strokeColor: AppColors.SmatCrowGreen700,
      fillColor: AppColors.SmatCrowGreen200.withOpacity(0.15),
    );
  }

  Marker getMarkers(LatLng latLng, int index) {
    return Marker(
      markerId: MarkerId('$pointText $index'),
      infoWindow: InfoWindow(
        title: '$pointText $index : $positionText $latText: ${latLng.latitude}, $lngText: ${latLng.longitude}',
      ),
      position: latLng,
    );
  }

  double calculatePolygonArea(PolygonArea data) {
    final area = GeoJSONPolygon.fromMap(data.toJson()).area;
    polygonArea = area;
    notifyListeners();
    return area;
  }

  void getCurrentPosition() {
    Geolocator.getCurrentPosition().then((position) {
      currentLocationMarker = Marker(
        markerId: MarkerId(currentLocationText.toLowerCase().replaceAll(" ", "_")),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: const InfoWindow(title: currentLocationText),
      );
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
        );
      }
    });
  }

  Future getSiteBounds([bool drawPolygon = true]) async {
    final siteData = ref.read(siteProvider).site;
    if (siteData != null) {
      polygon.clear();
      siteLatLng.clear();
      final cameraPosition = CameraPosition(
        target: LatLng(siteData.geoJson[0][0][0], siteData.geoJson[0][0][1]),
        zoom: 14.4746,
      );
      for (int i = 0; i < siteData.geoJson[0].length; i++) {
        siteLatLng.add(LatLng(siteData.geoJson[0][i][0], siteData.geoJson[0][i][1]));
      }
      if (!drawPolygon) {
        for (final element in siteLatLng) {
          markers.add(getMarkers(element, siteLatLng.indexOf(element)));
        }
      }

      if (drawPolygon) {
        polygon.add(
          getPolygon(siteLatLng, sitePolygon),
        );
      }
      showSitePolygon = drawPolygon;

      await mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      calculatePolygonArea(PolygonArea(geoJson: siteData.geoJson, type: "Polygon"));
    } else {
      snackBarMsg(polygonWarning);
    }
  }

  bool isPointInPolygon(LatLng point, List<LatLng> polygon) {
    final double x = point.longitude;
    final double y = point.latitude;
    int intersections = 0;

    final int verticesCount = polygon.length;
    for (int i = 0; i < verticesCount; i++) {
      final LatLng vertex1 = polygon[i];
      final LatLng vertex2 = polygon[(i + 1) % verticesCount];

      final double x1 = vertex1.longitude;
      final double y1 = vertex1.latitude;
      final double x2 = vertex2.longitude;
      final double y2 = vertex2.latitude;

      if (y > min(y1, y2) && y <= max(y1, y2) && x <= max(x1, x2) && y1 != y2) {
        final double xIntersection = (y - y1) * (x2 - x1) / (y2 - y1) + x1;
        if (x1 == x2 || x <= xIntersection) {
          intersections++;
        }
      }
    }

    return intersections.isOdd;
  }

  Future getSectorBounds() async {
    final siteData = ref.read(sectorProvider).sector;
    if (siteData != null) {
      polygon.clear();
      sectorLatLng.clear();
      final cameraPosition = CameraPosition(
        target: LatLng(siteData.sectorCoordinates[0][0][0], siteData.sectorCoordinates[0][0][1]),
        zoom: 16.4746,
      );
      for (int i = 0; i < siteData.sectorCoordinates[0].length; i++) {
        sectorLatLng.add(LatLng(siteData.sectorCoordinates[0][i][0], siteData.sectorCoordinates[0][i][1]));
      }
      polygon.add(
        getPolygon(sectorLatLng, sectorPolygon),
      );

      await mapController!.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
      calculatePolygonArea(PolygonArea(geoJson: siteData.sectorCoordinates, type: "Polygon"));
    } else {
      snackBarMsg(polygonWarning);
    }
  }
}
