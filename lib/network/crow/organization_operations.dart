import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/organizations_response.dart';
import 'package:smat_crow/network/crow/models/request/create_organization.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'models/organization_by_id_response.dart';

Pandora _pandora = Pandora();

Future<List<GetUserOrganizations>> getUserOrganizations() async {
  debugPrint('getting organizations');
  List<GetUserOrganizations> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/org/organizations/users/$USER_ID'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_USER_ORGANIZATIONS',
      '$BASE_URL/org/organizations/users/$USER_ID',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<GetUserOrganizations>.from(
      jsonDecode(response.body).map((model) => GetUserOrganizations.fromJson(model)),
    );
    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_USER_ORGANIZATIONS',
      '$BASE_URL/org/organizations/users/$USER_ID',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_USER_ORGANIZATIONS',
      '$BASE_URL/org/organizations/users/$USER_ID',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetOrganizationById?> getUserOrganizationsById(
  String organizationId,
) async {
  debugPrint('getting organizations by Id');
  GetOrganizationById? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/org/organizations/$organizationId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_USER_ORGANIZATIONS_BY_ID',
      '$BASE_URL/org/organizations/$organizationId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetOrganizationById.fromJson(jsonDecode(response.body));
    //return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_USER_ORGANIZATIONS_BY_ID',
      '$BASE_URL/org/organizations/$organizationId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_USER_ORGANIZATIONS_BY_ID',
      '$BASE_URL/organization/$organizationId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<bool> createOrganizationForUser(
  CreateOrganizationRequest request,
) async {
  debugPrint('create organization for user');
  await OneContext().showProgressIndicator();
  bool result = false;
  final response = await http.post(
    Uri.parse('$BASE_URL/org/organizations'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
    body: jsonEncode(<String, String>{
      'name': request.name,
      'longDescription': request.longDescription,
      'shortDescription': request.shortDescription,
      "image": DEFAULT_IMAGE,
      'address': request.address,
      'industry': request.industry,
      'user': request.user
    }),
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'CREATE_ORG_FOR_USER',
      '$BASE_URL/org/organizations',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = true;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Organization Created'),
        backgroundColor: Colors.green,
      ),
    );
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'CREATE_ORG_FOR_USER',
      '$BASE_URL/org/organizations',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'CREATE_ORGANIZATION_FOR_USER',
      '$BASE_URL/org/organizations',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}
