import 'dart:io';

import 'package:smat_crow/features/farm_manager/data/model/accept_invite_request.dart';
import 'package:smat_crow/features/farm_manager/data/model/agent_model.dart';
import 'package:smat_crow/features/farm_manager/data/model/agent_organization.dart';
import 'package:smat_crow/features/farm_manager/data/model/agent_type.dart';
import 'package:smat_crow/features/farm_manager/data/model/create_budget_response.dart';
import 'package:smat_crow/features/institution/data/model/invite_response.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

class FarmManagerRepository {
  final _pandora = Pandora();

  Future<RequestRes> viewAgents(String orgId, {bool active = true, int page = 0}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get(
        "/farm-manager/organizations/agents/$orgId",
        queries: {"active": active, "page": page},
      ).then((value) => value["data"]);
      final resp = response.map((e) => FarmAgentModel.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'VIEW_AGENTS',
        '${client.baseUrl}/farm-manager/organizations/agents/$orgId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'VIEW_AGENTS',
        '${client.baseUrl}/farm-manager/organizations/agents/$orgId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> detachAgents(String email, String parentId, List<String> userTypeIds) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete(
        "/farm-manager/organizations/detachAgent",
        queries: {"parentId": parentId, "recipientEmail": email, "userTypeIds": userTypeIds},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'DETACH_AGENT',
        '${client.baseUrl}/farm-manager/organizations/detachAgent',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'DETACH_AGENT',
        '${client.baseUrl}/farm-manager/organizations/detachAgent',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> onboardAgent(String email, String parentId, List<String> userTypeIds) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/organizations/onboardAgent",
        data: {"parentId": parentId, "recipientEmail": email, "userTypeIds": userTypeIds},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ONBOARD_AGENT',
        '${client.baseUrl}/farm-manager/organizations/onboardAgent',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ONBOARD_AGENT',
        '${client.baseUrl}/farm-manager/organizations/onboardAgent',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getAgentTypes() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/farm-manager/organizations/agentTypes").then((value) => value["data"]);
      final resp = response.map((e) => AgentType.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_AGENT_TYPES',
        '${client.baseUrl}/farm-manager/organizations/agentTypes',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_AGENT_TYPES',
        '${client.baseUrl}/farm-manager/organizations/agentTypes',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateAgent(String agentId, String parentId, List<String> userTypeIds) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put(
        "/farm-manager/organizations/updateAgent",
        data: {"parentId": parentId, "agentId": agentId, "userTypeIds": userTypeIds},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'UPDATE_AGENT',
        '${client.baseUrl}/farm-manager/organizations/updateAgent',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_AGENT',
        '${client.baseUrl}/farm-manager/organizations/updateAgent',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> createBudget(String orgId, String seasonId, int amount) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/organizations/budget",
        data: {"organizationId": orgId, "farmingSeasonId": seasonId, "seasonBudget": amount},
      ).then((value) => value["data"]);
      final resp = CreateBudgetResponse.fromJson(response);
      _pandora.logAPIEvent(
        'CREATE_BUDGET',
        '${client.baseUrl}/farm-manager/organizations/budget',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'CREATE_BUDGET',
        '${client.baseUrl}/farm-manager/organizations/budget',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getBudget({required String orgId, Map<String, dynamic>? query}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client
          .get(
            "/farm-manager/organizations/budget/$orgId",
            queries: query,
          )
          .then((value) => value["data"]);
      final resp = response.map((e) => CreateBudgetResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_BUDGET',
        '${client.baseUrl}/farm-manager/organizations/budget/$orgId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_BUDGET',
        '${client.baseUrl}/farm-manager/organizations/budget/$orgId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateBudget(String budgetId, String orgId, String seasonId, int amount) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put(
        "/farm-manager/organizations/budget/$budgetId",
        data: {"organizationId": orgId, "farmingSeasonId": seasonId, "seasonBudget": amount},
      ).then((value) => value["data"]);
      final resp = CreateBudgetResponse.fromJson(response);
      _pandora.logAPIEvent(
        'UPDATE_BUDGET',
        '${client.baseUrl}/farm-manager/organizations/budget/$budgetId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_BUDGET',
        '${client.baseUrl}/farm-manager/organizations/budget/$budgetId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getAgentOrganization({int page = 0, int size = 10}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get(
        "/farm-manager/agents/organizations",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      final resp = response.map((e) => AgentOrganization.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_AGENTS_ORGANIZATION',
        '${client.baseUrl}/farm-manager/agents/organizations',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_AGENTS_ORGANIZATION',
        '${client.baseUrl}/farm-manager/agents/organizations',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> pendinginvitation(String id, {String page = "0", String size = "10"}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get(
        "/farm-manager/organizations/pendingInvitations/$id",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      final resp = response.map((e) => InviteResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'PENDING_INVITATION',
        '${client.baseUrl}/farm-manager/organizations/pendingInvitations',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'PENDING_INVITATION',
        '${client.baseUrl}/farm-manager/organizations/pendingInvitations',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> rejectInvitation(
    String email,
    String parentId,
    String recordId,
  ) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete(
        "/farm-manager/organizations/rejectInvitation/$recordId",
        queries: {"recipientEmail": email, "parentId": parentId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'REJECT_INVITATION',
        '${client.baseUrl}/farm-manager/organizations/rejectInvitation',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'REJECT_INVITATION',
        '${client.baseUrl}/farm-manager/organizations/rejectInvitation',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> acceptInvitation(AcceptInviteRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client
          .post(
            "/farm-manager/organizations/acceptInvitation",
            data: request.toJson(),
          )
          .then((value) => value["message"]);
      _pandora.logAPIEvent(
        'ACEEPT_INVITATION',
        '${client.baseUrl}/farm-manager/organizations/acceptInvitation',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ACEEPT_INVITATION',
        '${client.baseUrl}/farm-manager/organizations/acceptInvitation',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
