import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/feeds/models/paginated_plants_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';

import '../models/plant_details_by_id_response.dart';
import '../models/planted_response.dart';
import '../models/suninness_response.dart';

Pandora _pandora = Pandora();

Future<List<dynamic>> getPopularPlants() async {
  List<dynamic> result = [];
  final response = await http.get(
    Uri.parse('$GROW_STUFF_BASE_URL/crops.json'),
  );

  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_POPULAR_PLANTS',
      '$GROW_STUFF_BASE_URL/crops.json',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = jsonDecode(response.body);
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_POPULAR_PLANTS',
      '$GROW_STUFF_BASE_URL/crops.json',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_POPULAR_PLANTS',
      '$GROW_STUFF_BASE_URL/crops.json',
      'FAILED',
      response.statusCode.toString(),
    );
  }

  return result;
}

Future<PaginatedPlantsResponse?> getPaginatedPlants(int pageKey) async {
  PaginatedPlantsResponse? result;
  final response = await http.get(
    Uri.parse(
      '$GROW_STUFF_V1_BASE_URL/crops?page%5Blimit%5D=10&page%5Boffset%5D=$pageKey',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_PAGINATED_DETAILS',
      '$GROW_STUFF_V1_BASE_URL/crops?page%5Blimit%5D=10&page%5Boffset%5D=$pageKey',
      response.statusCode.toString(),
      response.statusCode.toString(),
    );
    result = PaginatedPlantsResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_PAGINATED_DETAILS',
      '$GROW_STUFF_V1_BASE_URL/crops?page%5Blimit%5D=10&page%5Boffset%5D=$pageKey',
      'FAILED',
      response.statusCode.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_PAGINATED_DETAILS',
      '$GROW_STUFF_V1_BASE_URL/crops?page%5Blimit%5D=10&page%5Boffset%5D=$pageKey',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<dynamic> getPlantDetailsById(String plantId) async {
  dynamic result;
  final response = await http.get(
    Uri.parse('$GROW_STUFF_BASE_URL/crops/$plantId.json'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_PLANT_DETAILS_BY_ID',
      '$GROW_STUFF_BASE_URL/crops/$plantId.json',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = jsonDecode(response.body);
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_PLANT_DETAILS_BY_ID',
      '$GROW_STUFF_BASE_URL/crops/$plantId.json',
      'FAILED',
      response.statusCode.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_PLANT_DETAILS_BY_ID',
      '$GROW_STUFF_BASE_URL/crops/$plantId.json',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<PlantDetailResponse?> getPlantDetailsForItem(String plantId) async {
  PlantDetailResponse? result;
  final response = await http.get(
    Uri.parse('$GROW_STUFF_BASE_URL/crops/$plantId.json'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_PLANT_DETAILS_FOR_ITEM',
      '$GROW_STUFF_BASE_URL/crops/$plantId.json',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = PlantDetailResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_PLANT_DETAILS_FOR_ITEM',
      '$GROW_STUFF_BASE_URL/crops/$plantId.json',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_PLANT_DETAILS_FOR_ITEM',
      '$GROW_STUFF_BASE_URL/crops/$plantId.json',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<PlantedResponse?> getPlantingRequirements(String plantId) async {
  PlantedResponse? result;
  final response = await http.get(
    Uri.parse('$GROW_STUFF_BASE_URL/crops/$plantId/planted_from.json'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_SUN_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/sunniness.json',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = PlantedResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_PLANTING_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/planted_from.json',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_PLANTING_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/planted_from.json',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<SunninessResponse?> getSunRequirements(String plantId) async {
  SunninessResponse? result;
  final response = await http.get(
    Uri.parse('$GROW_STUFF_BASE_URL/crops/$plantId/sunniness.json'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_SUN_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/sunniness.json',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = SunninessResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_SUN_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/sunniness.json',
      'FAILED',
      response.statusCode.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_SUN_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/sunniness.json',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<dynamic> getHarvestRequirements(String plantId) async {
  dynamic result;
  final response = await http.get(
    Uri.parse('$GROW_STUFF_BASE_URL/crops/$plantId/harvested_for.json'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_HARVEST_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/harvested_for.json',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = response;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_HARVEST_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/harvested_for.json',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_HARVEST_REQUIREMENTS',
      '$GROW_STUFF_BASE_URL/crops/$plantId/harvested_for.json',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}
