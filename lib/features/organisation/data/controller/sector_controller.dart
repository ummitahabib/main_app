import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/models/sector_by_id.dart';
import 'package:smat_crow/features/organisation/data/repository/sector_repository.dart';
import 'package:smat_crow/network/crow/models/request/create_sector.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final sectorProvider = ChangeNotifierProvider<SectorNotifier>((ref) {
  return SectorNotifier(ref);
});

class SectorNotifier extends ChangeNotifier {
  final Ref ref;

  SectorNotifier(this.ref);

  final _pandora = Pandora();
  bool _loading = false;
  bool get loading => _loading;

  List<SectorById> _sectorList = [];
  List<SectorById> get sectorList => _sectorList;

  SectorById? _sector;
  SectorById? get sector => _sector;

  set sector(SectorById? set) {
    _sector = set;
    notifyListeners();
  }

  set sectorList(List<SectorById> list) {
    _sectorList = list;
    notifyListeners();
  }

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  Future<void> getSiteSectors(String siteId) async {
    loading = true;
    try {
      final resp = await locator.get<SectorRepository>().getSectorInSite(siteId);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        sectorList = resp.response;
        sectorList.sort(
          (a, b) => int.parse(b.createdAt.toString().substring(0, 10).split("-").join())
              .compareTo(int.parse(a.createdAt.toString().substring(0, 10).split("-").join())),
        );
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SITE_SECTORS',
        '$BASE_URL/org/sectors/sites/$siteId',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getSector(String id) async {
    loading = true;
    try {
      final resp = await locator.get<SectorRepository>().getSectorById(id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        sector = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SECTOR_BY_ID',
        '$BASE_URL/org/sectors/$id',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> createSector(CreateSectorRequest req) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<SectorRepository>().createSector(req);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg(sectorCreated, type: SnackBarType.success);
        await getSiteSectors(req.site);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();

      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CREATE_SECTOR',
        '$BASE_URL/org/sectors',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateSector(String id, Map<String, dynamic> data) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<SectorRepository>().updateSector(id, data);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getSector(id);
        await getSiteSectors(ref.read(siteProvider).site!.id);
        snackBarMsg(sectorUpdated, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'UPDATE_SECTOR',
        '$BASE_URL/org/sectors/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteSector(String id) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<SectorRepository>().deleteSector(id);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg(sectorDeleted, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'DELETE_SECTOR',
        '$BASE_URL/org/sectors/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> createSectorForSite(
    BuildContext context,
    PageController controller,
    String siteName,
  ) async {
    final list = await ref.read(mapProvider).getGeoJsonList(context, ref.read(mapProvider).sectorLatLng);
    if (list == null) {
      return;
    }
    if (siteName.isEmpty) {
      Pandora().showToast(
        nameWarning,
        context,
        MessageTypes.WARNING.toString().split('.').last,
      );
      return;
    }
    final req = CreateSectorRequest(
      name: siteName,
      description: "A new sector",
      sectorCoordinates: list,
      site: ref.read(siteProvider).site!.id,
    );

    //implement endpoint and got back to site/sector page
    if (ref.read(siteProvider).subType == SubType.sector) {
      await createSector(req).then((value) {
        if (value) {
          controller.jumpToPage(0);
          ref.read(siteProvider).subType = SubType.site;
          ref.read(mapProvider).allowMapTap = false;
        }
      });
      return;
    }
  }
}
