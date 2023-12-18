import 'dart:async';
import 'dart:collection';

import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smat_crow/network/crow/models/request/create_sector.dart';
import 'package:smat_crow/network/crow/models/request/create_site.dart';
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/network/crow/sector_operations.dart';
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

import '../../../utils/styles.dart';

class CreateSiteSectorPage extends StatefulWidget {
  final CreateSiteSectorArgs createSiteSectorArgs;

  const CreateSiteSectorPage({Key? key, required this.createSiteSectorArgs}) : super(key: key);

  @override
  _CreateSiteSectorPageState createState() => _CreateSiteSectorPageState();
}

class _CreateSiteSectorPageState extends State<CreateSiteSectorPage> with WidgetsBindingObserver {
  final GeoLocatorService geoService = GeoLocatorService();

  final Completer<GoogleMapController> _controller = Completer();
  Position? _position;
  final Set<Marker> _markers = HashSet<Marker>();
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final List<LatLng> _siteLatLng = <LatLng>[];
  final List<LatLng> _sectorLatLng = <LatLng>[];
  late Widget _details;
  late Widget _actions;
  bool automated = false;

  Pandora pandora = Pandora();
  int i = 0;
  TextEditingController siteName = TextEditingController();
  TextEditingController sectorName = TextEditingController();
  TextEditingController sectorDescription = TextEditingController();
  final Pandora _pandora = Pandora();
  GetSiteById? siteData;
  CameraPosition? _cameraPosition;
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  late Timer timer;

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
    super.initState();
    (widget.createSiteSectorArgs.isSite) ? _details = createSiteWidget() : _details = createSectorWidget();

    (widget.createSiteSectorArgs.isSite) ? _actions = siteActionButtons() : _actions = sectorActionButtons();
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
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      _pandora.logAPPButtonClicksEvent('CREATE_SITE_SECTORS_BACK_BUTTON');
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  Container(
                    width: 150,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                      const SizedBox(height: 16),
                      Card(
                        elevation: 12.0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        margin: const EdgeInsets.all(0),
                        child: Column(
                          children: [
                            const SizedBox(height: 36),
                            const CustomDraggingHandle(),
                            const SizedBox(height: 16),
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
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
              _pandora.logAPPButtonClicksEvent('CREATE_SITE_BUTTON');
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
              _pandora.logAPPButtonClicksEvent('RESET_CREATE_SITE_MARKERS');
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
              _pandora.logAPPButtonClicksEvent('PLACE_SITE_MARKER');
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

  markSiteLocation() {
    if (automated) {
      addSiteMarker();
      automateSiteMarker();
    } else {
      addSiteMarker();
    }
  }

  automateSiteMarker() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (automated) {
        addSiteMarker();
      } else {
        timer.cancel();
      }
    });
  }

  addSiteMarker() {
    if (_position != null) {
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

  markSectorLocation() {
    if (automated) {
      addSectorMarker();
      automateSectorMarker();
    } else {
      addSectorMarker();
    }
  }

  automateSectorMarker() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (automated) {
        addSectorMarker();
      } else {
        timer.cancel();
      }
    });
  }

  addSectorMarker() {
    if (_position != null) {
      _markers.add(
        Marker(
          markerId: MarkerId('Point $i'),
          infoWindow: InfoWindow(title: 'Point $i : Position lat: ${_position!.latitude},lng: ${_position!.longitude}'),
          position: LatLng(_position!.latitude, _position!.longitude),
        ),
      );
      _sectorLatLng.add(LatLng(_position!.latitude, _position!.longitude));
      setState(() {
        i++;
      });
      _polygon.add(
        Polygon(
          polygonId: const PolygonId('SECTOR_POLYGON'),
          points: _sectorLatLng,
          strokeWidth: 2,
          strokeColor: Colors.yellow,
          fillColor: Colors.yellow.withOpacity(0.15),
        ),
      );
    }
  }

  Widget sectorActionButtons() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton.extended(
            onPressed: () {
              _pandora.logAPPButtonClicksEvent('RESET_SECTOR_MARKERS');
              _markers.clear();
              _sectorLatLng.clear();
              setState(() {
                i = 0;
              });
              _polygon.clear();
              getSiteBounds(widget.createSiteSectorArgs.siteId);
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
              _pandora.logAPPButtonClicksEvent('PLACE_SECTORS_MARKER');
              markSectorLocation();
            },
            icon: const Icon(
              Icons.add,
              color: AppColors.landingOrangeButton,
            ),
            label: const Text(
              'Mark location',
              style: TextStyle(color: AppColors.landingOrangeButton),
            ),
            backgroundColor: AppColors.whiteSmoke,
          ),
        ],
      ),
    );
  }

  Widget createSectorWidget() {
    getSiteBounds(widget.createSiteSectorArgs.siteId);
    return EnhancedFutureBuilder(
      future: getSiteBounds(widget.createSiteSectorArgs.siteId),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load sector data"),
      ),
      whenNotDone: _showLoader(),
    );
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
              Container(
                height: 150,
                width: _screenWidth,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showResponse() {
    return Container(
      width: _screenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const BottomSheetHeaderText(text: "Create Sector"),
          const SizedBox(height: 31),
          TextInputContainer(
            child: TextField(
              autocorrect: false,
              controller: sectorName,
              keyboardType: TextInputType.name,
              style: Styles.nunitoRegularStyle(),
              decoration: InputDecoration(
                hintText: "Enter Sector Name",
                border: InputBorder.none,
                hintStyle: Styles.nunitoRegularStyle(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextInputContainer(
            child: TextField(
              autocorrect: false,
              controller: sectorDescription,
              maxLines: 2,
              keyboardType: TextInputType.name,
              style: Styles.nunitoRegularStyle(),
              decoration: InputDecoration(
                hintText: "Enter Sector Description",
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
              _pandora.logAPPButtonClicksEvent('CREATE_SECTOR_BUTTON');
              if (validateSectorData(sectorName.text, sectorDescription.text, _sectorLatLng)) {
                if (_sectorLatLng.length < 4) {
                  _pandora.showToast(
                    Errors.sectorPolygonError,
                    context,
                    MessageTypes.WARNING.toString().split('.').last,
                  );
                } else {
                  createSector();
                }
              } else {
                _pandora.showToast(Errors.polygonError, context, MessageTypes.WARNING.toString().split('.').last);
              }
            },
            textColor: AppColors.landingWhiteButton,
            text: 'Create Sector',
          ),
        ],
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

    list.insert(0, coordinates);

    if (_siteLatLng.length < 4) {
      _pandora.showToast(Errors.sectorPolygonError, context, MessageTypes.WARNING.toString().split('.').last);
    } else {
      for (int i = 0; i < _siteLatLng.length; i++) {
        List<double> coord = [];
        coord.add(_siteLatLng[i].latitude);
        coord.add(_siteLatLng[i].longitude);
        coordinates.insert(i, coord);
      }

      final createSite = await createSiteForOrganization(
        CreateSiteRequest(
          name: siteName.text,
          geoJson: list,
          organization: widget.createSiteSectorArgs.organizationId,
          polygonId: "0",
        ),
      );

      if (createSite) {
        Navigator.pop(context);
      } else {
        _pandora.showToast('Failed to create Site', context, MessageTypes.FAILED.toString().split('.').last);
      }
    }
  }

  Future getSiteBounds(String siteId) async {
    final data = await getSiteById(siteId);
    setState(() {
      siteData = data;
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
    });

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition!));

    return data;
  }

  bool validateSectorData(String sectorName, String sectorDescription, List<LatLng> sectorLatLng) {
    return (sectorName.isEmpty || sectorDescription.isEmpty || sectorLatLng.isEmpty) ? false : true;
  }

  Future<void> createSector() async {
    List<List<double>> coordinates = [];
    List<List<List<double>>> list = [];
    for (int i = 0; i < _sectorLatLng.length; i++) {
      List<double> coord = [];
      coord.add(_sectorLatLng[i].latitude);
      coord.add(_sectorLatLng[i].longitude);
      coordinates.insert(i, coord);
    }
    final int length = coordinates.length;
    List<double> endingCoord = [];
    endingCoord.add(_sectorLatLng[0].latitude);
    endingCoord.add(_sectorLatLng[0].longitude);

    coordinates.insert(length, endingCoord);
    list.insert(0, coordinates);

    final createSector = await createSectorForSite(
      CreateSectorRequest(
        name: sectorName.text,
        description: sectorDescription.text,
        sectorCoordinates: list,
        site: widget.createSiteSectorArgs.siteId,
      ),
    );

    if (createSector) {
      Navigator.pop(context);
    } else {
      _pandora.showToast('Failed to create Sector', context, MessageTypes.FAILED.toString().split('.').last);
    }
  }
}
