import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/farm_manager_operations.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../../network/crow/models/farm_management/assets/generic_organization_assets.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';
import '../../widgets/farm_assets_item.dart';

class FarmManagerAssetsListPage extends StatefulWidget {
  final FarmManagementTypeManagementArgs assetArgs;

  const FarmManagerAssetsListPage({Key? key, required this.assetArgs}) : super(key: key);

  @override
  _FarmManagerAssetsListPageState createState() {
    return _FarmManagerAssetsListPageState();
  }
}

class _FarmManagerAssetsListPageState extends State<FarmManagerAssetsListPage> {
  List<Widget> farmAssetItem = [];
  // OrganizationAssetsResponse response;
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;

  @override
  void initState() {
    super.initState();
    getOrganizationAssetsByType(widget.assetArgs.farmManagerSiteManagementArgs!.organizationId, widget.assetArgs.type!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: getOrganizationAssetsByType(
        widget.assetArgs.farmManagerSiteManagementArgs!.organizationId,
        widget.assetArgs.type!,
      ),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load asset data"),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
    /* */
  }

  Future getOrganizationAssetsByType(String organizationId, String type) async {
    OrganizationAssetsResponse? data;

    if (type == "ALL") {
      data = await getOrganizationAssets(organizationId);
    } else {
      data = await getOrganizationAssetsAndType(organizationId, widget.assetArgs.type!);
    }

    setFarmLogItems(data!.data);
    return data;
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmAssetItem.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmAssetItem[index]);
      },
    );
  }

  void setFarmLogItems(List<Datum> assetList) {
    List<Widget> assetItemList = [];
    if (assetList.isEmpty) {
      assetItemList.add(const EmptyListItem(message: 'You do not have any Assets'));
    } else {
      for (final asset in assetList) {
        assetItemList.add(
          FarmAssetsItem(
            asset: asset,
            assetArgs: widget.assetArgs,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        farmAssetItem = assetItemList;
      });
    }
  }
}
