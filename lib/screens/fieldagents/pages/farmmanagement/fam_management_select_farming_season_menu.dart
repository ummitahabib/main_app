import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';

class FarmManagementSelectFarmingSeasonMenu extends StatefulWidget {
  final Function(String) selectedFarmingSeason;

  const FarmManagementSelectFarmingSeasonMenu({Key? key, required this.selectedFarmingSeason}) : super(key: key);

  @override
  _FarmManagementSelectFarmingSeasonMenuState createState() {
    return _FarmManagementSelectFarmingSeasonMenuState();
  }
}

class _FarmManagementSelectFarmingSeasonMenuState extends State<FarmManagementSelectFarmingSeasonMenu> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer farmingSeasonsAsync = AsyncMemoizer();
  final Pandora pandora = Pandora();
  List<Widget> farmFarmingSeasonItem = [];

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
        child: Text("Unable to Fetch Farming Seasons"),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getFarmManagementLogStatus() async {
    return farmingSeasonsAsync.runOnce(() async {
      final data = await getPlantingSeasons();

      List<Widget> assetStatusList = [];
      if (data == null || data.data!.isEmpty) {
        assetStatusList.add(const EmptyListItem(message: 'No Farming Seasons Added'));
      } else {
        for (final farmingSeason in data.data!) {
          assetStatusList.add(
            InkWell(
              onTap: () {
                widget.selectedFarmingSeason(farmingSeason.season!);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    Styles.sunOutline(),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(farmingSeason.season!, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
                  ],
                ),
              ),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          farmFarmingSeasonItem = assetStatusList;
        });
      }
    });
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmFarmingSeasonItem.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmFarmingSeasonItem[index]);
      },
    );
  }
}
