import 'dart:io';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/features/organisation/data/models/soil_history.dart';
import 'package:smat_crow/features/organisation/data/models/weather_history.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/service_locator.dart';

Pandora _pandora = Pandora();

class WeatherSoilRepository {
  Future<RequestRes> getCurrentSoilInfo(String polygonId) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/smatagro/get-current-soil-data/$polygonId",
      );

      final data = SoilHistory.fromJson(response);

      _pandora.logAPIEvent(
        'GET_CURRENT_SOIL_INFORMATION',
        '$BASE_URL/smatagro/get-current-soil-data/$polygonId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: data);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_CURRENT_SOIL_INFORMATION',
        '$BASE_URL/smatagro/get-current-soil-data/$polygonId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getSoilHistory(String polygonId, DateTime start, DateTime end) async {
    final client = locator.get<ApiClient>();
    final currDt = end.toUtc().millisecondsSinceEpoch ~/ 1000;
    final prevDate = start.toUtc().millisecondsSinceEpoch ~/ 1000;
    try {
      final List response = await client.get(
        "/smatagro/get-current-soil-data/$prevDate/$currDt/$polygonId",
      );

      final data = response.map((e) => SoilHistory.fromJson(e)).toList();

      _pandora.logAPIEvent(
        'GET_SOIL_HISTORY',
        '$BASE_URL/smatagro/get-current-soil-data/$prevDate/$currDt/$polygonId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: data);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_SOIL_HISTORY',
        '$BASE_URL/smatagro/get-current-soil-data/$prevDate/$currDt/$polygonId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getWeatherHistory(String polygonId, DateTime start, DateTime end) async {
    final client = locator.get<ApiClient>();
    final currDt = end.toUtc().millisecondsSinceEpoch ~/ 1000;
    final prevDate = start.toUtc().millisecondsSinceEpoch ~/ 1000;
    try {
      final List response = await client.get(
        "/smatagro/get-geolocation-weather-hist/$prevDate/$currDt/$polygonId",
      );

      final data = response.map((e) => WeatherHistory.fromJson(e)).toList();

      _pandora.logAPIEvent(
        'GET_WEATHER_HISTORY',
        '$BASE_URL/smatagro/get-geolocation-weather-hist/$prevDate/$currDt/$polygonId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: data);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_WEATHER_HISTORY',
        '$BASE_URL/smatagro/get-geolocation-weather-hist/$prevDate/$currDt/$polygonId',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getWeatherForecast(LatLng latLng) async {
    final client = locator.get<ApiClient>();
    try {
      final List response = await client.get(
        "/smatagro/get-geolocation-forecast/${latLng.latitude}/${latLng.longitude}",
      );

      final data = response.map((e) => WeatherHistory.fromJson(e)).toList();

      _pandora.logAPIEvent(
        'GET_WEATHER_FORECAST',
        '$BASE_URL/smatagro/get-geolocation-forecast/${latLng.latitude}/${latLng.longitude}',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: data);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_WEATHER_FORECAST',
        '$BASE_URL/smatagro/get-geolocation-forecast/${latLng.latitude}/${latLng.longitude}',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> getCurrentWeatherInfo(LatLng latLng) async {
    final client = locator.get<ApiClient>();
    try {
      final response = await client.get(
        "/smatagro/get-current-geolocation-weather/${latLng.latitude}/${latLng.longitude}",
      );

      final data = WeatherHistory.fromJson(response);

      _pandora.logAPIEvent(
        'GET_HOURLY_WEATHER_FORECAST',
        '$BASE_URL/smatagro/get-current-geolocation-weather/${latLng.latitude}/${latLng.longitude}',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: data);
    } catch (e) {
      _pandora.logAPIEvent(
        'GET_HOURLY_WEATHER_FORECAST',
        '$BASE_URL/smatagro/get-current-geolocation-weather/${latLng.latitude}/${latLng.longitude}',
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
