import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/model/add_log_request.dart';
import 'package:smat_crow/features/shared/data/model/add_log_response.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/features/shared/data/repository/logs_repository.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final logProvider = ChangeNotifierProvider<LogNotifier>((ref) {
  return LogNotifier(ref);
});

class LogNotifier extends ChangeNotifier {
  final Ref ref;

  LogNotifier(this.ref);

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

  List<LogDetailsResponse> _orgLogList = [];
  List<LogDetailsResponse> get orgLogList => _orgLogList;

  set orgLogList(List<LogDetailsResponse> list) {
    _orgLogList = list;
    notifyListeners();
  }

  LogDetailsResponse? _logResponse;
  LogDetailsResponse? get logResponse => _logResponse;

  set logResponse(LogDetailsResponse? resp) {
    _logResponse = resp;
    notifyListeners();
  }

  AddLogResponse? _addLogResponse;
  AddLogResponse? get addLogResponse => _addLogResponse;

  set addLogResponse(AddLogResponse? resp) {
    _addLogResponse = resp;
    notifyListeners();
  }

  Future<void> getLogs(String id) async {
    loading = true;
    try {
      final resp = await locator.get<LogsRepository>().getLogs(id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        logResponse = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_LOGS',
        '${ApiClient().baseUrl}/farm-manager/logs/$id',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getOrgLogs({Map<String, dynamic>? queries, String? orgId, String? siteId}) async {
    loading = true;
    try {
      final resp = await locator.get<LogsRepository>().getOrgLogs(
            orgId ?? await ref.read(sharedProvider).getOrganizationId(),
            siteId ?? ref.read(siteProvider).site!.id,
            queries: queries,
          );

      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        orgLogList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_LOGS',
        '${ApiClient().baseUrl}/farm-manager/logs/',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getMoreOrgLogs({Map<String, dynamic>? queries, String? orgId, String? siteId}) async {
    loadMore = true;
    try {
      final resp = await locator.get<LogsRepository>().getOrgLogs(
            orgId ?? await ref.read(sharedProvider).getOrganizationId(),
            siteId ?? ref.read(siteProvider).site!.id,
            queries: queries,
          );

      loadMore = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        orgLogList.addAll(resp.response);
        orgLogList = orgLogList.toSet().toList();
      }
    } catch (e) {
      loadMore = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_LOGS',
        '${ApiClient().baseUrl}/farm-manager/logs/',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> addLog(AddLogRequest request) async {
    loading = true;
    try {
      final resp = await locator.get<LogsRepository>().addLog(request);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        addLogResponse = resp.response;
        await getLogs(addLogResponse!.uuid!);
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_LOGS',
        '${ApiClient().baseUrl}/farm-manager/logs/add',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> addLogAssets(String assetId, {String? id}) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<LogsRepository>().addLogAssets(id ?? addLogResponse!.uuid!, assetId);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        await getLogs(id ?? addLogResponse!.uuid!);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_LOGS_ASSETS',
        '${ApiClient().baseUrl}/farm-manager/logs/addAsset',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> addLogFile(String url, {String? id, bool showLoader = true}) async {
    if (showLoader) {
      await OneContext().showProgressIndicator();
    }
    try {
      final resp = await locator.get<LogsRepository>().addLogFile(url, id ?? addLogResponse!.uuid!);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        await getLogs(id ?? addLogResponse!.uuid!);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_LOGS_FILE',
        '${ApiClient().baseUrl}/farm-manager/logs/addFile',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> addLogMedia(String url, {String? id, bool showLoader = true}) async {
    if (showLoader) {
      await OneContext().showProgressIndicator();
    }
    try {
      final resp = await locator.get<LogsRepository>().addLogMedia(url, id ?? addLogResponse!.uuid!);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        await getLogs(id ?? addLogResponse!.uuid!);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_LOGS_MEDIA',
        '${ApiClient().baseUrl}/farm-manager/logs/addMedia',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> addLogOwner(String name, String role, {String? id}) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<LogsRepository>().addLogOwner(name, role, id ?? addLogResponse!.uuid!);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        await getLogs(id ?? addLogResponse!.uuid!);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_LOGS_OWNER',
        '${ApiClient().baseUrl}/farm-manager/logs/addOwner',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> addLogRemark(String remark, String action, {String? id}) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<LogsRepository>().addLogRemark(remark, action, id ?? addLogResponse!.uuid!);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        await getLogs(id ?? addLogResponse!.uuid!);
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_LOGS_REMARK',
        '${ApiClient().baseUrl}/farm-manager/logs/addRemark',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> addLogThread(String url, {String? id}) async {
    loadMore = true;
    try {
      final resp = await locator.get<LogsRepository>().addLogThread(url, id ?? addLogResponse!.uuid!);
      loadMore = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        await getLogs(id ?? addLogResponse!.uuid!);
        return true;
      }
    } catch (e) {
      loadMore = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ADD_LOGS_THREAD',
        '${ApiClient().baseUrl}/farm-manager/logs/addThread',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> publishLog(String activityId) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<LogsRepository>().publishLog(activityId);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        addLogResponse = resp.response;
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'PUBLISH_LOGS',
        '${ApiClient().baseUrl}/farm-manager/logs/publish',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> rejectLog(String activityId) async {
    await OneContext().showProgressIndicator();
    try {
      final resp = await locator.get<LogsRepository>().rejectLog(activityId);
      OneContext().hideProgressIndicator();
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        addLogResponse = resp.response;
        return true;
      }
    } catch (e) {
      OneContext().hideProgressIndicator();
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'REJECT_LOGS',
        '${ApiClient().baseUrl}/farm-manager/logs/reject',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> updateLog(AddLogRequest request) async {
    loading = true;
    try {
      if (logResponse == null) {
        loading = false;
        return false;
      }
      final resp = await locator.get<LogsRepository>().updateLog(logResponse!.log!.uuid!, request);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        addLogResponse = resp.response;
        await getLogs(addLogResponse!.uuid!);
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'UPDATE_LOGS',
        '${ApiClient().baseUrl}/farm-manager/logs/update',
        "error",
        e.toString(),
      );
      return false;
    }
  }
}
