import 'package:async/async.dart';
import 'package:flutter/foundation.dart';

import '../../../network/feeds/network/plants_db_operations.dart';

class AllPlantsItemProvider extends ChangeNotifier {
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();

  String imageUrl = '',
      plantName = '',
      plantBotanicalName = '',
      plantDescription = '',
      defaultImage =
          'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80';

  bool get mounted => false;

  Future fetchPlantDetails(String plantId) async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getPlantDetailsForItem(plantId);
      if (data != null) {
        if (mounted) {
          imageUrl = data.openfarmData!.attributes!.mainImagePath!;
          plantName = data.openfarmData!.attributes!.name!;
          plantBotanicalName = data.openfarmData!.attributes!.binomialName!;
          plantDescription = data.openfarmData!.attributes!.description!;
          notifyListeners();
        }
      } else {}
      return data;
    });
  }
}
