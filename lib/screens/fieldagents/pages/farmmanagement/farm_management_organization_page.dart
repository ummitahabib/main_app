import 'dart:async';
import 'dart:collection';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inapp_browser/inapp_browser.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';

import '../../../../network/crow/batch_operations.dart';
import '../../../../network/crow/mapper_operations.dart';
import '../../../../network/crow/models/batch_by_id.dart';
import '../../../../network/crow/models/organization_by_id_response.dart';
import '../../../../network/crow/models/sector_by_id_response.dart';
import '../../../../network/crow/models/site_by_id_response.dart';
import '../../../../network/crow/models/star_mission_by_id_response.dart';
import '../../../../network/crow/organization_operations.dart';
import '../../../../network/crow/sector_operations.dart';
import '../../../../network/crow/sites_operations.dart';
import '../../../../network/crow/star_operations.dart';
import '../../../../pandora/pandora.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../../farmmanager/pages/farm_analysis_page.dart';
import '../../../farmmanager/pages/farm_manager_page.dart';
import '../../../farmmanager/pages/satellite_imagery_page.dart';
import '../../../farmmanager/pages/soil_info_page.dart';
import '../../../farmmanager/pages/soil_test_page.dart';
import '../../../farmmanager/pages/weather_info_page.dart';
import '../../../farmmanager/widgets/category_chip.dart';
import '../../../farmmanager/widgets/test_samples_list.dart';
import '../../../farmtools/widgets/field_measurement_menu.dart';
import '../../../widgets/header_text.dart';
import 'farm_management_organization_body.dart';

class FarmManagementOrganizationsDetails extends StatefulWidget {
  final FieldAgentOrganizationArgs fieldAgentOrganizationArgs;

  const FarmManagementOrganizationsDetails({Key? key, required this.fieldAgentOrganizationArgs}) : super(key: key);

  @override
  _FarmManagementOrganizationsDetailsState createState() {
    return _FarmManagementOrganizationsDetailsState();
  }
}

class _FarmManagementOrganizationsDetailsState extends State<FarmManagementOrganizationsDetails>
    with WidgetsBindingObserver {
  final Completer<GoogleMapController> _controller = Completer();
  String? organizationId, siteId, sectorId, batchId, missionId;
  bool orgTapped = false, siteTapped = false, sectorTapped = false, batchTapped = false, missionTapped = false;
  GetOrganizationById? organizationData;
  GetSiteById? siteData;
  GetSectorById? sectorData;
  GetBatchById? batchData;
  GetMissionById? missionData;
  late CameraPosition _cameraPosition;
  late Position position;
  final Set<Marker> _markers = HashSet<Marker>();
  final Set<Polygon> _polygon = HashSet<Polygon>();
  final List<LatLng> _siteLatLng = <LatLng>[];
  final List<LatLng> _sectorLatLng = <LatLng>[];
  Widget _chipHeader = Container();
  Widget _details = Container();
  List<Widget> _siteChildren = [];
  Pandora pandora = Pandora();
  double siteArea = 0.00000;
  static double lat = 6.465422;
  static double lng = 3.406448;
  bool inAppFieldMeasurements = false;
  bool isFarmManagerAgent = false;

  NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');

  static final CameraPosition _userLocation = CameraPosition(
    target: LatLng(
      (Session.position == null) ? lat : Session.position!.latitude,
      (Session.position == null) ? lng : Session.position!.longitude,
    ),
    zoom: 14.4746,
  );

  void _getAllIds(String oId, String sId, String seId, String bId, bool oTap, bool sTap, bool seTap, bool bTap) {
    setState(() {
      organizationId = oId;
      siteId = sId;
      sectorId = seId;
      batchId = bId;
      orgTapped = oTap;
      siteTapped = sTap;
      sectorTapped = seTap;
      batchTapped = bTap;
      debugPrint(
        'All IDS\n Organization Id $organizationId \n Site Id $siteId \n Sector Id $sectorId  \n Batch Id $batchId \n Org Tapped $orgTapped \n Site Tapped $siteTapped \n Sector Tapped $sectorTapped \n BatchTapped $batchTapped',
      );

      if (siteTapped == true) {
        getSiteBounds(siteId!);
      }

      if (sectorTapped == true) {
        getSectorBounds(sectorId!);
      }

      if (batchTapped == true) {
        getBatchDetails(batchId!);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _details = farmManagementWidget();
  }

  Widget farmManagementWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: FarmManagementOrganizationBody(
        getAllIds: _getAllIds,
        fieldAgentOrganizationArgs: widget.fieldAgentOrganizationArgs,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
          Column(
            children: [
              const CustomSearchContainer(),
              _chipHeader,
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.30,
            minChildSize: 0.15,
            builder: (BuildContext context, ScrollController scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        Visibility(
                          visible: inAppFieldMeasurements,
                          child: Container(
                            margin: const EdgeInsets.only(right: 12, bottom: 12),
                            child: FloatingActionButton(
                              onPressed: () {
                                siteMeasurementsWidget();
                              },
                              backgroundColor: AppColors.whiteColor,
                              mini: true,
                              tooltip: "${numberFormat.format(double.parse(siteArea.toStringAsFixed(3)))} Sqm",
                              child: const Icon(
                                EvaIcons.pantone,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          child: FloatingActionButton(
                            onPressed: () {
                              pandora.logAPPButtonClicksEvent('FARM_MANAGER_PAGE_BACK_BUTTON');
                              Navigator.pop(context);
                            },
                            backgroundColor: AppColors.landingOrangeButton,
                            mini: true,
                            elevation: 12,
                            child: const Icon(
                              Icons.keyboard_backspace_rounded,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: isFarmManagerAgent,
                          child: Container(
                            margin: const EdgeInsets.only(right: 12),
                            child: FloatingActionButton.extended(
                              onPressed: () {
                                pandora.logAPPButtonClicksEvent('FIELD_AGENT_MANAGE_FARM_CLICKED');

                                pandora.reRouteUser(
                                  context,
                                  '/farmManagerSiteDetails',
                                  FarmManagerSiteManagementArgs(
                                    LatLng(_siteLatLng.first.latitude, _siteLatLng.first.longitude),
                                    siteData!.name,
                                    _polygon,
                                    organizationId ?? "",
                                    siteId ?? "",
                                  ),
                                );
                              },
                              icon: const Icon(Icons.manage_accounts_sharp),
                              label: const Text('Manage Site'),
                              backgroundColor: AppColors.landingOrangeButton,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 12.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      margin: const EdgeInsets.all(0),
                      child: _details,
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<dynamic> siteMeasurementsWidget() {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const HeaderText(
                      text: 'Alternative Measurement',
                      color: Colors.black,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Styles.closeIconGrey(),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Divider(
                    height: 1.0,
                  ),
                ),
                FarmMeasurementsMenu(size: siteArea.toStringAsPrecision(3)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget weatherInformationWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryChip(
                Icons.close,
                "Weather Info",
                () {
                  setState(() {
                    pandora.logAPPButtonClicksEvent('CLOSE_WEATHER_INFO_BUTTON_CLICKED');
                    _details = farmManagementWidget();
                  });
                },
                Colors.redAccent[50]!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          WeatherInfoPage(siteId: siteId ?? "")
        ],
      ),
    );
  }

  Widget soilInformationWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryChip(
                Icons.close,
                "Soil Info",
                () {
                  setState(() {
                    pandora.logAPPButtonClicksEvent('CLOSE_SOIL_INFO_BUTTON_CLICKED');
                    _details = farmManagementWidget();
                  });
                },
                Colors.redAccent[50]!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SoilInfoPage(siteId: siteId ?? "")
        ],
      ),
    );
  }

  Widget soilTestWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryChip(
                Icons.close,
                "Soil Test",
                () {
                  pandora.logAPPButtonClicksEvent('CLOSE_SOIL_TEST_BUTTON_CLICKED');
                  setState(() {
                    _details = farmManagementWidget();
                  });
                },
                Colors.redAccent[50]!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SoilTestPage(
            siteId: siteId ?? "",
            organizationId: organizationId ?? "",
            siteName: siteData!.name,
            getSelectedId: _updateMissionId,
          )
        ],
      ),
    );
  }

  void _updateMissionId(String id, bool isTapped) {
    setState(() {
      missionId = id;
      missionTapped = isTapped;

      if (missionTapped == true) {
        getMissionDetails(missionId ?? "");
      }
    });
  }

  Widget samplesListWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryChip(
                Icons.close,
                "Soil Test Results",
                () {
                  pandora.logAPPButtonClicksEvent('CLOSE_SMAT_STAR_BUTTON_CLICKED');
                  setState(() {
                    _details = farmManagementWidget();
                  });
                },
                Colors.redAccent[50]!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          TestSamplesList(missionId: missionId ?? "", missionData: missionData!)
        ],
      ),
    );
  }

  Widget farmAnalysisWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryChip(
                Icons.close,
                "Batch Analysis",
                () {
                  pandora.logAPPButtonClicksEvent('CLOSE_BATCH_ANALYSIS_BUTTON_CLICKED');
                  setState(() {
                    _details = farmManagementWidget();
                  });
                },
                Colors.redAccent[50]!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          FarmAnalysisPage(batchId: batchId ?? "")
        ],
      ),
    );
  }

  Widget satelliteImageryWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CategoryChip(
                Icons.close,
                "Satellite Imagery",
                () {
                  pandora.logAPPButtonClicksEvent('CLOSE_SOIL_INFO_BUTTON_CLICKED');
                  setState(() {
                    _details = farmManagementWidget();
                  });
                },
                Colors.redAccent[50]!,
              ),
            ],
          ),
          const SizedBox(height: 10),
          SatelliteImageryPage(siteId: siteId ?? "")
        ],
      ),
    );
  }

  Future getOrganizationDetails(String organizationId) async {
    final data = await getUserOrganizationsById(organizationId);
    setState(() {
      organizationData = data;
      _chipHeader = Container();
    });
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  Future getSiteBounds(String siteId) async {
    removeMarker('ORGANIZATION_MARKER');
    final data = await getSiteById(siteId);
    setState(() {
      siteData = data;
      _siteChildren = [];

      _cameraPosition = CameraPosition(
        target: LatLng(siteData!.geoJson[0][0][0], siteData!.geoJson[0][0][1]),
        zoom: 14.4746,
      );
      for (int i = 0; i < siteData!.geoJson[0].length; i++) {
        _siteLatLng.add(LatLng(siteData!.geoJson[0][i][0], siteData!.geoJson[0][i][1]));
      }
      siteArea = calculatePolygonArea(siteData!);

      _polygon.add(
        Polygon(
          polygonId: const PolygonId('SITE_POLYGON'),
          points: _siteLatLng,
          strokeWidth: 2,
          strokeColor: Colors.red,
          fillColor: Colors.red.withOpacity(0.15),
        ),
      );

      //PERMISSIONS SECTION
      if (userData != null) {
        for (final element in userData!.role!.subscription!.permissions!) {
          if (element.name == AppPermissions.smat_sat) {
            _siteChildren.add(
              const SizedBox(width: 16),
            );
            _siteChildren.add(
              CategoryChip(
                FontAwesomeIcons.cloudSunRain,
                "Weather Info",
                () {
                  pandora.logAPPButtonClicksEvent('WEATHER_INFO_BUTTON_CLICKED');
                  setState(() {
                    _details = weatherInformationWidget();
                  });
                },
                Colors.grey[50]!,
              ),
            );
            _siteChildren.add(const SizedBox(width: 12));
            _siteChildren.add(
              CategoryChip(
                FontAwesomeIcons.temperatureLow,
                "Soil Info",
                () {
                  pandora.logAPPButtonClicksEvent('SOIL_INFO_BUTTON_CLICKED');
                  setState(() {
                    _details = soilInformationWidget();
                  });
                },
                Colors.grey[50]!,
              ),
            );
            _siteChildren.add(const SizedBox(width: 12));
            _siteChildren.add(const SizedBox(width: 12));
            _siteChildren.add(
              CategoryChip(
                FontAwesomeIcons.satellite,
                "Satellite Imagery",
                () {
                  pandora.logAPPButtonClicksEvent('SATELLITE_IMAGERY_BUTTON_CLICKED');
                  setState(() {
                    //_details = satelliteImageryWidget();
                    OneContext().showSnackBar(
                      builder: (_) => const SnackBar(content: Text('Only Available on special request')),
                    );
                  });
                },
                Colors.grey[50]!,
              ),
            );
          }
          if (element.name == AppPermissions.site_report) {
            _siteChildren.add(
              const SizedBox(width: 12),
            );
            _siteChildren.add(
              CategoryChip(
                FontAwesomeIcons.fileContract,
                "Generate Site Report",
                () {
                  pandora.logAPPButtonClicksEvent('GENERATE_SITE_REPORT_CLICKED');
                  generateSiteReport(data!);
                },
                Colors.grey[50]!,
              ),
            );
            _siteChildren.add(
              const SizedBox(width: 12),
            );
            _siteChildren.add(
              CategoryChip(
                FontAwesomeIcons.cloudDownloadAlt,
                "Export Map",
                () {
                  pandora.logAPPButtonClicksEvent('EXPORT_FIELD_MAP_BUTTON_CLICKED');

                  if (_polygon.isNotEmpty) {
                    pandora.generateKMLForPolygon('Measured Area', _siteLatLng, "site");
                  } else {
                    pandora.showToast(
                      'Measured area cannot be empty',
                      context,
                      MessageTypes.WARNING.toString().split('.').last,
                    );
                  }
                },
                Colors.grey[50]!,
              ),
            );
          }
          if (element.name == AppPermissions.field_pro_in_app) {
            if (mounted) {
              setState(() {
                inAppFieldMeasurements = true;
              });
            }
          }
          if (element.name == AppPermissions.farm_manager_agent || element.name == AppPermissions.field_pro_in_app) {
            if (mounted) {
              setState(() {
                isFarmManagerAgent = true;
              });
            }
          }
          if (element.name == AppPermissions.smat_star) {
            _siteChildren.add(
              CategoryChip(
                FontAwesomeIcons.vial,
                "Soil Test",
                () {
                  pandora.logAPPButtonClicksEvent('SOIL_TEST_BUTTON_CLICKED');
                  setState(() {
                    _details = soilTestWidget();
                  });
                },
                Colors.grey[50]!,
              ),
            );
          }
        }
      }

      _chipHeader = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(children: _siteChildren),
      );
    });

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  Future getSectorBounds(String sectorId) async {
    final data = await getSectorById(sectorId);
    setState(() {
      sectorData = data;

      _cameraPosition = CameraPosition(
        target: LatLng(sectorData!.sectorCoordinates[0][0][0], sectorData!.sectorCoordinates[0][0][1]),
        zoom: 16.4746,
      );

      for (int i = 0; i < sectorData!.sectorCoordinates[0].length; i++) {
        _sectorLatLng.add(LatLng(sectorData!.sectorCoordinates[0][i][0], sectorData!.sectorCoordinates[0][i][1]));
      }

      _polygon.add(
        Polygon(
          polygonId: const PolygonId('SECTOR_POLYGON'),
          points: _sectorLatLng,
          strokeWidth: 2,
          strokeColor: Colors.green,
          fillColor: Colors.green.withOpacity(0.15),
        ),
      );

      _chipHeader = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(width: 16),
            CategoryChip(
              FontAwesomeIcons.cloudDownloadAlt,
              "Export Map",
              () {
                pandora.logAPPButtonClicksEvent('EXPORT_MAP_BUTTON_CLICKED');
                pandora.generateKML(sectorData!.name, sectorData!.sectorCoordinates, "sector");
              },
              Colors.grey[50]!,
            ),
          ],
        ),
      );
    });
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  Future getBatchDetails(String batchId) async {
    final data = await getBatchById(batchId);
    setState(() {
      batchData = data;
      if (userData != null) {
        for (final element in userData!.role!.subscription!.permissions!) {
          if (element.name == AppPermissions.smat_mapper) {
            _chipHeader = SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 16),
                  if (batchData!.taskStatus == OrthoPhotoStatus.NONE ||
                      batchData!.taskStatus == OrthoPhotoStatus.FAILED ||
                      batchData!.taskStatus == OrthoPhotoStatus.CANCELED)
                    CategoryChip(
                      FontAwesomeIcons.tools,
                      "Begin Processing",
                      () {
                        pandora.logAPPButtonClicksEvent('BEGIN_PROCESSING_BUTTON_CLICKED');
                        batchData!.images!.length <= 5
                            ? OneContext().showSnackBar(
                                builder: (_) => const SnackBar(
                                  content: Text('You cannot process less than 5 images'),
                                  backgroundColor: Colors.red,
                                ),
                              )
                            : processImagesInBatch(batchData!.id!);
                      },
                      Colors.grey[50]!,
                    )
                  else
                    Container(),
                  const SizedBox(width: 12),
                  if (batchData!.taskStatus != OrthoPhotoStatus.COMPLETED)
                    Container()
                  else
                    CategoryChip(
                      FontAwesomeIcons.layerGroup,
                      "View Orthomosaic",
                      () {
                        pandora.logAPPButtonClicksEvent('VIEW_ORTHOMOSAIC_BUTTON_CLICKED');
                        InappBrowser.showPopUpBrowser(
                          context,
                          Uri.parse(batchData!.orthophotoUrl!),
                        );
                      },
                      Colors.grey[50]!,
                    ),
                  const SizedBox(width: 12),
                  if (batchData!.taskStatus != OrthoPhotoStatus.COMPLETED)
                    Container()
                  else
                    CategoryChip(
                      FontAwesomeIcons.brain,
                      "Perform AI Analysis",
                      () {
                        /*setState(() {
                      _details = farmAnalysisWidget();
                    });*/
                        Fluttertoast.showToast(
                          msg: 'Please Perform this action on Web Portal',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                      },
                      Colors.grey[50]!,
                    ),
                  const SizedBox(width: 12),
                  if (batchData!.taskStatus != OrthoPhotoStatus.RUNNING ||
                      batchData!.taskStatus != OrthoPhotoStatus.QUEUED)
                    Container()
                  else
                    CategoryChip(Icons.settings, "Please Wait, Processing ...", () {}, AppColors.landingOrangeButton),
                ],
              ),
            );
          }
        }
      }
    });
  }

  Future getMissionDetails(String missionId) async {
    final data = await getMissionById(missionId);
    setState(() {
      missionData = data;
      _cameraPosition = CameraPosition(
        target: LatLng(siteData!.geoJson[0][0][0], siteData!.geoJson[0][0][1]),
        zoom: 14.4746,
      );
      for (int i = 0; i < siteData!.geoJson[0].length; i++) {
        _siteLatLng.add(LatLng(siteData!.geoJson[0][i][0], siteData!.geoJson[0][i][1]));
      }

      if (missionData!.samples!.isNotEmpty) {
        for (int i = 0; i < missionData!.samples!.length; i++) {
          _markers.add(
            Marker(
              markerId: MarkerId('SAMPLES_MARKERS_$i'),
              position: LatLng(
                double.parse(missionData!.samples![i].coordinates!.lat),
                double.parse(missionData!.samples![i].coordinates!.lng),
              ),
              infoWindow: InfoWindow(
                title: missionData!.samples![i].name,
                snippet: '${missionData!.samples![i].coordinates!.lat} , ${missionData!.samples![i].coordinates!.lng}',
              ),
            ),
          );
          _details = samplesListWidget();
        }
      } else {
        OneContext().showSnackBar(
          builder: (_) => const SnackBar(
            content: Text('This Mission is still in Progress'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });

    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_cameraPosition));
  }

  void removeMarker(String markerId) {
    final Marker marker = _markers.firstWhere((marker) => marker.markerId.value == markerId);
    setState(() {
      _markers.remove(marker);
    });
  }

  static double calculatePolygonArea(GetSiteById data) {
    final area = GeoJSONPolygon.fromMap(data.toJson()).area;

    return area;
  }

  Future<void> generateSiteReport(GetSiteById data) async {
    final generateReport = await generateReportForSite(data.id, organizationId ?? "");
    if (generateReport) {
    } else {}
  }
}
