import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_latlng_label.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/category_chip.dart';
import 'package:smat_crow/screens/subscription/components/subscription_model.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../fieldagents_providers/field_measurement_page_provider.dart';

class FieldMeasurementPage extends StatefulHookConsumerWidget {
  const FieldMeasurementPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FieldMeasurementPageState();
}

class _FieldMeasurementPageState extends ConsumerState<FieldMeasurementPage> {
  // @override
  // void initState() {

  //   super.initState();
  // }

  @override
  void initState() {
    getCurrentPosition();
    super.initState();
  }

  void getCurrentPosition() {
    // Geolocator.getCurrentPosition().then((pos) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (Session.position != null) {
          ref.watch(fieldProvider).position = Session.position;
          ref.watch(fieldProvider).currentLocationMarker = Marker(
            markerId: MarkerId(currentLocationText.toLowerCase().replaceAll(" ", "_")),
            position: LatLng(ref.watch(fieldProvider).position!.latitude, ref.watch(fieldProvider).position!.longitude),
            infoWindow: const InfoWindow(title: currentLocationText),
          );
        }
      });
    });

    // });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _initMapStyle();
    }
  }

  Future<void> _initMapStyle() async {
    if (ref.watch(fieldProvider).mapController != null) {
      final GoogleMapController controller = ref.watch(fieldProvider).mapController!;
      await controller.setMapStyle("[]");
    }
  }

  final pandora = Pandora();
  @override
  Widget build(BuildContext context) {
    final field = ref.watch(fieldProvider);
    if (Responsive.isDesktop(context)) {
      return Scaffold(
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: HomeWebContainer(
                title: "Field Measurement",
                leadingCallback: () {
                  if (kIsWeb) {
                    context.beamToReplacementNamed(ConfigRoute.mainPage);
                  } else {
                    Navigator.pop(context);
                  }
                },
                trailingIcon: TextButton(
                  onPressed: () {
                    if (field.polygon.isNotEmpty) {
                      field.measurementPoints.add(field.measurementPoints[0]);
                      setState(() {
                        field.area = field.calculatePolygonArea(field.measurementPoints);
                      });
                    }
                  },
                  child: Text(
                    "Done",
                    style: Styles.smatCrowMediumSubParagraph(
                      color: AppColors.SmatCrowPrimary500,
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SiteLatLngLabel(
                            head: starting,
                            lat: field.measurementPoints.isEmpty
                                ? "0.00"
                                : field.measurementPoints[0].latitude.toStringAsFixed(5),
                            lng: field.measurementPoints.isEmpty
                                ? "0.00"
                                : field.measurementPoints[0].longitude.toStringAsFixed(5),
                          ),
                          SiteLatLngLabel(
                            head: ending,
                            lat: field.measurementPoints.isEmpty
                                ? "0.00"
                                : field.measurementPoints.last.latitude.toStringAsFixed(5),
                            lng: field.measurementPoints.isEmpty
                                ? "0.00"
                                : field.measurementPoints.last.longitude.toStringAsPrecision(5),
                          )
                        ],
                      ),
                      const SizedBox(height: SpacingConstants.size20),
                      Container(
                        padding: const EdgeInsets.all(SpacingConstants.size10),
                        decoration: BoxDecoration(
                          color: AppColors.SmatCrowNeuBlue50,
                          borderRadius: BorderRadius.circular(SpacingConstants.size8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              automate,
                              style: Styles.smatCrowMediumCaption(AppColors.SmatCrowNeuBlue900)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: SpacingConstants.size5),
                            const Icon(
                              Icons.error_outline,
                              color: AppColors.SmatCrowPrimary300,
                              size: SpacingConstants.size16,
                            ),
                            const Spacer(),
                            SizedBox(
                              height: SpacingConstants.size17,
                              child: Switch.adaptive(
                                value: field.automated,
                                activeColor: AppColors.SmatCrowGreen300,
                                onChanged: (value) {
                                  field.automated = value;
                                  if (value) {
                                    field.automateSiteMarker();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: SpacingConstants.size20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: resetMarker,
                              onPressed: () {
                                setState(() {
                                  field.markers.clear();
                                  field.measurementPoints.clear();
                                  field.i = 0;
                                  field.polygon.clear();
                                });
                              },
                              leftIcon: Icons.clear,
                              height: SpacingConstants.size44,
                              fontSize: SpacingConstants.font14,
                              iconColor: Colors.white,
                              textColor: Colors.white,
                              color: AppColors.SmatCrowRed500,
                            ),
                          ),
                          const SizedBox(width: SpacingConstants.size10),
                          Expanded(
                            child: CustomButton(
                              text: field.automated ? stopAutomatic : markLocation,
                              onPressed: () {
                                if (field.automated) {
                                  field.automated = false;
                                  field.timer.cancel();
                                } else {
                                  field.markSiteLocation();
                                }
                              },
                              height: SpacingConstants.size44,
                              fontSize: SpacingConstants.font14,
                              leftIcon: field.automated ? Icons.stop : Icons.add,
                              color: AppColors.SmatCrowPrimary500,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.hybrid,
                    initialCameraPosition: field.userLocation,
                    markers: field.markers.isEmpty && field.currentLocationMarker != null
                        ? {field.currentLocationMarker!}
                        : field.markers,
                    polygons: field.polygon,
                    onTap: (argument) {
                      field.position = Position(
                        longitude: argument.longitude,
                        latitude: argument.latitude,
                        timestamp: DateTime.now(),
                        accuracy: 100,
                        altitude: 0,
                        heading: 0,
                        speed: 0,
                        speedAccuracy: 0,
                      );

                      field.markSiteLocation(pos: field.position);
                    },
                    minMaxZoomPreference: const MinMaxZoomPreference(16, 20),
                    myLocationEnabled: true,
                    indoorViewEnabled: true,
                    onMapCreated: (GoogleMapController controller) async {
                      field.mapController = controller;
                      await Future.delayed(const Duration(seconds: 1));
                      if (Session.position != null) {
                        setState(() {
                          field.mapController!.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(Session.position!.latitude, Session.position!.longitude),
                            ),
                          );
                        });
                      }
                    },
                  ),
                  Row(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(SpacingConstants.double20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            HookConsumer(
                              builder: (context, ref, child) {
                                return CategoryChip(
                                  FontAwesomeIcons.cloudArrowDown,
                                  "Export Map",
                                  () {
                                    pandora.logAPPButtonClicksEvent('EXPORT_FIELD_MAP_BUTTON_CLICKED');
                                    if (ref.read(sharedProvider).userInfo == null) return;

                                    if (ref.read(sharedProvider).userInfo!.perks.contains(AppPermissions.site_report)) {
                                      setState(() {
                                        Session.userEmail = ref.read(sharedProvider).userInfo!.user.email;
                                        Session.userName = ref.read(sharedProvider).userInfo!.user.firstName;
                                      });

                                      if (field.polygon.isNotEmpty) {
                                        pandora.generateKMLForPolygon(
                                          'Measured Area',
                                          field.measurementPoints,
                                          "measurement",
                                        );
                                      } else {
                                        pandora.showToast(
                                          'Measured area cannot be empty',
                                          context,
                                          MessageTypes.WARNING.toString().split('.').last,
                                        );
                                      }
                                    } else {
                                      SubscriptionModal.showSubscriptionModal(context);
                                    }
                                  },
                                  Colors.grey.shade50,
                                );
                              },
                            ),
                            const Ymargin(SpacingConstants.double10),
                            if (field.area > 1.0)
                              CategoryChip(
                                Icons.area_chart,
                                "${field.numberFormat.format(double.parse(field.area.toStringAsFixed(3)))} Sqm",
                                () => null,
                                Colors.grey.shade50,
                              )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: field.userLocation,
              markers: field.markers.isEmpty && field.currentLocationMarker != null
                  ? {field.currentLocationMarker!}
                  : field.markers,
              polygons: field.polygon,
              onTap: (argument) {
                if (field.page == 1) {
                  field.position = Position(
                    longitude: argument.longitude,
                    latitude: argument.latitude,
                    timestamp: DateTime.now(),
                    accuracy: 100,
                    altitude: 0,
                    heading: 0,
                    speed: 0,
                    speedAccuracy: 0,
                  );

                  field.markSiteLocation(pos: field.position);
                }
              },
              minMaxZoomPreference: const MinMaxZoomPreference(16, 20),
              myLocationEnabled: true,
              indoorViewEnabled: true,
              onMapCreated: (GoogleMapController controller) async {
                field.mapController = controller;
                await Future.delayed(const Duration(seconds: 1));
                if (Session.position != null) {
                  setState(() {
                    field.mapController!.animateCamera(
                      CameraUpdate.newLatLng(
                        LatLng(Session.position!.latitude, Session.position!.longitude),
                      ),
                    );
                  });
                }
              },
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FloatingActionButton(
                        mini: true,
                        backgroundColor: AppColors.whiteColor,
                        onPressed: () {
                          if (kIsWeb) {
                            context.beamToReplacementNamed(ConfigRoute.mainPage);
                          } else {
                            Navigator.pop(context);
                          }
                          setState(() {
                            field.page = 0;
                            field.markers.clear();
                            field.measurementPoints.clear();
                            field.i = 0;
                            field.polygon.clear();
                          });
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      if (field.page == 1)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            HookConsumer(
                              builder: (context, ref, child) {
                                return CategoryChip(
                                  FontAwesomeIcons.cloudArrowDown,
                                  "Export Map",
                                  () {
                                    pandora.logAPPButtonClicksEvent('EXPORT_FIELD_MAP_BUTTON_CLICKED');
                                    if (ref.read(sharedProvider).userInfo == null) return;

                                    if (ref.read(sharedProvider).userInfo!.perks.contains(AppPermissions.site_report)) {
                                      setState(() {
                                        Session.userEmail = ref.read(sharedProvider).userInfo!.user.email;
                                        Session.userName = ref.read(sharedProvider).userInfo!.user.firstName;
                                      });

                                      if (field.polygon.isNotEmpty) {
                                        pandora.generateKMLForPolygon(
                                          'Measured Area',
                                          field.measurementPoints,
                                          "measurement",
                                        );
                                      } else {
                                        pandora.showToast(
                                          'Measured area cannot be empty',
                                          context,
                                          MessageTypes.WARNING.toString().split('.').last,
                                        );
                                      }
                                    } else {
                                      SubscriptionModal.showSubscriptionModal(context);
                                    }
                                  },
                                  Colors.grey.shade50,
                                );
                              },
                            ),
                            if (field.area > 1.0)
                              CategoryChip(
                                Icons.area_chart,
                                "${field.numberFormat.format(double.parse(field.area.toStringAsFixed(3)))} Sqm",
                                () => null,
                                Colors.grey.shade50,
                              )
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: field.page == 1 ? (0.3) : (0.6),
              builder: (BuildContext context, ScrollController scrollController) {
                return PointerInterceptor(
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                      color: Colors.white,
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          Builder(
                            builder: (context) {
                              if (field.page == 1) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const ModalStick(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          child: const Icon(Icons.arrow_back_ios),
                                          onTap: () {
                                            setState(() {
                                              field.page = 0;
                                              field.markers.clear();
                                              field.measurementPoints.clear();
                                              field.i = 0;
                                              field.polygon.clear();
                                            });
                                          },
                                        ),
                                        const BoldHeaderText(text: "Measure Area", fontSize: 16),
                                        TextButton(
                                          onPressed: () {
                                            if (field.automated) {
                                              field.timer.cancel();
                                              field.automated = false;
                                            }
                                            if (field.polygon.isNotEmpty) {
                                              field.measurementPoints.add(field.measurementPoints[0]);
                                              setState(() {
                                                field.area = field.calculatePolygonArea(field.measurementPoints);
                                              });
                                            }
                                          },
                                          child: Text(
                                            "Done",
                                            style: Styles.smatCrowMediumSubParagraph(
                                              color: AppColors.SmatCrowPrimary500,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SiteLatLngLabel(
                                          head: starting,
                                          lat: field.measurementPoints.isEmpty
                                              ? "0.00"
                                              : field.measurementPoints[0].latitude.toStringAsFixed(5),
                                          lng: field.measurementPoints.isEmpty
                                              ? "0.00"
                                              : field.measurementPoints[0].longitude.toStringAsFixed(5),
                                        ),
                                        SiteLatLngLabel(
                                          head: ending,
                                          lat: field.measurementPoints.isEmpty
                                              ? "0.00"
                                              : field.measurementPoints.last.latitude.toStringAsFixed(5),
                                          lng: field.measurementPoints.isEmpty
                                              ? "0.00"
                                              : field.measurementPoints.last.longitude.toStringAsPrecision(5),
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: SpacingConstants.size20),
                                    Container(
                                      padding: const EdgeInsets.all(SpacingConstants.size10),
                                      decoration: BoxDecoration(
                                        color: AppColors.SmatCrowNeuBlue50,
                                        borderRadius: BorderRadius.circular(SpacingConstants.size8),
                                      ),
                                      child: Row(
                                        children: [
                                          Text(
                                            automate,
                                            style: Styles.smatCrowMediumCaption(AppColors.SmatCrowNeuBlue900)
                                                .copyWith(fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(width: SpacingConstants.size5),
                                          const Icon(
                                            Icons.error_outline,
                                            color: AppColors.SmatCrowPrimary300,
                                            size: SpacingConstants.size16,
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            height: SpacingConstants.size17,
                                            child: Switch.adaptive(
                                              value: field.automated,
                                              activeColor: AppColors.SmatCrowGreen300,
                                              onChanged: (value) {
                                                field.automated = value;

                                                if (value) {
                                                  field.automateSiteMarker();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: SpacingConstants.size20),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            text: resetMarker,
                                            onPressed: () {
                                              setState(() {
                                                field.markers.clear();
                                                field.measurementPoints.clear();
                                                field.i = 0;
                                                field.polygon.clear();
                                              });
                                            },
                                            leftIcon: Icons.clear,
                                            height: SpacingConstants.size44,
                                            fontSize: SpacingConstants.font14,
                                            iconColor: Colors.white,
                                            textColor: Colors.white,
                                            color: AppColors.SmatCrowRed500,
                                          ),
                                        ),
                                        const SizedBox(width: SpacingConstants.size10),
                                        Expanded(
                                          child: CustomButton(
                                            text: field.automated ? stopAutomatic : markLocation,
                                            onPressed: () {
                                              if (field.automated) {
                                                field.automated = false;
                                                field.timer.cancel();
                                              } else {
                                                field.markSiteLocation();
                                              }
                                              setState(() {});
                                            },
                                            height: SpacingConstants.size44,
                                            fontSize: SpacingConstants.font14,
                                            leftIcon: field.automated ? Icons.stop : Icons.add,
                                            color: AppColors.SmatCrowPrimary500,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ModalStick(),
                                  const Ymargin(20),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(1000),
                                      color: AppColors.SmatCrowPrimary300.withOpacity(0.5),
                                    ),
                                    alignment: Alignment.center,
                                    child: Image.asset('assets2/images/0022.png'),
                                  ),
                                  const Ymargin(20),
                                  const BoldHeaderText(text: "Field Measure", fontSize: 21),
                                  const Ymargin(20),
                                  const BoldHeaderText(text: "How to measure your field", fontSize: 16),
                                  const Ymargin(20),
                                  RichText(
                                    text: TextSpan(
                                      text: "Step 1",
                                      style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                                      children: [
                                        TextSpan(
                                          text: " - Toggle automate",
                                          style: Styles.smatCrowSubParagraphRegular(
                                            color: AppColors.SmatCrowNeuBlue600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Ymargin(10),
                                  RichText(
                                    text: TextSpan(
                                      text: "Step 2",
                                      style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                                      children: [
                                        TextSpan(
                                          text: " - Mark beginning location",
                                          style: Styles.smatCrowSubParagraphRegular(
                                            color: AppColors.SmatCrowNeuBlue600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Ymargin(10),
                                  RichText(
                                    text: TextSpan(
                                      text: "Step 3",
                                      style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                                      children: [
                                        TextSpan(
                                          text: " - Walk around perimeter of area to be measured",
                                          style: Styles.smatCrowSubParagraphRegular(
                                            color: AppColors.SmatCrowNeuBlue600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Ymargin(10),
                                  RichText(
                                    text: TextSpan(
                                      text: "Step 4",
                                      style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                                      children: [
                                        TextSpan(
                                          text: " - Once area to be measured has been covered, click on measure area",
                                          style: Styles.smatCrowSubParagraphRegular(
                                            color: AppColors.SmatCrowNeuBlue600,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const Ymargin(40),
                                  CustomButton(
                                    text: "Continue",
                                    onPressed: () {
                                      getCurrentPosition();
                                      setState(() {
                                        field.page = 1;
                                      });
                                    },
                                  ),
                                  const Ymargin(20)
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
