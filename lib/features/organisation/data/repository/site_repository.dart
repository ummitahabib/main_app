import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smat_crow/features/organisation/data/models/create_polygon_request.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/features/organisation/data/models/site_by_id.dart';
import 'package:smat_crow/network/crow/models/request/create_site.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

Pandora _pandora = Pandora();

class SiteRepository {
  Future<RequestRes> getSiteInOrganisations(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/org/sites/organizations/$id");
      final List<SiteById> emp = response.map<SiteById>((e) => SiteById.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_SITES',
        '$BASE_URL/org/sites/organizations/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: emp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_ORGANIZATION_SITES',
        '$BASE_URL/org/sites/organizations/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getSiteById(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/org/sites/$id");

      final resp = SiteById.fromJson(response);
      _pandora.logAPIEvent(
        'GET_SITES_BY_ID',
        '$BASE_URL/org/sites/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SITES_BY_ID',
        '$BASE_URL/org/sites/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateSite(String id, Map<String, dynamic> data) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put("/org/sites/$id/update", data: data);

      final resp = SiteById.fromJson(response);
      _pandora.logAPIEvent(
        'UPDATE_SITE',
        '$BASE_URL/org/sites/$id/update',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_SITE',
        '$BASE_URL/org/sites/$id/update',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> deleteSite(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete("/org/sites/$id/delete");

      _pandora.logAPIEvent(
        'DELETE_SITE',
        '$BASE_URL//org/sites/$id/delete',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'DELETE_SITE',
        '$BASE_URL/org/sites/$id/delete',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> createSite(CreateSiteRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post("/org/sites", data: request.toJson());
      final resp = SiteById.fromJson(response);
      _pandora.logAPIEvent(
        'CREATE_SITE',
        '$BASE_URL/org/sites/',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'CREATE_SITE',
        '$BASE_URL/org/sites',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> createPolygon(CreatePolygonRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post("/smatagro/create-polygon", data: request.toJson());
      // final resp = SiteById.fromJson(response);
      _pandora.logAPIEvent(
        'CREATE_POLYGON',
        '$BASE_URL/smatagro/create-polygon',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'CREATE_POLYGON',
        '$BASE_URL/smatagro/create-polygon',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> generateSiteReport(String siteId, String organizationId) async {
    final client = locator.get<ApiClient>();
    final token = await Pandora().getFromSharedPreferences("token");
    try {
      final response = await client.post(
        "/report/$siteId/$organizationId/generate",
        options: Options(
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': token,
          },
        ),
      );

      _pandora.logAPIEvent(
        'GENERATE_SITE_REPORT',
        '$BASE_URL/report/$siteId/$organizationId/generate',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'GENERATE_SITE_REPORT',
        '$BASE_URL/report/$siteId/$organizationId/generate',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
