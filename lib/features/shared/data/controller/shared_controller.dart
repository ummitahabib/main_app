import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/data/model/alert_notification.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/models/menu_item_model.dart';
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
import 'package:smat_crow/features/shared/data/repository/shared_repository.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final sharedProvider = ChangeNotifierProvider<SharedNotifier>((ref) {
  return SharedNotifier(ref: ref);
});

class SharedNotifier extends ChangeNotifier {
  Ref? ref;

  SharedNotifier({this.ref});
  final _pandora = Pandora();
  bool _loading = false;
  bool get loading => _loading;

  bool _loader = false;
  bool get loader => _loader;

  AssetTypes? _assetTypes;
  AssetTypes? get assetTypes => _assetTypes;

  LogType? _logType;
  LogType? get logType => _logType;

  set logType(LogType? type) {
    _logType = type;
    notifyListeners();
  }

  set assetTypes(AssetTypes? type) {
    _assetTypes = type;
    notifyListeners();
  }

  Seasons? _season;
  Seasons? get season => _season;

  set season(Seasons? str) {
    _season = str;
    notifyListeners();
  }

  List<AssetStatus> _assetStatusList = [];
  List<AssetStatus> get assetStatusList => _assetStatusList;

  List<AssetTypes> _assetTypesList = [];
  List<AssetTypes> get assetTypesList => _assetTypesList;

  List<Currency> _currencyList = [];
  List<Currency> get currencyList => _currencyList;

  List<LogType> _logTypesList = [];
  List<LogType> get logTypesList => _logTypesList;

  List<LogStatus> _logStatusList = [];
  List<LogStatus> get logStatusList => _logStatusList;

  List<Quantity> _quantityList = [];
  List<Quantity> get quantityList => _quantityList;

  List<Seasons> _seasonList = [];
  List<Seasons> get seasonList => _seasonList;

  List<Flags> _flagList = [];
  List<Flags> get flagList => _flagList;

  AlertNotification? _notification;
  AlertNotification? get notification => _notification;

  set notification(AlertNotification? alert) {
    _notification = alert;
    notifyListeners();
  }

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  set loader(bool state) {
    _loader = state;
    notifyListeners();
  }

  set assetStatusList(List<AssetStatus> list) {
    _assetStatusList = list;
    notifyListeners();
  }

  set assetTypesList(List<AssetTypes> list) {
    _assetTypesList = list;
    notifyListeners();
  }

  set currencyList(List<Currency> list) {
    _currencyList = list;
    notifyListeners();
  }

  set logTypesList(List<LogType> list) {
    _logTypesList = list;
    notifyListeners();
  }

  set logStatusList(List<LogStatus> list) {
    _logStatusList = list;
    notifyListeners();
  }

  set seasonList(List<Seasons> list) {
    _seasonList = list;
    notifyListeners();
  }

  set quantityList(List<Quantity> list) {
    _quantityList = list;
    notifyListeners();
  }

  set flagList(List<Flags> list) {
    _flagList = list;
    notifyListeners();
  }

  UserProfileInfo? _userInfo;
  UserProfileInfo? get userInfo => _userInfo;

  set userInfo(UserProfileInfo? info) {
    _userInfo = info;
    notifyListeners();
  }

  List<GroupPremission> _permissionList = [];
  List<GroupPremission> get permissionList => _permissionList;
  set permissionList(List<GroupPremission> list) {
    _permissionList = list;
    notifyListeners();
  }

  Future<String> getOrganizationId() async {
    if (userInfo == null) {
      final id = await Pandora().getFromSharedPreferences("orgId");
      return id;
    }
    try {
      if (userInfo!.user.role.role == UserRole.user.name) {
        return ref!.read(organizationProvider).organization!.id ?? "";
      }
      if (userInfo!.user.role.role == UserRole.agent.name) {
        return ref!.read(farmManagerProvider).agentOrg!.organizations!.organizationId ?? "";
      }

      if (userInfo!.user.role.role == UserRole.institution.name) {
        return ref!.read(institutionProvider).instOrganization!.organizationId ?? "";
      }
    } catch (e) {
      final id = await Pandora().getFromSharedPreferences("orgId");
      return id;
    }

    final id = await Pandora().getFromSharedPreferences("orgId");
    return id;
  }

  void getOrganizationList() {
    if (userInfo == null) return;
    if (userInfo!.user.role.role == UserRole.user.name) {
      ref!.read(organizationProvider).getUserOrganizations();
    }
    if (userInfo!.user.role.role == UserRole.institution.name) {
      ref!.read(institutionProvider).getInstitutionOrg();
    }
    if (userInfo!.user.role.role == UserRole.agent.name) {
      ref!.read(farmManagerProvider).getAgentOrg();
    }
  }

  List<MenuItemModel> getSideMenuItem() {
    if (userInfo != null && userInfo!.user.role.role == UserRole.institution.name) {
      return [
        MenuItemModel(name: home, asset: AppAssets.home, route: ConfigRoute.homeDashborad),
        MenuItemModel(name: news, asset: AppAssets.news, route: ConfigRoute.newsRoute),

        ///   MenuItemModel(name: socials, asset: AppAssets.socials, route: ConfigRoute.socialRoute),
        MenuItemModel(name: manageOrg, asset: AppAssets.settings, route: ConfigRoute.manageOrgRoute),
        MenuItemModel(name: profile, asset: AppAssets.profile, route: ConfigRoute.profileRoute),
      ];
    }
    return [
      MenuItemModel(name: home, asset: AppAssets.home, route: ConfigRoute.homeDashborad),
      MenuItemModel(name: news, asset: AppAssets.news, route: ConfigRoute.newsRoute),
      // MenuItemModel(name: socials, asset: AppAssets.socials, route: ConfigRoute.socialRoute),
      MenuItemModel(name: profile, asset: AppAssets.profile, route: ConfigRoute.profileRoute),
    ];
  }

  List<String> getNavList() {
    if (userInfo != null && userInfo!.user.role.role == UserRole.institution.name) {
      return [
        ConfigRoute.homeDashborad,
        ConfigRoute.newsRoute,
        // ConfigRoute.socialRoute,
        ConfigRoute.manageOrgRoute,
        ConfigRoute.profileRoute
      ];
    }
    return [
      ConfigRoute.homeDashborad,
      ConfigRoute.newsRoute,
      // ConfigRoute.socialRoute,
      ConfigRoute.profileRoute,
    ];
  }

  String selected = ConfigRoute.homeDashborad;

  void getSelectedSideMenuItem(String path) {
    if (path.contains(ConfigRoute.homeDashborad)) {
      selected = ConfigRoute.homeDashborad;
    } else if (path.contains(ConfigRoute.newsRoute)) {
      selected = ConfigRoute.newsRoute;
    } else if (path.contains(ConfigRoute.socialRoute)) {
      selected = ConfigRoute.socialRoute;
    } else if (path.contains(ConfigRoute.manageOrgRoute)) {
      selected = ConfigRoute.manageOrgRoute;
    } else if (path.contains(ConfigRoute.profileRoute)) {
      selected = ConfigRoute.profileRoute;
    }
  }

  Future<void> getProfile() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getProfile();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        userInfo = resp.response;
        log(userInfo!.perks.toString());
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_PROFILE',
        '${ApiClient().baseUrl}/smatauth/auth/profile',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getNotificationSetting() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getSettings();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        notification = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SETTINGS',
        '${ApiClient().baseUrl}/farm-manager/shared/settings',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> updateNotificationSetting(Map<String, dynamic> data) async {
    loader = true;
    try {
      final resp = await locator.get<SharedRepository>().updateSettings(data);
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        notification = resp.response;
      }
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SETTINGS',
        '${ApiClient().baseUrl}/farm-manager/shared/settings',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getAssetStatus() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getAssetStatus();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        assetStatusList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ASSET_STATUS',
        '${ApiClient().baseUrl}/farm-manager/shared/assetStatus',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getAssetTypes() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getAssetTypes();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        assetTypesList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_ASSET_TYPES',
        '${ApiClient().baseUrl}/farm-manager/shared/assetTypes',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getCurrencies() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getCurrencies();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        currencyList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_CURRENCIES',
        '${ApiClient().baseUrl}/farm-manager/shared/currencies',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getPermission([bool showLoader = true]) async {
    loading = showLoader;
    try {
      final resp = await locator.get<SharedRepository>().getPermissionGroup();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        permissionList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_GROUP_PERMISSION',
        '${ApiClient().baseUrl}/farm-manager/shared/permissionGroups',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getLogStatus() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getLogStatus();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        logStatusList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_LOG_STATUS',
        '${ApiClient().baseUrl}/farm-manager/shared/logStatus',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getLogTypes() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getLogTypes();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        logTypesList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_LOG_TYPES',
        '${ApiClient().baseUrl}/farm-manager/shared/logTypes',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getQuantities() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getQuantities();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        quantityList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_LOG_TYPES',
        '${ApiClient().baseUrl}/farm-manager/shared/logTypes',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getSeasons() async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getSeasons();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        seasonList = resp.response;
        if (seasonList.isNotEmpty) {
          season = seasonList.firstWhere((element) => element.isCurrent == "Y", orElse: () => seasonList.last);
        }
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SEASONS',
        '${ApiClient().baseUrl}/farm-manager/shared/seasons',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getFlags({String? orgId}) async {
    loading = true;
    try {
      final resp = await locator.get<SharedRepository>().getFlags(
            queries: userInfo != null && userInfo!.user.role.role != UserRole.agent.name
                ? null
                : {"organizationId": orgId ?? await getOrganizationId()},
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        flagList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_FLAGS',
        '${ApiClient().baseUrl}/farm-manager/shared/flags',
        "error",
        e.toString(),
      );
    }
  }
}
