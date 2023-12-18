import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import 'farm_management_assets_list_page.dart';

class FarmManagementAssetsPage extends StatefulWidget {
  final FarmManagementTypeManagementArgs typeArgs;

  const FarmManagementAssetsPage({Key? key, required this.typeArgs}) : super(key: key);

  @override
  _FarmManagementAssetsPageState createState() {
    return _FarmManagementAssetsPageState();
  }
}

class _FarmManagementAssetsPageState extends State<FarmManagementAssetsPage> {
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
              Text("${widget.typeArgs.type} Assets", style: Styles.dashboardText()),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        _pandora.reRouteUser(
                          context,
                          '/farmManagerAddAssets',
                          AddLogAssetPageArgs(
                            true,
                            FarmManagementAssetArgs(null, widget.typeArgs.farmManagerSiteManagementArgs!),
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
                        "Add New ${widget.typeArgs.type} Asset",
                        style: Styles.regularBlackBold(),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: FarmManagerAssetsListPage(assetArgs: widget.typeArgs))
            ],
          ),
        ),
      ),
    );
  }
}
