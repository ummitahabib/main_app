import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/model/add_asset_request.dart';
import 'package:smat_crow/features/shared/data/model/add_asset_response.dart';
import 'package:smat_crow/features/shared/data/model/asset_details_response.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/features/shared/data/repository/assets_repository.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final assetProvider = ChangeNotifierProvider<AssetNotifier>((ref) {
  return AssetNotifier(ref);
});

class AssetNotifier extends ChangeNotifier {
  final Ref ref;

  AssetNotifier(this.ref);

  final _pandora = Pandora();
  bool _loading = false;
  bool get loading => _loading;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  bool _loadMore = false;
  bool get loadMore => _loadMore;

  set loadMore(bool state) {
    _loadMore = state;
    notifyListeners();
  }

  List<AssetDetailsResponse> _orgAssetList = [];
  List<AssetDetailsResponse> get orgAssetList => _orgAssetList;

  set orgAssetList(List<AssetDetailsResponse> list) {
    _orgAssetList = list;
    notifyListeners();
  }

  AssetDetailsResponse? _assetDetails;
  AssetDetailsResponse? get assetDetails => _assetDetails;

  set assetDetails(AssetDetailsResponse? resp) {
    _assetDetails = resp;
    notifyListeners();
  }

  AddAssetResponse? _addAssetResponse;
  AddAssetResponse? get addAssetResponse => _addAssetResponse;

  set addAssetResponse(AddAssetResponse? resp) {
    _addAssetResponse = resp;
    notifyListeners();
  }

  List<LogDetailsResponse> _assetLogsList = [];
  List<LogDetailsResponse> get assetLogsList => _assetLogsList;

  set assetLogsList(List<LogDetailsResponse> list) {
    _assetLogsList = list;
    notifyListeners();
  }

  Future<void> getAssetLogs({Map<String, dynamic>? queries}) async {
    loading = true;
    try {
      final resp =
          await locator.get<AssetsRepository>().getAssetLogs(assetDetails!.assets!.uuid ?? "", queries: queries);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        assetLogsList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ASEETS_LOGS',
        '${ApiClient().baseUrl}/farm-manager/assets/asset/id/logs',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getOrgAssets({
    String? orgId,
    Map<String, dynamic>? queries,
  }) async {
    loading = true;
    try {
      final resp = await locator
          .get<AssetsRepository>()
          .getOrgAssets(orgId: orgId ?? await ref.read(sharedProvider).getOrganizationId(), queries: queries);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        orgAssetList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_ASSETS',
        '${ApiClient().baseUrl}/farm-manager/all/organization',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getMoreOrgAssets({
    String? orgId,
    Map<String, dynamic>? queries,
  }) async {
    loadMore = true;
    try {
      final resp = await locator
          .get<AssetsRepository>()
          .getOrgAssets(orgId: orgId ?? await ref.read(sharedProvider).getOrganizationId(), queries: queries);
      loadMore = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        log(resp.response.length.toString());
        orgAssetList.addAll(resp.response);
      }
    } catch (e) {
      loadMore = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_ASSETS',
        '${ApiClient().baseUrl}/farm-manager/all/organization',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getAssetDetails(String id) async {
    loading = true;
    try {
      final resp = await locator.get<AssetsRepository>().getAssetDetails(id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        assetDetails = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ASSETS_DETAILS',
        '${ApiClient().baseUrl}/farm-manager/assets/$id',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> addAsset(AddAssetRequest request) async {
    loading = true;
    try {
      final resp = await locator.get<AssetsRepository>().addAsset(request);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        addAssetResponse = resp.response;
        await Pandora().saveToSharedPreferences("id", addAssetResponse!.uuid!);
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_ASSETS',
        '${ApiClient().baseUrl}/farm-manager/add',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> addAssetFile(String url, {String? id}) async {
    loading = true;
    try {
      final resp = await locator.get<AssetsRepository>().addAssetFile(id ?? addAssetResponse!.uuid!, url);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {}
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_ASSETS_FILE',
        '${ApiClient().baseUrl}/farm-manager/assets/addFile',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> addAssetImage(String url, {String? id}) async {
    loading = true;
    try {
      final resp = await locator.get<AssetsRepository>().addAssetImage(id ?? addAssetResponse!.uuid!, url);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {}
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_ASSETS_IMAGE',
        '${ApiClient().baseUrl}/farm-manager/assets/addImage',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> addAssetThread(String url, String id) async {
    loading = true;
    try {
      final resp = await locator.get<AssetsRepository>().addAssetThread(id, url);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        await getAssetDetails(id);
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_ASSETS_THREAD',
        '${ApiClient().baseUrl}/farm-manager/assets/addThread',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> publishAsset(String activityId) async {
    loading = true;
    try {
      final resp = await locator.get<AssetsRepository>().publishAsset(activityId);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        addAssetResponse = resp.response;
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'PUBLISH_ASSETS',
        '${ApiClient().baseUrl}/farm-manager/assets/publish',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateAsset(AddAssetRequest request) async {
    loading = true;
    try {
      if (assetDetails == null) {
        loading = false;
        return false;
      }
      final resp = await locator.get<AssetsRepository>().updateAsset(assetDetails!.assets!.uuid!, request);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        addAssetResponse = resp.response;
        await Pandora().saveToSharedPreferences("id", addAssetResponse!.uuid!);
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'UPDATE_ASSETS',
        '${ApiClient().baseUrl}/farm-manager/assets/update',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> deleteAsset(String id, String reason) async {
    loading = true;
    try {
      final resp = await locator.get<AssetsRepository>().deleteAsset(id, reason);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'DELETE_ASSETS',
        '${ApiClient().baseUrl}/farm-manager/assets/delete',
        "error",
        e.toString(),
      );
      return false;
    }
  }
}
