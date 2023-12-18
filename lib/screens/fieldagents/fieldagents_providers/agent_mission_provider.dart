import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';

import '../../../network/crow/models/missions_for_agent_response.dart';
import '../../../network/crow/star_operations.dart';
import '../../../utils/strings.dart';
import '../../widgets/empty_list_item.dart';
import '../widgets/missions_item.dart';

class AgentMissionProvider extends ChangeNotifier {
  bool loading = true;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  List<Widget> recentMissionsItem = [];
  List<Color> randomColors = [];
  List<GetMissionsForAgent> getMissionsData = [];

  bool get mounted => false;

  Future getMissionsForAgent(String agentId) async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getStarMissionsForAgent(agentId);
      getMissionsData = data;
      List<Widget> missionsItem = [];
      if (data.isEmpty) {
        missionsItem.add(EmptyListItem(message: noMission));
      } else {
        for (final mission in data) {
          missionsItem.add(
            MissionsItem(
              missionStatus: mission.progress!,
              assignedDate: mission.createdAt!,
              missionTitle: mission.name!,
              siteId: mission.site!,
              missionId: mission.id!,
            ),
          );
        }
      }

      if (mounted) {
        recentMissionsItem = missionsItem;
        notifyListeners();
      }
      return data;
    });
  }
}
