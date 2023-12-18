import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/plant_canopy_response.dart';
import 'package:smat_crow/network/crow/models/plant_count_response.dart';
import 'package:smat_crow/network/crow/models/weed_count_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/api_client.dart';

import 'models/farm_probe_response.dart';

Pandora _pandora = Pandora();

Future<WeedCountResponse?> getWeedCountInBatch(String orthoPhotoId) async {
  debugPrint('getting weed count');
  WeedCountResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=weedcount',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_WEED_COUNT_IN_BATCH',
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=weedcount',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = WeedCountResponse.fromJson(jsonDecode(response.body));

    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_WEED_COUNT_IN_BATCH',
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=weedcount',
      HttpStatus.unauthorized.toString(),
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  }
  return result;
}

Future<PlantCountResponse?> getPlantCountInBatch(String orthoPhotoId) async {
  debugPrint('getting plant count');
  PlantCountResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=plantcount',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_PLANT_COUNT_IN_BATCH',
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=plantcount',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = PlantCountResponse.fromJson(jsonDecode(response.body));

    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_PLANT_COUNT_IN_BATCH',
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=plantcount',
      HttpStatus.unauthorized.toString(),
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  }
  return result;
}

Future<PlantCanopyResponse?> getPlantCanopyInBatch(String orthoPhotoId) async {
  debugPrint('getting plant canopy');
  PlantCanopyResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=plantcanopy',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_PLANT_CANOPY',
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=plantcanopy',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = PlantCanopyResponse.fromJson(jsonDecode(response.body));

    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_PLANT_CANOPY',
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=plantcanopy',
      HttpStatus.unauthorized.toString(),
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  }
  return result;
}

Future<PlantCanopyResponse?> detectPlantDisease(String orthoPhotoId) async {
  debugPrint('getting plant canopy');
  PlantCanopyResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/sector/orthophoto/$orthoPhotoId/analysis?analysistype=plantcanopy',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    result = PlantCanopyResponse.fromJson(jsonDecode(response.body));

    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  }
  return result;
}

Future<List<FarmProbeResponse>> predictPlantLeaf(String imagePath) async {
  debugPrint('result:$imagePath');
  debugPrint(Session.SessionToken);
  List<FarmProbeResponse> result = [];
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('${ApiClient.farmProbe}/farmprobe/predict'),
  );
  request.headers['Authorization'] = "Bearer ${Session.SessionToken}";
  if (kIsWeb) {
    request.files.add(
      http.MultipartFile.fromString(
        'uploadImage',
        imagePath,
        filename: imagePath.split("/").last,
        contentType: MediaType("image", "jpg"),
      ),
    );
  } else {
    request.files.add(
      await http.MultipartFile.fromPath(
        'uploadImage',
        imagePath,
        filename: imagePath.split("/").last,
        contentType: MediaType("image", "jpg"),
      ),
    );
  }

  final response = await request.send();
  final res = await http.Response.fromStream(response);

  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'DETECT_PLANT_DISEASE',
      '${ApiClient.farmProbe}/farmprobe/predict-app',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    log(jsonDecode(res.body).toString());
    result = List<FarmProbeResponse>.from(
      jsonDecode(res.body)["response"]['message'].map((model) => FarmProbeResponse.fromJson(model)),
    );
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'DETECT_PLANT_DISEASE',
      '$BASE_URL/farmprobe/predict-app',
      HttpStatus.unauthorized.toString(),
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'DETECT_PLANT_DISEASE',
      '$BASE_URL/farmprobe/predict-app',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}
