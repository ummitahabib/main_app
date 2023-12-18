import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import 'farm_management_dash_site_log_page.dart';

class FarmManagementLogsPage extends StatefulWidget {
  final FarmManagementLogDetailsArgs typeArgs;

  const FarmManagementLogsPage({Key? key, required this.typeArgs}) : super(key: key);

  @override
  _FarmManagementLogsPageState createState() {
    return _FarmManagementLogsPageState();
  }
}

class _FarmManagementLogsPageState extends State<FarmManagementLogsPage> {
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
        elevation: 0.0,
        backgroundColor: AppColors.farmManagerBackground,
      ),
      backgroundColor: AppColors.farmManagerBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text(
                "${widget.typeArgs.farmManagerSiteManagementArgs.type![0].toUpperCase()}${widget.typeArgs.farmManagerSiteManagementArgs.type!.substring(1).toLowerCase()} ${widget.typeArgs.type} Logs",
                style: Styles.dashboardText(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _pandora.reRouteUser(
                          context,
                          '/farmManagerAddLogs',
                          AddLogAssetPageArgs(
                            true,
                            FarmManagementAssetArgs(
                              null,
                              widget.typeArgs.farmManagerSiteManagementArgs.farmManagerSiteManagementArgs!,
                            ),
                            null,
                          ),
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text(
                        "Add New ${widget.typeArgs.type} Log",
                        style: Styles.regularBlackBold(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FarmManagementSiteLogsListTabs(
                  siteArgs: widget.typeArgs.farmManagerSiteManagementArgs.farmManagerSiteManagementArgs!,
                  logType: widget.typeArgs.type,
                  assetType: widget.typeArgs.farmManagerSiteManagementArgs.type!,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
