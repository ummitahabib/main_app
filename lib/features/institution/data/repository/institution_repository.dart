import 'dart:io';

import 'package:smat_crow/features/institution/data/model/accept_invite_request.dart';
import 'package:smat_crow/features/institution/data/model/institution_org_response.dart';
import 'package:smat_crow/features/institution/data/model/invite_response.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

class InstitutionRepository {
  final _pandora = Pandora();
  Future<RequestRes> inviteOrganization(String email, String parentId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/institutions/inviteOrganization",
        data: {"recipientEmail": email, "parentId": parentId},
      ).then((value) => value["data"]);

      _pandora.logAPIEvent(
        'INVITE_ORGANIZATION',
        '${client.baseUrl}/farm-manager/institutions/inviteOrganization',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'INVITE_ORGANIZATION',
        '${client.baseUrl}/farm-manager/institutions/inviteOrganization',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> inviteInstitution(String email, String parentId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        "/farm-manager/institutions/inviteInstitution",
        data: {"recipientEmail": email, "parentId": parentId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'INVITE_INSTITUTION',
        '${client.baseUrl}/farm-manager/institutions/inviteInstitution',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'INVITE_INSTITUTION',
        '${client.baseUrl}/farm-manager/institutions/inviteInstitution',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> acceptInstitution(AcceptInviteRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client
          .post(
            "/farm-manager/institutions/acceptInstitution",
            data: request.toJson(),
          )
          .then((value) => value["data"]);
      _pandora.logAPIEvent(
        'ACCEPT_INSTITUTION',
        '${client.baseUrl}/farm-manager/institutions/acceptInstitution',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'ACCEPT_INSTITUTION',
        '${client.baseUrl}/farm-manager/institutions/acceptInstitution',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> sentinvitation(String userId, {String page = "0", String size = "10"}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get(
        "/farm-manager/institutions/sentInvitations/$userId",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      final resp = response.map((e) => InviteResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'SENT_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/sentInvitations',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'SENT_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/sentInvitations',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getParentInstitution({required String instId, String page = "0", String size = "10"}) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/farm-manager/institutions/parent-institutions/$instId",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'GET_PARENT_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/parent-institutions/$instId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_PARENT_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/parent-institutions/$instId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getInstitutionOrg({required String instId, String page = "0", String size = "10"}) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get(
        "/farm-manager/institutions/organizations/$instId",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      final resp = response.map((e) => InstitutionOrgResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_INSTITUTION_ORGANIZATIONS',
        '${client.baseUrl}/farm-manager/institutions/organizations/$instId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_INSTITUTION_ORGANIZATIONS',
        '${client.baseUrl}/farm-manager/institutions/organizations/$instId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getInstitutionMembers({required String instId, String page = "0", String size = "10"}) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/farm-manager/institutions/member-institutions/$instId",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'GET_INSTITUTION_MEMBERS',
        '${client.baseUrl}/farm-manager/institutions/member-institutions/$instId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_INSTITUTION_MEMBERS',
        '${client.baseUrl}/farm-manager/institutions/member-institutions/$instId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getInvitationDetails({required String id, String page = "0", String size = "10"}) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/farm-manager/institutions/invitation/$id",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'GET_INVITATION_DETAILS',
        '${client.baseUrl}/farm-manager/institutions/invitation/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_INVITATION_DETAILS',
        '${client.baseUrl}/farm-manager/institutions/invitation/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> pendinginvitation({String page = "0", String size = "10"}) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/farm-manager/institutions/pendingInvitations",
        queries: {"page": page, "pageSize": size},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'PENDING_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/pendingInvitations',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'PENDING_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/pendingInvitations',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> rejectInvitation(String email, String parentId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete(
        "/farm-manager/institutions/rejectInvitation",
        queries: {"recipientEmail": email, "parentId": parentId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'REJECT_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/rejectInvitation',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'REJECT_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/rejectInvitation',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> cancelInvitation(String email, String parentId, String recordId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete(
        "/farm-manager/institutions/cancelInvitation/$recordId",
        queries: {"recipientEmail": email, "parentId": parentId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'CANCEL_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/cancelInvitation',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'CANCEL_INVITATION',
        '${client.baseUrl}/farm-manager/institutions/cancelInvitation',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> detachOrg(String orgId, String instId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete(
        "/farm-manager/institutions/detachOrganizations/$orgId",
        queries: {"institutionId": instId},
      ).then((value) => value["data"]);
      _pandora.logAPIEvent(
        'DETACH_ORGANIZATION',
        '${client.baseUrl}/farm-manager/institutions/detachOrganizations/$orgId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'DETACH_ORGANIZATION',
        '${client.baseUrl}/farm-manager/institutions/detachOrganizations/$orgId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
