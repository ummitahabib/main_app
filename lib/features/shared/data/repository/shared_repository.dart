import 'dart:io';

import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/features/institution/data/model/alert_notification.dart';
import 'package:smat_crow/features/shared/data/model/asset_status.dart';
import 'package:smat_crow/features/shared/data/model/asset_types.dart';
import 'package:smat_crow/features/shared/data/model/currency.dart';
import 'package:smat_crow/features/shared/data/model/flags.dart';
import 'package:smat_crow/features/shared/data/model/group_permission.dart';
import 'package:smat_crow/features/shared/data/model/log_status.dart';
import 'package:smat_crow/features/shared/data/model/log_types.dart';
import 'package:smat_crow/features/shared/data/model/quantities.dart';
import 'package:smat_crow/features/shared/data/model/seasons.dart';
import 'package:smat_crow/features/shared/data/model/user_profile_info.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final _pandora = Pandora();

class SharedRepository {
  Future<RequestRes> getAssetTypes() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/assetTypes").then((value) => value["data"]);
      final List<AssetTypes> resp = response.map<AssetTypes>((e) => AssetTypes.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_ASSET_TYPES',
        '${client.baseUrl}/farm-manager/shared/assetTypes',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ASSET_TYPES',
        '${client.baseUrl}/farm-manager/shared/assetTypes',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getAssetStatus() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/assetStatus").then((value) => value["data"]);
      final List<AssetStatus> resp = response.map<AssetStatus>((e) => AssetStatus.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_ASSET_STATUS',
        '${client.baseUrl}/farm-manager/shared/assetStatus',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ASSET_STATUS',
        '${client.baseUrl}/farm-manager/shared/assetStatus',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getCurrencies() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/currencies").then((value) => value["data"]);
      final List<Currency> resp = response.map<Currency>((e) => Currency.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_CURRENCIES',
        '${client.baseUrl}/farm-manager/shared/currencies',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_CURRENCIES',
        '${client.baseUrl}/farm-manager/shared/currencies',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getLogStatus() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/logStatus").then((value) => value["data"]);
      final List<LogStatus> resp = response.map<LogStatus>((e) => LogStatus.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_LOG_STATUS',
        '${client.baseUrl}/farm-manager/shared/logStatus',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_LOG_STATUS',
        '${client.baseUrl}/farm-manager/shared/logStatus',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getLogTypes() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/logTypes").then((value) => value["data"]);
      final List<LogType> resp = response.map<LogType>((e) => LogType.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_LOG_TYPES',
        '${client.baseUrl}/farm-manager/shared/logTypes',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_LOG_TYPES',
        '${client.baseUrl}/farm-manager/shared/logTypes',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getQuantities() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/quantities").then((value) => value["data"]);
      final List<Quantity> resp = response.map<Quantity>((e) => Quantity.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_QUANTITIES',
        '${client.baseUrl}/farm-manager/shared/quantities',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_QUANTITIES',
        '${client.baseUrl}/farm-manager/shared/quantities',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getSeasons() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/seasons").then((value) => value["data"]);
      final List<Seasons> resp = response.map<Seasons>((e) => Seasons.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_SEASONS',
        '${client.baseUrl}/farm-manager/shared/seasons',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SEASONS',
        '${client.baseUrl}/farm-manager/shared/seasons',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getFlags({Map<String, dynamic>? queries}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response =
          await client.get("/farm-manager/shared/flags", queries: queries).then((value) => value["data"]);
      final List<Flags> resp = response.map<Flags>((e) => Flags.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_FLAGS',
        '${client.baseUrl}/farm-manager/shared/flags',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_FLAGS',
        '${client.baseUrl}/farm-manager/shared/flags',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getProfile() async {
    final client = locator.get<ApiClient>();
    try {
      final token = await _pandora.getFromSharedPreferences("token");
      client.accessToken = token;
      final response = await client.get("/smatauth/auth/profile");
      final resp = UserProfileInfo.fromJson(response);
      _pandora.logAPIEvent(
        'GET_USER_PROFILE',
        '${client.baseUrl}/smatauth/auth/profile',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_USER_PROFILE',
        '${client.baseUrl}/smatauth/auth/profile',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getSettings() async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/farm-manager/shared/settings");
      final resp = AlertNotification.fromJson(response['data']);
      _pandora.logAPIEvent(
        'GET_SETTINGS',
        '${client.baseUrl}/farm-manager/shared/settings',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SETTINGS',
        '${client.baseUrl}/farm-manager/shared/settings',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getPermissionGroup() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/shared/permissionGroups").then((value) => value['data']);
      final resp = response.map((e) => GroupPremission.fromJson(e)).toList();

      _pandora.logAPIEvent(
        'GET_PERMISSION_GROUP',
        '${client.baseUrl}/farm-manager/shared/permissionGroups',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_PERMISSION_GROUP',
        '${client.baseUrl}/farm-manager/shared/permissionGroups',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateSettings(Map<String, dynamic> data) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put("/farm-manager/shared/settings", data: data);
      final resp = AlertNotification.fromJson(response['data']);
      _pandora.logAPIEvent(
        'UPDATE_SETTINGS',
        '${client.baseUrl}/farm-manager/shared/settings',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_SETTINGS',
        '${client.baseUrl}/farm-manager/shared/settings',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
