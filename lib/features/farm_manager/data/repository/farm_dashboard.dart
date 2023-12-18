import 'dart:io';

import 'package:smat_crow/features/farm_manager/data/model/dash_breakdown.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_stat.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_summary.dart';
import 'package:smat_crow/features/farm_manager/data/model/pnl_response.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

class FarmDashboardRepository {
  final _pandora = Pandora();

  Future<RequestRes> dashSummary(String orgId, String? seasonId, {String filter = "PURCHASES"}) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/farm-manager/dashboard/summary/$orgId",
        queries: {"filter": filter, "farmingSeasonId": seasonId},
      ).then((value) => value["data"]);
      final resp = DashSummary.fromJson(response);
      _pandora.logAPIEvent(
        'FARM_MANAGER_DASHBOARD_SUMMARY',
        '${client.baseUrl}/farm-manager/dashboard/summary/$orgId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'FARM_MANAGER_DASHBOARD_SUMMARY',
        '${client.baseUrl}/farm-manager/dashboard/summary/$orgId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> userStat(String userId) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client
          .get(
            "/farm-manager/dashboard/statistics/$userId",
          )
          .then((value) => value["data"]);
      final list = response.map((e) => DashStat.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'FARM_MANAGER_DASHBOARD_STATS',
        '${client.baseUrl}/farm-manager/dashboard/statistics/$userId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: list);
    } catch (e) {
      _pandora.logAPIEvent(
        'FARM_MANAGER_DASHBOARD_STATS',
        '${client.baseUrl}/farm-manager/dashboard/statistics/$userId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> profitLossBreakdown(String orgId, String? seasonId) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get(
        "/farm-manager/dashboard/pnl/$orgId",
        queries: {"farmingSeasonId": seasonId},
      ).then((value) => value["data"]);
      final resp = response.map((e) => PnLResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'FARM_MANAGER_PROFIT_AND_LOSS_BREAKDOWN',
        '${client.baseUrl}/farm-manager/dashboard/pnl/$orgId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'FARM_MANAGER_PROFIT_AND_LOSS_BREAKDOWN',
        '${client.baseUrl}/farm-manager/dashboard/pnl/$orgId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> incomeBreakdown(String orgId, String? seasonId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/farm-manager/dashboard/breakdown/$orgId",
        queries: {"farmingSeasonId": seasonId},
      ).then((value) => value["data"]);
      final resp = DashBreakdown.fromJson(response);
      _pandora.logAPIEvent(
        'FARM_MANAGER_INCOME_BREAKDOWN',
        '${client.baseUrl}/farm-manager/dashboard/breakdown/$orgId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'FARM_MANAGER_INCOME_BREAKDOWN',
        '${client.baseUrl}/farm-manager/dashboard/breakdown/$orgId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
