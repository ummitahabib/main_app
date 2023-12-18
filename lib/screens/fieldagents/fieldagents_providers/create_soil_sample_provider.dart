import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smat_crow/network/crow/models/missions_for_agent_response.dart';
import 'package:smat_crow/network/crow/models/missions_for_agent_response.dart' as missions;
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/network/crow/star_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/geolocation_service.dart';

class CreateSoilSamplesPageProvider extends ChangeNotifier {
  final GeoLocatorService geoService = GeoLocatorService();

  final Pandora _pandora = Pandora();
  int i = 0;
  TextEditingController sampleDepth = TextEditingController();
  TextEditingController sampleName = TextEditingController();
  GetSiteById? siteData;

  final picker = ImagePicker();
  File? sampleImage;

  bool isExpanded = false;
  BuildContext? draggableContext;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  GetMissionsForAgent? getMissionsData;

  List<GetMissionsForAgent> agentMissions = [];

  bool get mounted => false;

  Future getMissionsForAgent(String agentId) async {
    final data = await getStarMissionsForAgent(agentId);
    agentMissions.clear();
    if (data.isNotEmpty) {
      for (final mission in data) {
        log(mission.toJson().toString());
        if ((mission.progress ?? "").toLowerCase() == 'assigned') {
          agentMissions.add(
            missions.GetMissionsForAgent(
              site: mission.site,
              organization: mission.organization,
              description: mission.description,
              name: mission.name,
              agent: mission.agent,
              createdAt: mission.createdAt,
              id: mission.id,
              progress: mission.progress,
              samples: mission.samples,
              updatedAt: mission.updatedAt,
            ),
          );
        }
      }
    }
    agentMissions = agentMissions;
    notifyListeners();
    return data;
  }
}
