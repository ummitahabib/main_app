import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/screens/farmsense/widgets/farm_sense_list_item.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../network/crow/farm_sense_operations.dart';
import '../../../network/crow/models/get_farmsense_devices.dart';
import '../../../utils/assets/nsvgs_assets.dart';

class FarmSenseDevicesProvider extends ChangeNotifier {
  final AsyncMemoizer _devicesAsync = AsyncMemoizer();
  List<Widget> userDevicesListItem = [];

  bool get mounted => false;
  Future getUserDevices() async {
    return _devicesAsync.runOnce(() async {
      List<UserDevicesResponse> userDevices = await getDevicesForUser(Session.userDetailsResponse!.user!.id!);

      List<Widget> userDevicesListItem = [];

      if (userDevices.isNotEmpty) {
        for (final item in userDevices) {
          userDevicesListItem.add(
            FarmSenseListItem(
              image: NsvgsAssets.kPlantDB,
              userDevicesResponse: item,
            ),
          );
        }
        if (mounted) {
          userDevicesListItem = userDevicesListItem;
        }
      } else {}
      return userDevices;
    });
  }
}
