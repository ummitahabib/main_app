// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:collection';
import 'dart:developer';
import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/crow/models/missions_for_agent_response.dart';
import 'package:smat_crow/network/crow/models/request/create_soil_samples.dart';
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/network/crow/sites_operations.dart';
import 'package:smat_crow/network/crow/star_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/custom_dragging_handle.dart';
import 'package:smat_crow/screens/widgets/old_text_field.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils/strings.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';

import '../../../utils/styles.dart';
import '../fieldagents_providers/create_soil_sample_provider.dart';

class CreateSoilSamplesPage extends StatefulWidget {
  CreateSoilSamplesArgs createSoilSamplesArgs;

  CreateSoilSamplesPage({Key? key, required this.createSoilSamplesArgs}) : super(key: key);

  @override
  _CreateSoilSamplesPageState createState() => _CreateSoilSamplesPageState();
}

class _CreateSoilSamplesPageState extends State<CreateSoilSamplesPage> with WidgetsBindingObserver {
  final GeoLocatorService geoService = GeoLocatorService();

  final Completer<GoogleMapController> _controller = Completer();
  Position? _position;
  final Set<Marker> _markers = HashSet<Marker>();
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final List<LatLng> _siteLatLng = <LatLng>[];
  final List<LatLng> _sampleLatLng = <LatLng>[];
  final Pandora _pandora = Pandora();
  int i = 0;
  TextEditingController sampleDepth = TextEditingController();
  TextEditingController sampleName = TextEditingController();
  GetSiteById? siteData;
  late CameraPosition _cameraPosition;
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;

  final picker = ImagePicker();
  File? sampleImage;

  final List<String> _soilTextureTypes = [
    'Sand',
    'Loamy Sand',
    'Sandy Loam',
    'Sandy Clay Loam',
    'Sandy Sandy Clay',
    'Loam',
    'Clay Loam',
    'Silty Loam',
    'Silt',
    'Silty Clay Loam',
    'Silty Clay',
    'Clay',
  ];
  String? _selectedSoilTexture, _selectedMissionId, _selectedSiteId;

  double _initialChildSize = 0.1;
  final double _maxChildSize = 0.70;
  final double _defaultChildSize = 0.10;

  bool isExpanded = false;
  late BuildContext draggableContext;
  //final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
//  GetMissionsForAgent getMissionsData;

  static final CameraPosition _userLocation = CameraPosition(
    target: LatLng(Session.position!.latitude, Session.position!.longitude),
    zoom: 14.4746,
  );

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    if (kIsWeb) {
      final path = (context.currentBeamLocation.state as BeamState).uri.queryParameters;
      widget.createSoilSamplesArgs = CreateSoilSamplesArgs(
        path['fromMission'] == 'true' ? true : false,
        path["siteId"]!,
        path['missionId']!,
        path["agentId"]!,
      );
    } else {}
    geoService.streamCurrentLocation().listen((position) {
      setState(() {
        Session.position = position;
      });
      centerScreen(position);
    });

    getSiteBounds(widget.createSoilSamplesArgs.siteId);

    // ignore: unnecessary_statements
    Provider.of<CreateSoilSamplesPageProvider>(context, listen: false)
        .getMissionsForAgent(widget.createSoilSamplesArgs.agentId);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _userLocation,
              markers: _markers,
              polygons: _polygon,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
            Positioned(
              left: 10,
              top: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.landingOrangeButton,
                onPressed: () {
                  if (kIsWeb) {
                    context.beamToReplacementNamed(ConfigRoute.mainPage);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: Styles.arrowBack(),
              ),
            ),
            DraggableScrollableActuator(
              child: DraggableScrollableSheet(
                key: Key(_initialChildSize.toString()),
                initialChildSize: _initialChildSize,
                minChildSize: _initialChildSize,
                builder: (BuildContext context, ScrollController scrollController) {
                  draggableContext = context;
                  return SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () {
                                setState(() {
                                  toggleDraggableScrollableSheet();
                                });
                              },
                              icon: isExpanded ? Styles.keyboardArrowDownOutline() : Styles.dAddIconOrange(),
                              label: const Text(
                                'Collect Sample',
                                style: TextStyle(color: AppColors.landingOrangeButton),
                              ),
                              backgroundColor: AppColors.whiteSmoke,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Card(
                          elevation: 12.0,
                          shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                          ),
                          margin: EdgeInsets.zero,
                          child: SizedBox(
                            width: Responsive.xWidth(context),
                            child: Column(
                              children: [
                                const SizedBox(height: 16),
                                const CustomDraggingHandle(),
                                const SizedBox(height: 20),
                                EnhancedFutureBuilder(
                                  future: getSiteBounds(widget.createSoilSamplesArgs.siteId),
                                  rememberFutureResult: true,
                                  whenDone: (obj) => _showResponse(),
                                  whenError: (error) => const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(Errors.unableloadsoil),
                                  ),
                                  whenNotDone: _showLoader(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void toggleDraggableScrollableSheet() {
    setState(() {
      _initialChildSize = isExpanded ? _defaultChildSize : _maxChildSize;
      isExpanded = !isExpanded;
    });
    DraggableScrollableActuator.reset(draggableContext);
  }

  Future<void> centerScreen(Position position) async {
    setState(() {
      _position = position;
    });

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18.0,
        ),
      ),
    );
  }

  Widget createSoilSampleFromDashboardWidget() {
    return EnhancedFutureBuilder(
      future: getSiteBounds(widget.createSoilSamplesArgs.siteId),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load soil samples"),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showLoader() {
    return SizedBox(
      width: _screenWidth,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 150,
                width: _screenWidth,
                decoration: Styles.containerDecoGrey(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 150,
                width: _screenWidth,
                decoration: Styles.containerDecoGrey(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 150,
                width: _screenWidth,
                decoration: Styles.containerDecoGrey(),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 150,
                width: _screenWidth,
                decoration: Styles.containerDecoGrey(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _showResponse() {
    return Consumer<CreateSoilSamplesPageProvider>(
      builder: (context, provider, child) {
        return Container(
          width: _screenWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              const BottomSheetHeaderText(text: "Add Soil Sample"),
              const SizedBox(height: 31),
              if (widget.createSoilSamplesArgs.fromMission)
                Container()
              else
                Column(
                  children: [
                    TextInputContainer(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String?>(
                          hint: const Text('Select Mission'),
                          value: _selectedMissionId,
                          style: Styles.nunitoRegularStyle(),
                          onChanged: (newValue) {
                            log(newValue.toString());
                            setState(() {
                              _selectedMissionId = newValue;
                            });
                            for (int i = 0; i < provider.agentMissions.length; i++) {
                              if (provider.agentMissions[i].id == _selectedMissionId) {
                                setState(() {
                                  _selectedSiteId = provider.agentMissions[i].site;
                                });
                              }
                            }
                            log(_selectedMissionId.toString());
                            log(_selectedSiteId.toString());
                          },
                          items: provider.agentMissions.map((GetMissionsForAgent data) {
                            return DropdownMenuItem(
                              value: data.id,
                              child: Text(data.name ?? ""),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              TextInputContainer(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String?>(
                    hint: const Text('Select Soil Type'),
                    value: _selectedSoilTexture,
                    style: Styles.nunitoRegularStyle(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSoilTexture = newValue;
                      });
                    },
                    items: _soilTextureTypes.map((soil) {
                      return DropdownMenuItem(
                        value: soil,
                        child: Text(soil),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextInputContainer(
                child: TextField(
                  autocorrect: false,
                  controller: sampleName,
                  keyboardType: TextInputType.name,
                  style: Styles.nunitoRegularStyle(),
                  decoration: InputDecoration(
                    hintText: "Enter Sample Name",
                    border: InputBorder.none,
                    hintStyle: Styles.nunitoRegularStyle(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextInputContainer(
                child: TextField(
                  autocorrect: false,
                  controller: sampleDepth,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: AppColors.signupSubHeaderGrey,
                    fontSize: 15.0,
                    fontFamily: 'NunitoSans_Regular',
                  ),
                  decoration: InputDecoration(
                    hintText: "Sample Depth",
                    border: InputBorder.none,
                    hintStyle: Styles.nunitoRegularStyle(),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
/*
              Container(
                height: 200,
                child: InkWell(
                  child: Stack(
                    children: [
                      LoaderTileLarge(),
                      Center(
                        child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add_a_photo,
                              color: AppColors.whiteColor,
                            )),
                      )
                    ],
                  ),
                  onTap: () {
                    Fluttertoast.showToast(
                        msg: 'Please proceed without uploading Image',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER);
                    _pandora.logAPPButtonClicksEvent(
                        'ADD_SOIL_SAMPLE_PHOTO_ITEM_CLICKED');
                  },
                ),
              ),
*/
              const SizedBox(
                height: 15,
              ),
              if (widget.createSoilSamplesArgs.fromMission)
                SquareButton(
                  backgroundColor: AppColors.landingOrangeButton,
                  press: () {
                    _pandora.logAPPButtonClicksEvent('PLACE_SOIL_SAMPLE_MARKER');
                    toggleDraggableScrollableSheet();
                    _position ??= Session.position;
                    _markers.add(
                      Marker(
                        markerId: MarkerId('Sample $i'),
                        infoWindow: InfoWindow(
                          title: 'Point $i : Position lat: ${_position!.latitude},lng: ${_position!.longitude}',
                        ),
                        position: LatLng(_position!.latitude, _position!.longitude),
                      ),
                    );

                    _sampleLatLng.add(LatLng(_position!.latitude, _position!.longitude));
                    setState(() {
                      i++;
                    });

                    if (validateSampleData(
                      sampleName.text,
                      sampleDepth.text,
                      _position!,
                      widget.createSoilSamplesArgs.missionId,
                      widget.createSoilSamplesArgs.siteId,
                      _selectedSoilTexture ?? emptyString,
                    )) {
                      createSample(
                        sampleName.text,
                        sampleDepth.text,
                        _position!,
                        widget.createSoilSamplesArgs.missionId,
                        widget.createSoilSamplesArgs.siteId,
                        _selectedSoilTexture ?? emptyString,
                      );
                    } else {
                      _pandora.showToast(
                        Errors.sampleError,
                        context,
                        MessageTypes.WARNING.toString().split('.').last,
                      );
                    }
                  },
                  textColor: AppColors.landingWhiteButton,
                  text: 'Add Sample',
                )
              else
                SquareButton(
                  backgroundColor: AppColors.landingOrangeButton,
                  press: () {
                    _pandora.logAPPButtonClicksEvent('PLACE_SOIL_SAMPLE_MARKER');
                    toggleDraggableScrollableSheet();
                    log(Session.position.toString());
                    setState(() {
                      _position ??= Session.position;
                    });

                    _markers.add(
                      Marker(
                        markerId: MarkerId('Sample $i'),
                        infoWindow: InfoWindow(
                          title: 'Point $i : Position lat: ${_position!.latitude},lng: ${_position!.longitude}',
                        ),
                        position: LatLng(_position!.latitude, _position!.longitude),
                      ),
                    );

                    _sampleLatLng.add(LatLng(_position!.latitude, _position!.longitude));
                    setState(() {
                      i++;
                    });

                    if (validateSampleData(
                      sampleName.text,
                      sampleDepth.text,
                      _position!,
                      _selectedMissionId ?? emptyString,
                      _selectedSiteId ?? emptyString,
                      _selectedSoilTexture ?? emptyString,
                    )) {
                      createSample(
                        sampleName.text,
                        sampleDepth.text,
                        _position!,
                        _selectedMissionId ?? emptyString,
                        _selectedSiteId ?? emptyString,
                        _selectedSoilTexture ?? emptyString,
                      );
                    } else {
                      _pandora.showToast(
                        Errors.sampleError,
                        context,
                        MessageTypes.WARNING.toString().split('.').last,
                      );
                    }
                  },
                  textColor: AppColors.landingWhiteButton,
                  text: 'Add Sample',
                )
            ],
          ),
        );
      },
    );
  }

  Future getSiteBounds(String siteId) async {
    final data = await getSiteById(siteId);
    if (mounted && data != null) {
      setState(() {
        siteData = data;
        _cameraPosition = CameraPosition(
          target: LatLng(siteData!.geoJson[0][0][0], siteData!.geoJson[0][0][1]),
          zoom: 14.4746,
        );
        for (int i = 0; i < siteData!.geoJson[0].length; i++) {
          _siteLatLng.add(
            LatLng(siteData!.geoJson[0][i][0], siteData!.geoJson[0][i][1]),
          );
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
    }
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));

    return data;
  }

  bool validateSampleData(
    String name,
    String depth,
    Position position,
    String selectedMissionId,
    String selectedSiteId,
    String selectedSoilTexture,
  ) {
    return (name.isEmpty ||
            depth.isEmpty ||
            selectedMissionId.isEmpty ||
            selectedSiteId.isEmpty ||
            selectedSoilTexture.isEmpty)
        ? false
        : true;
  }

  Future<void> createSample(
    String name,
    String depth,
    Position position,
    String selectedMissionId,
    String selectedSiteId,
    String selectedSoilTexture,
  ) async {
    final createSample = await createSoilSample(
      CreateSoilSamples(
        name: name,
        coordinate: Coordinate(lat: position.latitude, lng: position.longitude),
        image: DEFAULT_IMAGE,
        sampleDepth: int.parse(depth),
        soilType: selectedSoilTexture,
        mission: selectedMissionId,
        site: selectedSiteId,
      ),
    );

    if (createSample) {
      //Navigator.pop(context);
      _pandora.showToast(
        'New Sample Added',
        context,
        MessageTypes.SUCCESS.toString().split('.').last,
      );
    } else {
      _pandora.showToast(
        'Failed to add Sample',
        context,
        MessageTypes.FAILED.toString().split('.').last,
      );
    }
  }
}
