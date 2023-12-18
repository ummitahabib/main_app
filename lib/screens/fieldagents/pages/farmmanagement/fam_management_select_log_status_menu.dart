import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../utils/assets/images.dart';
import '../../../../utils/colors.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';

class FarmManagementSelectLogStatusMenu extends StatefulWidget {
  final Function(String) selectedLogStatus;

  const FarmManagementSelectLogStatusMenu({Key? key, required this.selectedLogStatus}) : super(key: key);

  @override
  _FarmManagementSelectLogStatusMenuState createState() {
    return _FarmManagementSelectLogStatusMenuState();
  }
}

class _FarmManagementSelectLogStatusMenuState extends State<FarmManagementSelectLogStatusMenu> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer assetStatusAsync = AsyncMemoizer();
  final Pandora pandora = Pandora();
  List<Widget> farmLogStatusItem = [];

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
      future: getFarmManagementLogStatus(),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to Fetch Log Status"),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getFarmManagementLogStatus() async {
    return assetStatusAsync.runOnce(() async {
      final data = await getLogStatus();
      List<Widget> logStatusList = [];
      if (data == null || data.data!.isEmpty) {
        logStatusList.add(const EmptyListItem(message: 'No Log Status Created'));
      } else {
        for (final assetStatus in data.data!) {
          logStatusList.add(
            InkWell(
              onTap: () {
                widget.selectedLogStatus(assetStatus.status!);
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
                    Text(
                      assetStatus.status!,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(color: AppColors.dashGridTextColor, fontSize: 15.0, fontFamily: 'regular'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          farmLogStatusItem = logStatusList;
        });
      }
    });
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmLogStatusItem.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmLogStatusItem[index]);
      },
    );
  }
}
