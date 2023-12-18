import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../utils/assets/images.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';

class FarmManagementSelectAssetTypeMenu extends StatefulWidget {
  final Function(String) selectedAssetType;

  const FarmManagementSelectAssetTypeMenu({Key? key, required this.selectedAssetType}) : super(key: key);

  @override
  _FarmManagementSelectAssetTypeMenuState createState() {
    return _FarmManagementSelectAssetTypeMenuState();
  }
}

class _FarmManagementSelectAssetTypeMenuState extends State<FarmManagementSelectAssetTypeMenu> {
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
      future: getFarmManagementLogTypes(),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text(Errors.unableRunAsset),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getFarmManagementLogTypes() async {
    return assetTypesAsync.runOnce(() async {
      final data = await getAssetTypes();

      List<Widget> assetTypeList = [];
      if (data == null || data.data!.isEmpty) {
        assetTypeList.add(EmptyListItem(message: assetNotCreated));
      } else {
        for (final assetType in data.data!) {
          assetTypeList.add(
            InkWell(
              onTap: () {
                widget.selectedAssetType(assetType.types!);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    Image.asset(ImagesAssets.kTree, width: 25.0, height: 25.0, fit: BoxFit.contain),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(assetType.types!, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
                  ],
                ),
              ),
            ),
          );
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
