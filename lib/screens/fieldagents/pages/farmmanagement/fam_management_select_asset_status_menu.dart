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

class FarmManagementSelectAssetStatusMenu extends StatefulWidget {
  final Function(String) selectedAssetStatus;

  const FarmManagementSelectAssetStatusMenu({Key? key, required this.selectedAssetStatus}) : super(key: key);

  @override
  _FarmManagementSelectAssetStatusMenuState createState() {
    return _FarmManagementSelectAssetStatusMenuState();
  }
}

class _FarmManagementSelectAssetStatusMenuState extends State<FarmManagementSelectAssetStatusMenu> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer assetStatusAsync = AsyncMemoizer();
  final Pandora pandora = Pandora();
  List<Widget> farmAssetStatusItem = [];

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
      future: getFarmManagementAssetStatus(),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(unableFetchAssetStatus),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getFarmManagementAssetStatus() async {
    return assetStatusAsync.runOnce(() async {
      final data = await getAssetStatus();
      List<Widget> assetStatusList = [];
      if (data == null || data.data!.isEmpty) {
        assetStatusList.add(EmptyListItem(message: assetStatusNotCreated));
      } else {
        for (final assetStatus in data.data!) {
          assetStatusList.add(
            InkWell(
              onTap: () {
                widget.selectedAssetStatus(assetStatus.status!);
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
                    Text(assetStatus.status!, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
                  ],
                ),
              ),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          farmAssetStatusItem = assetStatusList;
        });
      }
    });
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmAssetStatusItem.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmAssetStatusItem[index]);
      },
    );
  }
}
