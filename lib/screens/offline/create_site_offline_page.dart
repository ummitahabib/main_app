import 'dart:async';
import 'dart:collection';

import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smat_crow/hive/daos/SitesEntity.dart';
import 'package:smat_crow/hive/implementation/sites_impl.dart';
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/network/crow/sites_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/custom_dragging_handle.dart';
import 'package:smat_crow/screens/widgets/old_text_field.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils/strings.dart';

import '../../utils/styles.dart';

class CreateSiteOffline extends StatefulWidget {
  final CreateSiteSectorArgs createSiteSectorArgs;

  const CreateSiteOffline({Key? key, required this.createSiteSectorArgs}) : super(key: key);

  @override
  _CreateSiteOfflineState createState() => _CreateSiteOfflineState();
}

class _CreateSiteOfflineState extends State<CreateSiteOffline> with WidgetsBindingObserver {
  final GeoLocatorService geoService = GeoLocatorService();

  final Completer<GoogleMapController> _controller = Completer();
  Position? _position;
  final Set<Marker> _markers = HashSet<Marker>();
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final List<LatLng> _siteLatLng = <LatLng>[];
  late Widget _details;
  late Widget _actions;
  bool automated = false;

  Pandora pandora = Pandora();
  int i = 0;
  TextEditingController siteName = TextEditingController();
  TextEditingController sectorName = TextEditingController();
  TextEditingController sectorDescription = TextEditingController();
  final Pandora _pandora = Pandora();
  Position? position;
  GetSiteById? siteData;
  CameraPosition? _cameraPosition;
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  Timer? timer;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  SitesImpl store = SitesImpl();

  static final CameraPosition _userLocation = CameraPosition(
    target: LatLng(Session.position!.latitude, Session.position!.longitude),
    zoom: 14.4746,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    geoService.streamCurrentLocation().listen((position) {
      centerScreen(position);
    });
    getUserLocation();
    store.initializeSiteHive();
    super.initState();
    _details = createSiteWidget();
    _actions = siteActionButtons();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initMapStyle();
    }
  }

  Future<void> _initMapStyle() async {
    final GoogleMapController controller = await _controller.future;
    await controller.setMapStyle("[]");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: getUserLocation(),
      rememberFutureResult: true,
      whenDone: (obj) => createOfflineSiteBody(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load coordinates"),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Future<dynamic> getUserLocation() async {
    return _asyncMemoizer.runOnce(() async {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);

      setState(() {
        position = position;
        Session.position = position;
      });
      return position;
    });
  }

  Widget createOfflineSiteBody() {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _userLocation,
              markers: _markers,
              polygons: _polygon,
              myLocationEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: AppColors.landingOrangeButton,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    decoration: Styles.containerBoxDeco(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 6),
                          child: Text("Automate", style: Styles.nunitoRegularStyleBlack()),
                        ),
                        Switch(
                          onChanged: toggleSwitch,
                          value: automated,
                          activeColor: Colors.red,
                          activeTrackColor: Colors.orange,
                          inactiveThumbColor: Colors.blue,
                          inactiveTrackColor: Colors.blueGrey,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.30,
              minChildSize: 0.15,
              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _actions,
                      Styles.smallSizedBox(),
                      Card(
                        elevation: 12.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        margin: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            Styles.defaultSizedBox(),
                            const CustomDraggingHandle(),
                            Styles.smallSizedBox(),
                            _details
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void toggleSwitch(bool value) {
    if (automated == false) {
      setState(() {
        automated = true;
      });
      debugPrint('Switch Button is ON');
    } else {
      setState(() {
        automated = false;
      });
      debugPrint('Switch Button is OFF');
    }
  }

  Future<void> centerScreen(Position position) async {
    if (mounted) {
      setState(() {
        _position = position;
      });
    }
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(position.latitude, position.longitude), zoom: 18.0),
      ),
    );
  }

  Widget createSiteWidget() {
    return Container(
      width: _screenWidth,
      decoration: Styles.defaultBoxDeco24(),
      child: Column(
        children: [
          const BottomSheetHeaderText(text: "Create Site"),
          const SizedBox(height: 31),
          TextInputContainer(
            child: TextField(
              autocorrect: false,
              controller: siteName,
              keyboardType: TextInputType.name,
              style: Styles.nunitoRegularStyle(),
              decoration: InputDecoration(
                hintText: "Enter Site Name",
                border: InputBorder.none,
                hintStyle: Styles.nunitoRegularStyle(),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SquareButton(
            backgroundColor: AppColors.landingOrangeButton,
            press: () {
              if (validateSiteData(siteName.text, _siteLatLng, _polygon, _markers)) {
                createSite();
              } else {
                _pandora.showToast(Errors.polygonError, context, MessageTypes.WARNING.toString().split('.').last);
              }
            },
            textColor: AppColors.landingWhiteButton,
            text: 'Create Site',
          ),
        ],
      ),
    );
  }

  Widget siteActionButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _markers.clear();
              _siteLatLng.clear();
              setState(() {
                i = 0;
              });
              _polygon.clear();
            },
            icon: const Icon(Icons.cancel_rounded),
            label: const Text('Reset Markers'),
            backgroundColor: AppColors.redColor,
          ),
          const SizedBox(
            width: 40,
          ),
          FloatingActionButton.extended(
            onPressed: () {
              markSiteLocation();
            },
            icon: const Icon(Icons.add),
            label: const Text('Mark location'),
            backgroundColor: AppColors.landingOrangeButton,
          ),
        ],
      ),
    );
  }

  void markSiteLocation() {
    if (automated) {
      addSiteMarker();
      automateSiteMarker();
    } else {
      addSiteMarker();
    }
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

  void addSiteMarker() {
    if (position != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('Point $i'),
          infoWindow: InfoWindow(title: 'Point $i : Position lat: ${_position!.latitude},lng: ${_position!.longitude}'),
          position: LatLng(_position!.latitude, _position!.longitude),
        ),
      );
      _siteLatLng.add(LatLng(_position!.latitude, _position!.longitude));
      setState(() {
        i++;
      });
      _polygon.add(
        Polygon(
          polygonId: const PolygonId('SITE_POLYGON'),
          points: _siteLatLng,
          strokeWidth: 2,
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.15),
        ),
      );
    }
  }

  Widget _showLoader() {
    return SizedBox(
      width: _screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(height: 150, width: _screenWidth, decoration: Styles.containerDecoGrey()),
            ],
          ),
        ),
      ),
    );
  }

  void removeMarker(String markerId) {
    final Marker marker = _markers.firstWhere((marker) => marker.markerId.value == markerId);
    setState(() {
      _markers.remove(marker);
    });
  }

  bool validateSiteData(String siteName, List<LatLng> siteLatLng, Set<Polygon> polygon, Set<Marker> markers) {
    return (siteName.isEmpty || siteLatLng.isEmpty || polygon.isEmpty || markers.isEmpty) ? false : true;
  }

  Future<void> createSite() async {
    List<List<double>> coordinates = [];
    List<List<List<double>>> list = [];

    for (int i = 0; i < _siteLatLng.length; i++) {
      List<double> coord = [];
      coord.add(_siteLatLng[i].latitude);
      coord.add(_siteLatLng[i].longitude);
      coordinates.insert(i, coord);
    }
    list.insert(0, coordinates);

    final int siteId = DateTime.now().millisecondsSinceEpoch;

    await store
        .insertSite(
      SitesEntity(siteId, siteName.text, widget.createSiteSectorArgs.organizationId, siteId.toString(), list),
    )
        .whenComplete(() {
      Navigator.pop(context);
      _pandora.reRouteUserPop(context, '/signIn', null);
      _pandora.showToast('Site Added', context, MessageTypes.SUCCESS.toString().split('.').last);
    });
  }

  Future getSiteBounds(String siteId) async {
    final data = await getSiteById(siteId);
    setState(() {
      siteData = data;
      if (siteData != null) {
        _cameraPosition = CameraPosition(
          target: LatLng(siteData!.geoJson[0][0][0], siteData!.geoJson[0][0][1]),
          zoom: 14.4746,
        );
        for (int i = 0; i < siteData!.geoJson[0].length; i++) {
          _siteLatLng.add(LatLng(siteData!.geoJson[0][i][0], siteData!.geoJson[0][i][1]));
        }
        _polygon.add(
          Polygon(
            polygonId: const PolygonId('SITE_POLYGON'),
            points: _siteLatLng,
            strokeWidth: 2,
            strokeColor: Colors.red,
            fillColor: Colors.red.withOpacity(0.15),
          ),
        );
      }
    });
    if (_cameraPosition != null) {
      final GoogleMapController controller = await _controller.future;
      await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));
    }

    return data;
  }

  bool validateSectorData(String sectorName, String sectorDescription, List<LatLng> sectorLatLng) {
    return (sectorName.isEmpty || sectorDescription.isEmpty || sectorLatLng.isEmpty) ? false : true;
  }
}
