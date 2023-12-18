import 'dart:io';

import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/network/crow/models/industries_response.dart';
import 'package:smat_crow/network/crow/models/organization_by_id_response.dart';
import 'package:smat_crow/network/crow/models/organizations_response.dart';
import 'package:smat_crow/network/crow/models/request/create_organization.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

class OrganizationRepostiory {
  final Pandora _pandora = Pandora();
  Future<RequestRes> getUserOrganisations(String userId) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/org/organizations/users/$userId");
      final List<GetUserOrganizations> emp =
          response.map<GetUserOrganizations>((e) => GetUserOrganizations.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_USER_ORGANIZATIONS',
        '$BASE_URL/org/organizations/users/$userId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: emp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_USER_ORGANIZATIONS',
        '$BASE_URL/org/organizations/users/$userId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getAllIndustries() async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/in/industries");
      final List<GetIndustriesResponse> emp =
          response.map<GetIndustriesResponse>((e) => GetIndustriesResponse.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_ALL_INDUSTRIES',
        '$BASE_URL/in/industries',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: emp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ALL_INDUSTRIES',
        '$BASE_URL/in/industries',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getOrganisationById(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/org/organizations/$id");

      final resp = GetOrganizationById.fromJson(response);
      _pandora.logAPIEvent(
        'GET_ORGANIZATIONS_BY_ID',
        '$BASE_URL/org/organizations/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ORGANIZATIONS_BY_ID',
        '$BASE_URL/org/organizations/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> deleteOrganisationById(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete("/org/organizations/$id");

      _pandora.logAPIEvent(
        'DELETE_ORGANIZATIONS_BY_ID',
        '$BASE_URL/org/organizations/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'DELETE_ORGANIZATIONS_BY_ID',
        '$BASE_URL/org/organizations/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateOrganisationById(String id, CreateOrganizationRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put("/org/organizations/$id/update", data: request.toJson());
      _pandora.logAPIEvent(
        'UPDATE_ORGANIZATIONS_BY_ID',
        '$BASE_URL/org/organizations/$id/update',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_ORGANIZATIONS_BY_ID',
        '$BASE_URL/org/organizations/$id/update',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> createOrganisation(CreateOrganizationRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post("/org/organizations", data: request.toJson());

      _pandora.logAPIEvent(
        'CREATE_ORGANIZATION',
        '$BASE_URL/org/organizations',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'CREATE_ORGANIZATION',
        '$BASE_URL/org/organizations',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
