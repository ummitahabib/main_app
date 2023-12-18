import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/models/create_polygon_request.dart';
import 'package:smat_crow/features/organisation/data/models/polygon_area.dart';
import 'package:smat_crow/features/organisation/data/models/site_by_id.dart';
import 'package:smat_crow/features/organisation/data/repository/site_repository.dart';
import 'package:smat_crow/network/crow/models/request/create_site.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final siteProvider = ChangeNotifierProvider<SiteNotifier>((ref) {
  return SiteNotifier(ref);
});

enum SubType { site, sector, batch }

class SiteNotifier extends ChangeNotifier {
  final Ref ref;

  SiteNotifier(this.ref);

  List<SiteById> _siteList = [];
  List<SiteById> get siteList => _siteList;

  SiteById? _site;
  SiteById? get site => _site;

  bool _loading = false;
  bool get loading => _loading;

  bool _showSiteOptions = false;
  bool get showSiteOptions => _showSiteOptions;

  SubType _subType = SubType.site;
  SubType get subType => _subType;
  set subType(SubType state) {
    _subType = state;
    notifyListeners();
  }

  double _sheetHeight = 0.4;
  double get sheetHeight => _sheetHeight;

  set sheetHeight(double value) {
    _sheetHeight = value;
    notifyListeners();
  }

  final _pandora = Pandora();

  set siteList(List<SiteById> list) {
    _siteList = list;
    notifyListeners();
  }

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  set showSiteOptions(bool state) {
    _showSiteOptions = state;
    notifyListeners();
  }

  set site(SiteById? sit) {
    _site = sit;
    notifyListeners();
  }

  Future<void> getOrganizationSites(String id) async {
    loading = true;
    try {
      final resp = await locator.get<SiteRepository>().getSiteInOrganisations(id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        siteList = resp.response;
        siteList.sort(
          (a, b) => int.parse(b.createdAt.toString().substring(0, 10).split("-").join())
              .compareTo(int.parse(a.createdAt.toString().substring(0, 10).split("-").join())),
        );
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_SITES',
        '$BASE_URL/org/sites/organizations/$id',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getSites(String id) async {
    loading = true;
    try {
      final resp = await locator.get<SiteRepository>().getSiteById(id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        site = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SITES_BY_ID',
        '$BASE_URL/org/sites/$id',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> createSite(CreateSiteRequest req) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<SiteRepository>().createSite(req);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg(siteCreated, type: SnackBarType.success);
        await getOrganizationSites(req.organization);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();

      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CREATE_SITE',
        '$BASE_URL/org/sites',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> createpolygon(CreatePolygonRequest request, String siteName, PageController controller) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<SiteRepository>().createPolygon(request);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        final req = CreateSiteRequest(
          name: siteName,
          geoJson: request.geoJson.geometry.coordinates.map((e) => e.map((e) => e.reversed.toList()).toList()).toList(),
          organization: ref.read(organizationProvider).organization!.id ?? "",
          polygonId: resp.response['id'].toString(),
        );
        //implement endpoint and got back to site/sector page
        if (subType == SubType.site) {
          await createSite(req).then((value) {
            if (value) {
              controller.jumpToPage(0);
              ref.read(mapProvider).allowMapTap = false;
            }
          });
          return;
        }
      }
    } catch (e) {
      OneContext().hideProgressIndicator();

      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CREATE_SITE',
        '$BASE_URL/org/sites',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> updateSite(String id, Map<String, dynamic> data) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<SiteRepository>().updateSite(id, data);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getSites(id);
        await getOrganizationSites(ref.read(organizationProvider).organization!.id ?? "");
        snackBarMsg(siteUpdated, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());

      _pandora.logAPIEvent(
        'UPDATE_SITE',
        '$BASE_URL/org/sites/$id',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> generateSiteReport() async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator
          .get<SiteRepository>()
          .generateSiteReport(site!.id, ref.read(organizationProvider).organization!.id ?? "");
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        snackBarMsg(reportGenerated, type: SnackBarType.success);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GENERATE_SITE_REPORT',
        '$BASE_URL/report/${site!.id}/${ref.read(organizationProvider).organization!.id}/generate',
        'FAILED',
        e.toString(),
      );
    }
  }

  Future<bool> deleteSite(String id) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<SiteRepository>().deleteSite(id);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg(siteDeleted, type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'DELETE_SITE',
        '$BASE_URL/org/sites',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> createSiteForOrg(BuildContext context, PageController controller, String siteName) async {
    final list = await ref.read(mapProvider).getGeoJsonList(context, ref.read(mapProvider).siteLatLng);
    if (list == null) {
      return;
    }
    if (siteName.isEmpty) {
      snackBarMsg(nameWarning);
      return;
    }
    if (ref.read(mapProvider).calculatePolygonArea(
              PolygonArea(
                type: "Polygon",
                geoJson: list,
              ),
            ) <
        10000) {
      final req = CreateSiteRequest(
        name: siteName,
        geoJson: list,
        organization: ref.read(organizationProvider).organization!.id ?? "",
        polygonId: "0",
      );
      await createSite(req).then((value) {
        if (value) {
          controller.jumpToPage(0);
          ref.read(mapProvider).allowMapTap = false;
        }
      });
      return;
    }
    final request = CreatePolygonRequest(
      geoJson: GeoJson(
        geometry: Geometry(
          coordinates: list.map((e) => e.map((e) => e.reversed.toList()).toList()).toList(),
          type: "Polygon",
        ),
        type: "Feature",
      ),
      name: siteName,
    );
    await createpolygon(request, siteName, controller);
  }
}
