import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import 'farm_management_assets_list_page.dart';

class FarmManagementAllAssetsPage extends StatefulWidget {
  final FarmManagerSiteManagementArgs siteArgs;

  const FarmManagementAllAssetsPage({Key? key, required this.siteArgs}) : super(key: key);

  @override
  _FarmManagementAllAssetsPageState createState() {
    return _FarmManagementAllAssetsPageState();
  }
}

class _FarmManagementAllAssetsPageState extends State<FarmManagementAllAssetsPage> {
  List<Widget> farmAssetItem = [];
  // OrganizationAssetsResponse response;
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
              Text("${widget.siteArgs.siteName} Assets", style: Styles.dashboardText()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _pandora.reRouteUser(
                          context,
                          '/farmManagerAddAssets',
                          AddLogAssetPageArgs(true, FarmManagementAssetArgs(null, widget.siteArgs), null),
                        );
                      },
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                      child: Text("Add New Asset", style: Styles.regularBlackBold()),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FarmManagerAssetsListPage(
                    assetArgs: FarmManagementTypeManagementArgs(widget.siteArgs, "ALL"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
