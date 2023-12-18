import 'dart:developer';
import 'dart:io';

import 'package:smat_crow/network/crow/models/request/create_sector.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/features/organisation/data/models/sector_by_id.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

Pandora _pandora = Pandora();

class SectorRepository {
  Future<RequestRes> getSectorInSite(String siteId) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get("/org/sectors/sites/$siteId");
      final List<SectorById> emp = response.map<SectorById>((e) => SectorById.fromJson(e)).toList();
      _pandora.logAPIEvent(
        'GET_SITE_SECTORS',
        '$BASE_URL/org/sectors/sites/$siteId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );

      return RequestRes(response: emp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SITE_SECTORS',
        '$BASE_URL/org/sectors/sites/$siteId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getSectorById(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get("/org/sectors/$id");

      final resp = SectorById.fromJson(response);
      _pandora.logAPIEvent(
        'GET_SECTOR_BY_ID',
        '$BASE_URL/org/sectors/$id',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SECTOR_BY_ID',
        '$BASE_URL/org/sectors/$id',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateSector(String id, Map<String, dynamic> data) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.put("/org/sectors/$id/update", data: data);

      final resp = SectorById.fromJson(response);
      _pandora.logAPIEvent(
        'UPDATE_SECTOR',
        '$BASE_URL/org/sectors/$id/update',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'UPDATE_SECTOR',
        '$BASE_URL/org/sectors/$id/update',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> deleteSector(String id) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.delete("/org/sectors/$id/delete");

      _pandora.logAPIEvent(
        'DELETE_SECTOR',
        '$BASE_URL/org/sectors/$id/delete',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'DELETE_SECTOR',
        '$BASE_URL/org/sectors/$id/delete',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> createSector(CreateSectorRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post("/org/sectors", data: request.toJson());
      final resp = SectorById.fromJson(response);
      _pandora.logAPIEvent(
        'CREATE_SECTOR',
        '$BASE_URL/org/sectors',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      log(response.toString());
      return RequestRes(response: resp);
    } catch (e) {
      _pandora.logAPIEvent(
        'CREATE_SECTOR',
        '$BASE_URL/org/sectors',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
