import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:quiver/iterables.dart';

import '../../../network/crow/farm_manager_operations.dart';
import '../widgets/field_agent_statistics_grid_item.dart';

class FieldAgentStatisticsProvider extends ChangeNotifier {
  List<Widget> fieldAgentGridItem = [];
  List<Widget> partitionedData = [];
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();

  Future getStatisticsData(String agentId, BuildContext context) async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getFieldAgentStatistics(agentId);
      if (data != null) {
        if (data.data.isEmpty) {
          generateDummyGridData();
        } else {
          for (final item in data.data) {
            fieldAgentGridItem.add(
              FieldAgentStatisticsGridItem(
                text: item.statisticName!,
                count: item.statisticCount!,
                background: Colors.white,
              ),
            );
          }
        }
      } else {
        generateDummyGridData();
      }
      return partitionedData;
    });
  }

  generateDummyGridData() {
    for (int i = 0; i < 6; i++) {
      fieldAgentGridItem.add(
        const FieldAgentStatisticsGridItem(
          text: "No Data",
          count: 0,
          background: Colors.white,
        ),
      );
    }
  }

  void populateContext(BuildContext context) {
    Iterable<List<Widget>> pairs = partition(fieldAgentGridItem, 6);
    for (final List<Widget> pair in pairs) {
      partitionedData.add(
        GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: MediaQuery.of(context).size.width * 0.00250,
          crossAxisCount: 3,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          shrinkWrap: true,
          children: pair,
        ),
      );
    }
  }
}
