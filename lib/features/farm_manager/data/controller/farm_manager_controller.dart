import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/model/accept_invite_request.dart';
import 'package:smat_crow/features/farm_manager/data/model/agent_model.dart';
import 'package:smat_crow/features/farm_manager/data/model/agent_organization.dart';
import 'package:smat_crow/features/farm_manager/data/model/agent_type.dart';
import 'package:smat_crow/features/farm_manager/data/model/create_budget_response.dart';
import 'package:smat_crow/features/farm_manager/data/repository/farm_manager_repository.dart';
import 'package:smat_crow/features/institution/data/model/invite_response.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final farmManagerProvider = ChangeNotifierProvider<FarmManagerNotifier>((ref) {
  return FarmManagerNotifier(ref);
});

enum AgentTypeEnum { field, finance, user }

class FarmManagerNotifier extends ChangeNotifier {
  final Ref ref;

  FarmManagerNotifier(this.ref);

  final _pandora = Pandora();

  bool _loading = false;
  bool get loading => _loading;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  bool _loader = false;
  bool get loader => _loader;

  set loader(bool state) {
    _loader = state;
    notifyListeners();
  }

  bool _loadMore = false;
  bool get loadMore => _loadMore;

  set loadMore(bool state) {
    _loadMore = state;
    notifyListeners();
  }

  List<FarmAgentModel> _farmAgentList = [];
  List<FarmAgentModel> get farmAgentList => _farmAgentList;

  set farmAgentList(List<FarmAgentModel> list) {
    _farmAgentList = list;
    notifyListeners();
  }

  List<AgentType> _agentTypeList = [];
  List<AgentType> get agentTypeList => _agentTypeList;

  set agentTypeList(List<AgentType> list) {
    _agentTypeList = list;
    notifyListeners();
  }

  AgentType? _agentType;
  AgentType? get agentType => _agentType;

  set agentType(AgentType? type) {
    _agentType = type;
    notifyListeners();
  }

  CreateBudgetResponse? _budget;
  CreateBudgetResponse? get budget => _budget;

  set budget(CreateBudgetResponse? type) {
    _budget = type;
    notifyListeners();
  }

  List<CreateBudgetResponse> _budgetList = [];
  List<CreateBudgetResponse> get budgetList => _budgetList;

  set budgetList(List<CreateBudgetResponse> type) {
    _budgetList = type;
    notifyListeners();
  }

  List<AgentOrganization> _agentOrgList = [];
  List<AgentOrganization> get agentOrgList => _agentOrgList;

  set agentOrgList(List<AgentOrganization> list) {
    _agentOrgList = list;
    notifyListeners();
  }

  Organization? _agentOrg;
  Organization? get agentOrg => _agentOrg;

  set agentOrg(Organization? agent) {
    _agentOrg = agent;
    notifyListeners();
  }

  List<InviteResponse> _pendingInviteList = [];
  List<InviteResponse> get pendingInviteList => _pendingInviteList;
  set pendingInviteList(List<InviteResponse> list) {
    _pendingInviteList = list;
    notifyListeners();
  }

  AgentTypeEnum getAgentUserType() {
    if (agentOrg == null) {
      return AgentTypeEnum.user;
    }
    log(agentOrg!.permissions.toString());
    if (agentOrg!.permissions!.contains(FarmManagerPermissions.updateLog) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.publishLog) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.publishAsset) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.updateAsset) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.containsHistoricalFinance) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.containsFinance)) {
      return AgentTypeEnum.finance;
    }
    if (agentOrg!.permissions!.contains(FarmManagerPermissions.createLog) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.createAsset) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.updateLog) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.deleteLog) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.deleteAsset) &&
        agentOrg!.permissions!.contains(FarmManagerPermissions.updateAsset)) {
      return AgentTypeEnum.field;
    }
    return AgentTypeEnum.user;
  }

  Future<void> getAgentOrg() async {
    loading = true;
    try {
      final resp = await locator.get<FarmManagerRepository>().getAgentOrganization();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        agentOrgList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CREATE_BUDGET',
        '${ApiClient().baseUrl}/farm-manager/agents/organizations',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> createBudget(int amount) async {
    loading = true;

    try {
      final resp = await locator.get<FarmManagerRepository>().createBudget(
            await ref.read(sharedProvider).getOrganizationId(),
            ref.read(sharedProvider).season!.uuid.toString(),
            amount,
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg("Budget Added", type: SnackBarType.success);
        await getBudget();
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CREATE_BUDGET',
        '${ApiClient().baseUrl}/farm-manager/organizations/budget',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> getBudget({String? orgId}) async {
    loading = true;

    try {
      final resp = await locator.get<FarmManagerRepository>().getBudget(
        orgId: orgId ?? await ref.read(sharedProvider).getOrganizationId(),
        query: {"farmingSeasonId": ref.read(sharedProvider).season!.uuid},
      );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        budgetList = resp.response;
        if (budgetList.isNotEmpty) {
          budget = budgetList.firstWhere((element) => element.farmingSeasonId == ref.read(sharedProvider).season!.uuid);
        }
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_BUDGET',
        '${ApiClient().baseUrl}/farm-manager/organizations/budget/id',
        "error",
        e.toString(),
      );
    }
  }

  Future<bool> updateBudget(String id, int amount) async {
    loading = true;
    try {
      if (ref.read(organizationProvider).organization == null) {
        return false;
      }
      final resp = await locator.get<FarmManagerRepository>().updateBudget(
            id,
            await ref.read(sharedProvider).getOrganizationId(),
            ref.read(sharedProvider).season!.uuid.toString(),
            amount,
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg("Budget Updated", type: SnackBarType.success);
        return true;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'UPDATE_BUDGET',
        '${ApiClient().baseUrl}/farm-manager/organizations/budget',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<bool> onboardAgent(String email, List<String> userTypeIds) async {
    loader = true;
    try {
      final resp = await locator.get<FarmManagerRepository>().onboardAgent(
            email,
            await ref.read(sharedProvider).getOrganizationId(),
            userTypeIds,
          );
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
        return false;
      } else {
        snackBarMsg("Invite Sent", type: SnackBarType.success);
        unawaited(getAgents());
        return true;
      }
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ONBAORD_AGENTS',
        '${ApiClient().baseUrl}/farm-manager/organizations/onboardAgent',
        "error",
        e.toString(),
      );
      return false;
    }
  }

  Future<void> getAgents({String? orgId}) async {
    loading = true;

    try {
      final resp = await locator.get<FarmManagerRepository>().viewAgents(
            orgId ?? await ref.read(sharedProvider).getOrganizationId(),
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        farmAgentList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'VIEW_AGENTS',
        '${ApiClient().baseUrl}/farm-manager/organizations/agents',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getMoreAgents({String? orgId, int page = 1}) async {
    loadMore = true;

    try {
      final resp = await locator.get<FarmManagerRepository>().viewAgents(
            orgId ?? await ref.read(sharedProvider).getOrganizationId(),
            page: page,
          );
      loadMore = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        farmAgentList.addAll(resp.response);
      }
    } catch (e) {
      loadMore = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'VIEW_AGENTS',
        '${ApiClient().baseUrl}/farm-manager/organizations/agents',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> getAgentTypes() async {
    loading = true;

    try {
      final resp = await locator.get<FarmManagerRepository>().getAgentTypes();
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        agentTypeList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_AGENT_TYPES',
        '${ApiClient().baseUrl}/farm-manager/organizations/agentTypes',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> pendinginvitation([bool load = true]) async {
    loading = load;
    try {
      if (ref.read(sharedProvider).userInfo == null) {
        loading = false;
        return;
      }
      final id = ref.read(sharedProvider).userInfo!.user.id;
      final resp = await locator.get<FarmManagerRepository>().pendinginvitation(id);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        pendingInviteList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'PENDING_INVITATION',
        '${ApiClient().baseUrl}/farm-manager/organizations/pendingInvitations',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> acceptInvite(AcceptInviteRequest request) async {
    loader = true;
    try {
      final resp = await locator.get<FarmManagerRepository>().acceptInvitation(request);
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        snackBarMsg(resp.response, type: SnackBarType.success);
        await pendinginvitation();
      }
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'ACEEPT_INVITATION',
        '${ApiClient().baseUrl}/farm-manager/organizations/acceptInvitation',
        "error",
        e.toString(),
      );
    }
  }

  Future<void> cancelInvitation(String email, String id) async {
    loader = true;
    try {
      if (ref.read(sharedProvider).userInfo == null) {
        loading = false;
        return;
      }
      final resp = await locator
          .get<FarmManagerRepository>()
          .rejectInvitation(email, ref.read(sharedProvider).userInfo!.user.id, id);
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        log(resp.response.toString());
      }
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'CANCEL_INSTITUTION',
        '${ApiClient().baseUrl}/farm-manager/institution/cancelInstitutions',
        "error",
        e.toString(),
      );
    }
  }
}
