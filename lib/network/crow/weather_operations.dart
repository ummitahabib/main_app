import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/soil_history_response.dart';
import 'package:smat_crow/network/crow/models/weather_forecast_response.dart';
import 'package:smat_crow/network/crow/models/weather_history_response.dart';
import 'package:smat_crow/network/crow/models/weather_hourly_forecast_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

Pandora _pandora = Pandora();

Future<WeatherHistoryResponse?> getWeatherHistory(
  String polygonId,
  String startDate,
  String endDate,
) async {
  WeatherHistoryResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/smatsat/weather/getwetherhistory?tempFarmAttId=$polygonId&startdate=$startDate&enddate=$endDate',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_WEATHER_HISTORY',
      '$BASE_URL/smatsat/weather/getwetherhistory?tempFarmAttId=$polygonId&startdate=$startDate&enddate=$endDate',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = WeatherHistoryResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_WEATHER_HISTORY',
      '$BASE_URL/smatsat/weather/getwetherhistory?tempFarmAttId=$polygonId&startdate=$startDate&enddate=$endDate',
      HttpStatus.unauthorized.toString(),
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  }
  return result;
}

Future<WeatherForecastResponse?> getWeatherForecast(String polygonId) async {
  WeatherForecastResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/smatsat/weather/getwetherforecast?tempFarmAttId=$polygonId',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_WEATHER_FORECAST',
      '$BASE_URL/smatsat/weather/getwetherforecast?tempFarmAttId=$polygonId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = WeatherForecastResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_WEATHER_FORECAST',
      '$BASE_URL/smatsat/weather/getwetherforecast?tempFarmAttId=$polygonId',
      HttpStatus.unauthorized.toString(),
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  }
  return result;
}

Future<HourlyWeatherForecast?> getHourlyWeatherForecast(String polygonId) async {
  HourlyWeatherForecast? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/smatsat/weather/gethourlyweatherhistory?tempFarmAttId=$polygonId',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_HOURLY_WEATHER_FORECAST',
      '$BASE_URL/smatsat/weather/gethourlyweatherhistory?tempFarmAttId=$polygonId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = HourlyWeatherForecast.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_HOURLY_WEATHER_FORECAST',
      '$BASE_URL/smatsat/weather/gethourlyweatherhistory?tempFarmAttId=$polygonId',
      HttpStatus.unauthorized.toString(),
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  }
  return result;
}

Future<SoilHistoryResponse?> getSoilHistory(
  String polygonId,
  String startDate,
  String endDate,
) async {
  SoilHistoryResponse? result;
  final response = await http.get(
    Uri.parse(
      '$BASE_URL/smatsat/soil/getsoilinfo?tempFarmAttId=$polygonId&startDate=$startDate&endDate=$endDate',
    ),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_SOIL_HISTORY',
      '$BASE_URL/smatsat/soil/getsoilinfo?tempFarmAttId=$polygonId&startDate=$startDate&endDate=$endDate',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = SoilHistoryResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_SOIL_HISTORY',
      '$BASE_URL/smatsat/soil/getsoilinfo?tempFarmAttId=$polygonId&startDate=$startDate&endDate=$endDate',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_SOIL_HISTORY',
      '$BASE_URL/smatsat/soil/getsoilinfo?tempFarmAttId=$polygonId&startDate=$startDate&endDate=$endDate',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}
