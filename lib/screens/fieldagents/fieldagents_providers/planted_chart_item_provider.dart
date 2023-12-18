import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

import '../../../network/feeds/models/planted_response.dart';
import '../../../network/feeds/network/plants_db_operations.dart';
import '../widgets/sample_chatr_data.dart';

class PlantedChartItemProvider extends ChangeNotifier {
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  late PlantedResponse plantedData;
  List<ChartModelData> chartData = [];

  bool get mounted => false;

  Future getPlantedChartData(String plantId) async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getPlantingRequirements(plantId);
      if (data != null) {
        if (mounted) {
          plantedData = data;
          chartData = <ChartModelData>[
            ChartModelData(x: 'Seed', y: plantedData.seed!.toDouble(), text: '${plantedData.seed}'),
            ChartModelData(x: 'Seedling', y: plantedData.seedling!.toDouble(), text: '${plantedData.seedling}'),
            ChartModelData(
              x: 'Advanced Plant',
              y: plantedData.advancedPlant!.toDouble(),
              text: '${plantedData.advancedPlant}',
            ),
            ChartModelData(
              x: 'Bare Root',
              y: plantedData.bareRootPlant!.toDouble(),
              text: '${plantedData.bareRootPlant}',
            ),
          ];
          notifyListeners();
        }
      } else {}
      return data;
    });
  }
}
