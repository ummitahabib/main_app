import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/repository/site_options_repositorty.dart';
import 'package:smat_crow/network/crow/models/request/create_star_mission_request.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final siteOptionProvider = ChangeNotifierProvider<SiteOptionNotifier>((ref) {
  return SiteOptionNotifier(ref);
});
final _pandora = Pandora();

class SiteOptionNotifier extends ChangeNotifier {
  final Ref ref;

  SiteOptionNotifier(this.ref);
  bool _loading = false;
  bool get loading => _loading;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  Future<bool> requestSoilTestMission(CreateMissionRequest request) async {
    loading = true;
    try {
      final resp = await locator.get<SiteOptionRepository>().requestSoilTestMission(request);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg(newMissionRequested, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'REQUEST_MISSION_FOR_SITE',
        '$BASE_URL/smatstar/missions',
        "error",
        e.toString(),
      );
      return false;
    }
  }
}
