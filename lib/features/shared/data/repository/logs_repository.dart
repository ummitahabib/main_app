import 'dart:io';

import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/features/shared/data/model/add_log_request.dart';
import 'package:smat_crow/features/shared/data/model/add_log_response.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

class LogsRepository {
  final _pandora = Pandora();

  Future<RequestRes> getLogs(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/farm-manager/logs/$id").then((value) => value["data"]);

      final resp = LogDetailsResponse.fromJson(response);
      _pandora.logAPIEvent(
        'GET_LOGS',
        '${client.baseUrl}/farm-manager/logs/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_LOGS',
        '${client.baseUrl}/farm-manager/logs/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getOrgLogs(String orgId, String siteId, {Map<String, dynamic>? queries}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client
          .get("/farm-manager/logs/all/organization/$orgId/site/$siteId", queries: queries)
          .then((value) => value["data"]);
      final resp = response.map((e) => LogDetailsResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_LOGS',
        '${client.baseUrl}/farm-manager/logs/all/organization/$orgId/site/$siteId"',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_LOGS',
        '${client.baseUrl}/farm-manager/logs/all/organization/$orgId/site/$siteId"',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addLogAssets(String logId, String assetId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/addAsset",
        data: {"logId": logId, "assetId": assetId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_LOGS_ASSETS',
        '${client.baseUrl}/farm-manager/logs/addAsset"',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_LOGS_ASSETS',
        '${client.baseUrl}/farm-manager/logs/addAsset"',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addLogFile(String url, String itemId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/addFile",
        data: {"url": url, "itemId": itemId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_LOGS_FILES',
        '${client.baseUrl}/farm-manager/logs/addFile',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_LOGS_FILES',
        '${client.baseUrl}/farm-manager/logs/addFile',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addLogMedia(String url, String itemId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/addMedia",
        data: {"url": url, "itemId": itemId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_LOGS_MEDIA',
        '${client.baseUrl}/farm-manager/logs/addMedia',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_LOGS_MEDIA',
        '${client.baseUrl}/farm-manager/logs/addMedia',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addLogThread(String url, String itemId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/addThread",
        data: {"url": url, "itemId": itemId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_LOGS_THREAD',
        '${client.baseUrl}/farm-manager/logs/addThread',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_LOGS_THREAD',
        '${client.baseUrl}/farm-manager/logs/addThread',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addLogOwner(String name, String role, String logId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/addOwner",
        data: {"ownerName": name, "ownerRole": role, "logId": logId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_LOGS_OWNER',
        '${client.baseUrl}/farm-manager/logs/addOwner',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_LOGS_OWNER',
        '${client.baseUrl}/farm-manager/logs/addOwner',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addLogRemark(String remark, String action, String logId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/addRemark",
        data: {"remark": remark, "nextAction": action, "logId": logId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_LOGS_REMARK',
        '${client.baseUrl}/farm-manager/logs/addRemark',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_LOGS_REMARK',
        '${client.baseUrl}/farm-manager/logs/addRemark',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addLog(AddLogRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client
          .post(
            "/farm-manager/logs/add",
            data: request.toJson(),
          )
          .then((value) => value["data"]);
      final resp = AddLogResponse.fromJson(response);
      _pandora.logAPIEvent(
        'ADD_LOGS',
        '${client.baseUrl}/farm-manager/logs/add',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_LOGS',
        '${client.baseUrl}/farm-manager/logs/add',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> publishLog(String activityId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/publish",
        data: {"activityId": activityId},
      ).then((value) => value["data"]);
      final resp = AddLogResponse.fromJson(response);
      _pandora.logAPIEvent(
        'PUBLISH_LOGS',
        '${client.baseUrl}/farm-manager/logs/publish',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'PUBLISH_LOGS',
        '${client.baseUrl}/farm-manager/logs/publish',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> rejectLog(String activityId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/logs/reject",
        data: {"activityId": activityId},
      ).then((value) => value["data"]);
      final resp = AddLogResponse.fromJson(response);
      _pandora.logAPIEvent(
        'REJECT_LOGS',
        '${client.baseUrl}/farm-manager/logs/reject',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'REJECT_LOGS',
        '${client.baseUrl}/farm-manager/logs/reject',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateLog(String id, AddLogRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client
          .put(
            "/farm-manager/logs/update/$id",
            data: request.toJson(),
          )
          .then((value) => value["data"]);
      final resp = AddLogResponse.fromJson(response);
      _pandora.logAPIEvent(
        'UPDATE_LOGS',
        '${client.baseUrl}/farm-manager/logs/update/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_LOGS',
        '${client.baseUrl}/farm-manager/logs/update/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
