import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../pandora/pandora.dart';
import '../../../../utils/assets/svgs_assets.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../widgets/farm_management_manage_menu.dart';
import 'farm_management_dash_site_log_page.dart';

class FarmManagerSiteDashboardPage extends StatefulWidget {
  final FarmManagerSiteManagementArgs siteManagementArgs;

  const FarmManagerSiteDashboardPage({Key? key, required this.siteManagementArgs}) : super(key: key);

  @override
  _FarmManagerSiteDashboardPageState createState() {
    return _FarmManagerSiteDashboardPageState();
  }
}

class _FarmManagerSiteDashboardPageState extends State<FarmManagerSiteDashboardPage> {
  // LatLng coordinates;

  List<Widget> allWidgets = [];
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.farmManagerBackground,
      ),
      body: SafeArea(
        child: Container(
          color: AppColors.farmManagerBackground,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text("${widget.siteManagementArgs.siteName} Dashboard", style: Styles.dashboardText()),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          _pandora.reRouteUser(context, "/farmManagerAllAssetsPage", widget.siteManagementArgs);
                        },
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                        child: Text(
                          "View Assets",
                          style: Styles.regularBlackBold(),
                        ),
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _pandora.reRouteUser(
                            context,
                            '/farmManagerAddLogs',
                            AddLogAssetPageArgs(
                              true,
                              FarmManagementAssetArgs(null, widget.siteManagementArgs),
                              null,
                            ),
                          );
                        },
                        icon: SvgPicture.asset(
                          SvgsAssets.kAddCircle,
                          height: 16,
                          width: 16,
                        ),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          elevation: MaterialStateProperty.all(0.0),
                        ),
                        label: Text(
                          "Add Log",
                          style: Styles.regularWhiteBold(),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          displayModalWithChild(
                            FarmManagementManageMenu(siteArgs: widget.siteManagementArgs),
                            'Manage Site',
                            context,
                          );
                        },
                        icon: SvgPicture.asset(SvgsAssets.kMoreCircle),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 400,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(16),
                    ),
                    child: GoogleMap(
                      mapType: MapType.hybrid,
                      gestureRecognizers: {
                        Factory<OneSequenceGestureRecognizer>(
                          () => EagerGestureRecognizer(),
                        )
                      },
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          widget.siteManagementArgs.coordinates.latitude,
                          widget.siteManagementArgs.coordinates.longitude,
                        ),
                        zoom: 14.4746,
                      ),
                      polygons: widget.siteManagementArgs.polygon,
                      myLocationEnabled: true,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
                Text('Logs', style: GoogleFonts.poppins(textStyle: Styles.regularBlackW800())),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                  child: Flex(
                    direction: Axis.vertical,
                    children: [
                      Expanded(
                        child: FarmManagementSiteLogsListTabs(
                          siteArgs: widget.siteManagementArgs,
                          logType: "ALL",
                          assetType: "ALL",
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
