import 'dart:io';

import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/network/crow/models/request/create_star_mission_request.dart';
import 'package:smat_crow/network/crow/models/sample_report_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

Pandora _pandora = Pandora();

class SiteOptionRepository {
  Future<RequestRes> requestSoilTestMission(CreateMissionRequest request) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post("/smatstar/missions", data: request.toJson());
      _pandora.logAPIEvent(
        'REQUEST_MISSION_FOR_SITE',
        '$BASE_URL/smatstar/missions',
        HttpStatus.ok.toString(),
        HttpStatus.created.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      _pandora.logAPIEvent(
        'REQUEST_MISSION_FOR_SITE',
        '$BASE_URL/smatstar/missions',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> downloadSampleReport(String sampleId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.post(
        '/smatstar/results/samples/$sampleId/generateresults',
      );

      final sample = GetSampleReport.fromJson(response);
      _pandora.logAPIEvent(
        'DOWNLOAD_SAMPLE_REPORT',
        '$BASE_URL/smatstar/results/samples/$sampleId/generateresults',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: sample);
    } catch (e) {
      _pandora.logAPIEvent(
        'DOWNLOAD_SAMPLE_REPORT',
        '$BASE_URL/smatstar/results/samples/$sampleId/generateresults',
        'FAILED',
        e.toString(),
      );
      return RequestRes(response: e.toString());
    }
  }
}
