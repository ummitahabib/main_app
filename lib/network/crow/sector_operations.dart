import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/request/create_sector.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'models/sector_by_id_response.dart';
import 'models/sector_response.dart';

Pandora _pandora = Pandora();

Future<List<GetOrganizationSectors>> getSectorsForSite(String siteId) async {
  debugPrint('getting Sectors');
  List<GetOrganizationSectors> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/org/sectors/sites/$siteId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_SECTORS_FOR_SITE',
      '$BASE_URL/org/sectors/sites/$siteId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<GetOrganizationSectors>.from(
      jsonDecode(response.body).map((model) => GetOrganizationSectors.fromJson(model)),
    );

    ///  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_SECTORS_FOR_SITE',
      '$BASE_URL/org/sectors/sites/$siteId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_SECTORS_FOR_SITE',
      '$BASE_URL/org/sectors/sites/$siteId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetSectorById?> getSectorById(String sectorId) async {
  debugPrint('getting Sectors by Id');
  GetSectorById? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/org/sectors/$sectorId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_SECTORS_BY_ID',
      '$BASE_URL/org/sectors/$sectorId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetSectorById.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_SECTORS_BY_ID',
      '$BASE_URL/org/sectors/$sectorId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_SECTORS_BY_ID',
      '$BASE_URL/org/sectors/$sectorId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<bool> createSectorForSite(CreateSectorRequest request) async {
  debugPrint('create sector for site');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/org/sectors'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
    body: jsonEncode(<String, dynamic>{
      'name': request.name,
      'description': request.description,
      'sectorCoordinates': request.sectorCoordinates,
      'site': request.site
    }),
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'CREATE_SECTOR_FOR_SITE',
      '$BASE_URL/org/sectors',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Sector Created'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'CREATE_SECTOR_FOR_SITE',
      '$BASE_URL/org/sectors',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'CREATE_SECTOR_FOR_SITE',
      '$BASE_URL/org/sectors',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}
