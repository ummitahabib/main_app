import 'dart:developer';
import 'dart:io';

import 'package:smat_crow/features/organisation/data/models/batch_by_id.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/network/crow/models/request/create_batch.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

Pandora _pandora = Pandora();

class BatchRepository {
  Future<RequestRes> getBatchesInSector(String sectorId) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/org/batches/sectors/$sectorId");
      final List<BatchById> emp = response.map<BatchById>((e) => BatchById.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_SECTOR_BATCHES',
        '$BASE_URL/org/batches/sectors/$sectorId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: emp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SECTOR_BATCHES',
        '$BASE_URL/org/batches/sectors/$sectorId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getBatchById(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/org/batches/$id");

      final resp = BatchById.fromJson(response);
      _pandora.logAPIEvent(
        'GET_BATCH_BY_ID',
        '$BASE_URL/org/batches/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_BATCH_BY_ID',
        '$BASE_URL/org/batches/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateBatch(String id, Map<String, dynamic> data) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put("/org/batches/$id/update", data: data);

      final resp = BatchById.fromJson(response);
      _pandora.logAPIEvent(
        'UPDATE_BATCH',
        '$BASE_URL/org/batches/$id/update',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_BATCH',
        '$BASE_URL/org/batches/$id/update',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> deleteBatch(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete("/org/batches/$id/delete");

      _pandora.logAPIEvent(
        'DELETE_BATCH',
        '$BASE_URL/org/batches/$id/delete',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'DELETE_BATCH',
        '$BASE_URL/org/batches/$id/delete',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> createBatch(CreateBatchRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post("/org/batches", data: request.toJson());
      final resp = BatchById.fromJson(response);
      _pandora.logAPIEvent(
        'CREATE_BATCH',
        '$BASE_URL/org/batches',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      log(response.toString());
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'CREATE_BATCH',
        '$BASE_URL/org/batches',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getBatchAnalysisType(
    String batchId,
    String analysisType,
  ) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/org/batches/$batchId/analysis/$analysisType");
      final resp = BatchById.fromJson(response);
      _pandora.logAPIEvent(
        'GET_BATCH_ANALYSIS_TYPE',
        '$BASE_URL/org/batches/$batchId/analysis/$analysisType',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      log(response.toString());
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_BATCH_ANALYSIS_TYPE',
        '$BASE_URL/org/batches/$batchId/analysis/$analysisType',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> uploadBatch(String id, Map<String, dynamic> data) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.upload("/org/batches/$id/uploads", data: data);

      _pandora.logAPIEvent(
        'UPLOAD_BATCH',
        '$BASE_URL/org/batches/$id/uploads',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPLOAD_BATCH',
        '$BASE_URL/org/batches/$id/uploads',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
