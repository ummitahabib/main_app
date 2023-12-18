import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/batch_by_id.dart';
import 'package:smat_crow/network/crow/models/batch_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'models/request/create_batch.dart';

Pandora _pandora = Pandora();

Future<List<GetSectorBatches>> getSectorBatches(String sectorId) async {
  debugPrint('getting batch in sector');
  List<GetSectorBatches> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/org/batches/sectors/$sectorId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_SECTOR_BATCHES',
      '$BASE_URL/org/batches/sectors/$sectorId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<GetSectorBatches>.from(
      jsonDecode(response.body).map((model) => GetSectorBatches.fromJson(model)),
    );
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_SECTOR_BATCHES',
      '$BASE_URL/org/batches/sectors/$sectorId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_SECTOR_BATCHES',
      '$BASE_URL/org/batches/sectors/$sectorId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetBatchById?> getBatchById(String batchId) async {
  debugPrint('getting batch by id');
  GetBatchById? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/org/batches/$batchId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_BATCHES_BY_ID',
      '$BASE_URL/org/batches/$batchId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetBatchById.fromJson(jsonDecode(response.body));
    return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_BATCHES_BY_ID',
      '$BASE_URL/org/batches/$batchId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_BATCHES_BY_ID',
      '$BASE_URL/org/batches/$batchId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<bool> createBatchForSector(CreateBatchRequest request) async {
  debugPrint('create batches for sector');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/org/batches'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
    body: jsonEncode(
      <String, dynamic>{'name': request.name, 'sector': request.sector},
    ),
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'CREATE_BATCH_IN_SECTOR',
      '$BASE_URL/org/batches',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Batch Created'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'CREATE_BATCH_IN_SECTOR',
      '$BASE_URL/org/batches',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'CREATE_BATCH_IN_SECTOR',
      '$BASE_URL/org/batches',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}
