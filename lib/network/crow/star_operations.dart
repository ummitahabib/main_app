import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/missions_for_agent_response.dart';
import 'package:smat_crow/network/crow/models/request/create_soil_samples.dart';
import 'package:smat_crow/network/crow/models/sample_report_response.dart';
import 'package:smat_crow/network/crow/models/star_mission_by_id_response.dart';
import 'package:smat_crow/network/crow/models/star_missions_by_site_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'models/request/create_star_mission_request.dart';

Pandora _pandora = Pandora();

Future<List<GetMissionsInSite>> getMissionsInSite(String siteId) async {
  debugPrint('getting mission in site $siteId');
  List<GetMissionsInSite> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/smatstar/missions/sites/$siteId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_MISSIONS_IN_SITE',
      '$BASE_URL/smatstar/missions/site/$siteId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<GetMissionsInSite>.from(
      jsonDecode(response.body).map((model) => GetMissionsInSite.fromJson(model)),
    );
    //return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_MISSIONS_IN_SITE',
      '$BASE_URL/smatstar/missions/site/$siteId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_MISSIONS_IN_SITE',
      '$BASE_URL/smatstar/missions/site/$siteId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetMissionById?> getMissionById(String missionId) async {
  debugPrint('getting mission by id');
  GetMissionById? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/smatstar/missions/$missionId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_MISSIONS_IN_SITE',
      '$BASE_URL/missions/$missionId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetMissionById.fromJson(jsonDecode(response.body));
    //   return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_MISSIONS_IN_SITE',
      '$BASE_URL/missions/$missionId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_MISSIONS_IN_SITE',
      '$BASE_URL/missions/$missionId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<GetSampleReport?> downloadSampleReport(String sampleId) async {
  await OneContext().showProgressIndicator();
  debugPrint('downloading sample report by id');
  GetSampleReport? result;
  final response = await http.post(
    Uri.parse('$BASE_URL/smatstar/results/samples/$sampleId/generateresults'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    OneContext().hideProgressIndicator();
    _pandora.logAPIEvent(
      'DOWNLOAD_SAMPLE_REPORT',
      '$BASE_URL/samples/missions/$sampleId/download/',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = GetSampleReport.fromJson(jsonDecode(response.body));
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    OneContext().hideProgressIndicator();
    _pandora.logAPIEvent(
      'DOWNLOAD_SAMPLE_REPORT',
      '$BASE_URL/samples/missions/$sampleId/download/',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'DOWNLOAD_SAMPLE_REPORT',
      '$BASE_URL/samples/missions/$sampleId/download/',
      'FAILED',
      response.statusCode.toString(),
    );
    OneContext().hideProgressIndicator();
  }
  return result;
}

Future<bool> requestMissionForSite(CreateMissionRequest request) async {
  debugPrint('create mission for user ${request.name}');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/smatstar/missions'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
    body: jsonEncode(<String, String>{
      'name': request.name,
      'description': request.description,
      'organization': request.organization,
      'site': request.site,
    }),
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'REQUEST_MISSION_FOR_SITE',
      '$BASE_URL/smatstar/missions',
      HttpStatus.ok.toString(),
      HttpStatus.created.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Mission Requested'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'REQUEST_MISSION_FOR_SITE',
      '$BASE_URL/smatstar/missions',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'REQUEST_MISSION_FOR_SITE',
      '$BASE_URL/smatstar/missions',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}

Future<List<GetMissionsForAgent>> getStarMissionsForAgent(
  String agentId,
) async {
  debugPrint('getting mission by agent id');
  List<GetMissionsForAgent> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/smatstar/missions/agents/$agentId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_MISSIONS_FOR_AGENT',
      '$BASE_URL/smatstar/missions/agents/$agentId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<GetMissionsForAgent>.from(
      jsonDecode(response.body).map((model) => GetMissionsForAgent.fromJson(model)),
    );
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_MISSIONS_FOR_AGENT',
      '$BASE_URL/smatstar/missions/agents/$agentId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_MISSIONS_FOR_AGENT',
      '$BASE_URL/smatstar/missions/agents/$agentId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<bool> createSoilSample(CreateSoilSamples request) async {
  debugPrint('create sample for site ${request.name}');
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/smatstar/samples'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
    body: jsonEncode(<String, dynamic>{
      'name': request.name,
      'coordinate': request.coordinate,
      'soilType': request.soilType,
      'sampleDepth': request.sampleDepth,
      'mission': request.mission,
      'site': request.site,
    }),
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    _pandora.logAPIEvent(
      'CREATE_SOIL_SAMPLE',
      '$BASE_URL/samples/missions',
      HttpStatus.ok.toString(),
      HttpStatus.created.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Sample Registered'),
        backgroundColor: Colors.green,
      ),
    );
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'CREATE_SOIL_SAMPLE',
      '$BASE_URL/samples/missions',
      "FAILED",
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'CREATE_SOIL_SAMPLE',
      '$BASE_URL/samples/missions',
      "FAILED",
      response.statusCode.toString(),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}
