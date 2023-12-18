import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/request/create_site.dart';
import 'package:smat_crow/network/crow/models/site_by_id_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'models/sites_response.dart';

Pandora _pandora = Pandora();

Future<List<GetOrganizationSites>> getSitesInOrganization(
  String organizationId,
) async {
  debugPrint('getting sites');
  List<GetOrganizationSites> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/org/sites/organizations/$organizationId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_SITES_IN_ORGANIZATION',
      '$BASE_URL/org/sites/organizations/$organizationId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<GetOrganizationSites>.from(
      jsonDecode(response.body).map((model) => GetOrganizationSites.fromJson(model)),
    );
    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_SITES_IN_ORGANIZATION',
      '$BASE_URL/org/sites/organizations/$organizationId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_SITES_IN_ORGANIZATION',
      '$BASE_URL/org/sites/organizations/$organizationId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetSiteById?> getSiteById(String siteId) async {
  debugPrint('getting sites by Id');
  GetSiteById? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/org/sites/$siteId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    result = GetSiteById.fromJson(jsonDecode(response.body));
    _pandora.logAPIEvent(
      'GET_SITES_BY_ID',
      '$BASE_URL/org/sites/$siteId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_SITES_BY_ID',
      '$BASE_URL/org/sites/$siteId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_SITES_BY_ID',
      '$BASE_URL/org/sites/$siteId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<bool> createSiteForOrganization(CreateSiteRequest request) async {
  debugPrint('create site for organization ${request.toJson()}');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/org/sites'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
    body: jsonEncode(<String, dynamic>{
      'name': request.name,
      'geoJson': request.geoJson,
      'organization': request.organization,
    }),
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'CREATE_SITE_FOR_ORGANIZATION',
      '$BASE_URL/org/sites',
      HttpStatus.ok.toString(),
      HttpStatus.created.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Site Created'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'CREATE_SITE_FOR_ORGANIZATION',
      '$BASE_URL/org/sites',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'CREATE_SITE_FOR_ORGANIZATION',
      '$BASE_URL/org/sites',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}

Future<bool> generateReportForSite(String id, String organizationId) async {
  debugPrint('generate site report $id');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/report/$id/$organizationId/generate'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'GENERATE_SITE_REPORT',
      '$BASE_URL/$id/generate',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Site Report Sent to your Email'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GENERATE_SITE_REPORT',
      '$BASE_URL/$id/generate',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GENERATE_SITE_REPORT',
      '$BASE_URL/$id/generate',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Site report generation failed')),
    );
  }
  OneContext().hideProgressIndicator();
  return result;
}
