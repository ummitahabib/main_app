import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_breakdown.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_stat.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_summary.dart';
import 'package:smat_crow/features/farm_manager/data/model/pnl_response.dart';
import 'package:smat_crow/features/farm_manager/data/repository/farm_dashboard.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final farmDashProvider = ChangeNotifierProvider<FarmDashboardNotifier>((ref) {
  return FarmDashboardNotifier(ref);
});

enum SummaryType { purchases, sales }

class FarmDashboardNotifier extends ChangeNotifier {
  final Ref ref;

  FarmDashboardNotifier(this.ref);
  final _pandora = Pandora();
  bool _loading = false;
  bool get loading => _loading;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  List<DashStat> _dashStatList = [];
  List<DashStat> get dashStatList => _dashStatList;

  set dashStatList(List<DashStat> list) {
    _dashStatList = list;
    notifyListeners();
  }

  DashSummary _purchaseSummaryData = DashSummary(upcoming: [], paid: []);
  DashSummary get purchaseSummaryData => _purchaseSummaryData;

  set purchaseSummaryData(DashSummary sum) {
    _purchaseSummaryData = sum;
    notifyListeners();
  }

  DashSummary _salesSummaryData = DashSummary(upcoming: [], paid: []);
  DashSummary get salesSummaryData => _salesSummaryData;

  set salesSummaryData(DashSummary sum) {
    _salesSummaryData = sum;
    notifyListeners();
  }

  DashBreakdown _breakdown = DashBreakdown(seasonBudget: 0, budgetBreakdown: []);
  DashBreakdown get breakdown => _breakdown;

  set breakdown(DashBreakdown dbd) {
    _breakdown = dbd;
    notifyListeners();
  }

  BudgetBreakdown _budgetBreakdown = BudgetBreakdown(month: "", asset: 0.0, log: 0, balance: 0);
  BudgetBreakdown get budgetBreakdown => _budgetBreakdown;

  set budgetBreakdown(BudgetBreakdown bkd) {
    _budgetBreakdown = bkd;
    notifyListeners();
  }

  List<PnLResponse> _pnlBreakdownList = [];
  List<PnLResponse> get pnlBreakdownList => _pnlBreakdownList;

  set pnlBreakdownList(List<PnLResponse> list) {
    _pnlBreakdownList = list;
    notifyListeners();
  }

  String _currentSalesMonth = "month";
  String get currentSalesMonth => _currentSalesMonth;
  set currentSalesMonth(String value) {
    _currentSalesMonth = value;
    notifyListeners();
  }

  String _currentPurchaseMonth = "month";
  String get currentPurchaseMonth => _currentPurchaseMonth;
  set currentPurchaseMonth(String value) {
    _currentPurchaseMonth = value;
    notifyListeners();
  }

  Future<void> getDashStats([bool load = true]) async {
    loading = load;
    try {
      if (ref.read(sharedProvider).userInfo == null) {
        loading = false;
        return;
      }
      final resp = await locator.get<FarmDashboardRepository>().userStat(ref.read(sharedProvider).userInfo!.user.id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        dashStatList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_DASHBOARD_STATS',
        '${ApiClient().baseUrl}/farm-manager/dashboard/statistics',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> dashSummary({SummaryType filter = SummaryType.purchases, String? orgId}) async {
    loading = true;

    try {
      if (ref.read(sharedProvider).season == null) return;

      final resp = await locator.get<FarmDashboardRepository>().dashSummary(
            orgId ?? await ref.read(sharedProvider).getOrganizationId(),
            ref.read(sharedProvider).season!.uuid,
            filter: filter.name.toUpperCase(),
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        if (filter == SummaryType.purchases) {
          purchaseSummaryData = resp.response;
          if ((purchaseSummaryData.paid + purchaseSummaryData.upcoming).isNotEmpty) {
            currentPurchaseMonth =
                (purchaseSummaryData.paid + purchaseSummaryData.upcoming).map((e) => e.month).toSet().first;
          }
        } else {
          salesSummaryData = resp.response;
          if ((salesSummaryData.paid + salesSummaryData.upcoming).isNotEmpty) {
            currentSalesMonth = (salesSummaryData.paid + salesSummaryData.upcoming).map((e) => e.month).toSet().first;
          }
        }
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_DASHBOARD_SUMMARY',
        '${ApiClient().baseUrl}/farm-manager/dashboard/summary',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> incomeBreakdown({String? orgId}) async {
    loading = true;
    try {
      if (ref.read(sharedProvider).season == null) return;
      final resp = await locator.get<FarmDashboardRepository>().incomeBreakdown(
            orgId ?? await ref.read(sharedProvider).getOrganizationId(),
            ref.read(sharedProvider).season!.uuid,
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        breakdown = resp.response;
        if (breakdown.budgetBreakdown.isNotEmpty) {
          budgetBreakdown = breakdown.budgetBreakdown.first;
        }
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_DASHBOARD_INCOME_BREAKDOWN',
        '${ApiClient().baseUrl}/farm-manager/dashboard/breakdown',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> pnlBreakdown({String? orgId}) async {
    loading = true;
    try {
      if (ref.read(sharedProvider).season == null) return;
      final resp = await locator.get<FarmDashboardRepository>().profitLossBreakdown(
            orgId ?? await ref.read(sharedProvider).getOrganizationId(),
            ref.read(sharedProvider).season!.uuid,
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        pnlBreakdownList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_DASHBOARD_INCOME_BREAKDOWN',
        '${ApiClient().baseUrl}/farm-manager/dashboard/breakdown',
        "error",
        e.toString(),
      );
    }
  }
}
