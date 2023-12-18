import 'dart:io';

import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/features/shared/data/model/add_asset_request.dart';
import 'package:smat_crow/features/shared/data/model/add_asset_response.dart';
import 'package:smat_crow/features/shared/data/model/asset_details_response.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

class AssetsRepository {
  final _pandora = Pandora();
  Future<RequestRes> getAssetDetails(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/farm-manager/assets/$id").then((value) => value["data"]);
      final resp = AssetDetailsResponse.fromJson(response);
      _pandora.logAPIEvent(
        'GET_ASSET_DETAILS',
        '${client.baseUrl}/farm-manager/assets/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ASSET_DETAILS',
        '${client.baseUrl}/farm-manager/assets/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getAssetLogs(String id, {Map<String, dynamic>? queries}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response =
          await client.get("/farm-manager/assets/asset/$id/logs", queries: queries).then((value) => value["data"]);

      final resp = response.map((e) => LogDetailsResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_ASSET_LOGS',
        '${client.baseUrl}/farm-manager/assets/asset/$id/logs',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ASSET_LOGS',
        '${client.baseUrl}/farm-manager/assets/asset/$id/logs',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getOrgAssets({
    required String orgId,
    Map<String, dynamic>? queries,
  }) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client
          .get("/farm-manager/assets/all/organization/$orgId", queries: queries)
          .then((value) => value["data"]);
      final resp = response.map((e) => AssetDetailsResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_ASSETS',
        '${client.baseUrl}/farm-manager/assets/all/organization/$orgId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_ASSETS',
        '${client.baseUrl}/farm-manager/assets/all/organization/$orgId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> deleteAsset(String id, String reason) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete(
        "/farm-manager/assets/delete",
        queries: {"recordId": id, "reason": reason},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'DELETE_ASSETS',
        '${client.baseUrl}/farm-manager/assets/delete',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'DELETE_ASSETS',
        '${client.baseUrl}/farm-manager/assets/delete',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addAsset(AddAssetRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client
          .post(
            "/farm-manager/assets/add",
            data: request.toJson(),
          )
          .then((value) => value["data"]);
      final resp = AddAssetResponse.fromJson(response);
      _pandora.logAPIEvent(
        'ADD_ASSETS',
        '${client.baseUrl}/farm-manager/assets/add',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_ASSETS',
        '${client.baseUrl}/farm-manager/assets/add',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> publishAsset(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/assets/publish",
        data: {"activityId": id},
      ).then((value) => value["data"]);
      final resp = AddAssetResponse.fromJson(response);
      _pandora.logAPIEvent(
        'PUBLISH_ASSETS',
        '${client.baseUrl}/farm-manager/assets/publish',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'PUBLISH_ASSETS',
        '${client.baseUrl}/farm-manager/assets/publish',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addAssetFile(String itemId, String url) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put(
        "/farm-manager/assets/addFile",
        data: {"url": url, "itemId": itemId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_ASSETS_FILE',
        '${client.baseUrl}/farm-manager/assets/addFile',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_ASSETS_FILE',
        '${client.baseUrl}/farm-manager/assets/addFile',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addAssetImage(String itemId, String url) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put(
        "/farm-manager/assets/addImage",
        data: {"url": url, "itemId": itemId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_ASSETS_IMAGE',
        '${client.baseUrl}/farm-manager/assets/addImage',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_ASSETS_IMAGE',
        '${client.baseUrl}/farm-manager/assets/addImage',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> addAssetThread(String itemId, String url) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put(
        "/farm-manager/assets/addThread",
        data: {"url": url, "itemId": itemId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ADD_ASSETS_THREAD',
        '${client.baseUrl}/farm-manager/assets/addThread',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ADD_ASSETS_THREAD',
        '${client.baseUrl}/farm-manager/assets/addThread',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateAsset(String id, AddAssetRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client
          .put(
            "/farm-manager/assets/update/$id",
            data: request.toJson(),
          )
          .then((value) => value["data"]);
      final resp = AddAssetResponse.fromJson(response);
      _pandora.logAPIEvent(
        'UPDATE_ASSETS',
        '${client.baseUrl}/farm-manager/assets/update/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_ASSETS',
        '${client.baseUrl}/farm-manager/assets/update/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
