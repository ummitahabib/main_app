import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../utils/strings.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';
import '../../widgets/farm_management_asset_type_item.dart';

class FarmManagementAssetTypeMenu extends StatefulWidget {
  final FarmManagerSiteManagementArgs siteArgs;

  const FarmManagementAssetTypeMenu({Key? key, required this.siteArgs}) : super(key: key);

  @override
  _FarmManagementAssetTypeMenuState createState() {
    return _FarmManagementAssetTypeMenuState();
  }
}

class _FarmManagementAssetTypeMenuState extends State<FarmManagementAssetTypeMenu> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer assetTypesAsync = AsyncMemoizer();
  final Pandora pandora = Pandora();
  List<Widget> farmAssetTypeItem = [];

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
    return EnhancedFutureBuilder(
      future: getFarmManagementAssetTypes(),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(Errors.unableRunAsset),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getFarmManagementAssetTypes() async {
    return assetTypesAsync.runOnce(() async {
      final data = await getAssetTypes();
      List<Widget> assetTypeList = [];
      if (data == null || data.data!.isEmpty) {
        assetTypeList.add(EmptyListItem(message: assetNotCreated));
      } else {
        for (final assetType in data.data!) {
          assetTypeList
              .add(FarmManagementAssetTypeItem(assetType: assetType, siteArgs: widget.siteArgs, pandora: pandora));
        }
      }

      if (mounted) {
        setState(() {
          farmAssetTypeItem = assetTypeList;
        });
      }
    });
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmAssetTypeItem.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmAssetTypeItem[index]);
      },
    );
  }
}
