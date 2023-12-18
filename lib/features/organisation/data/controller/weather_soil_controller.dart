import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/models/soil_history.dart';
import 'package:smat_crow/features/organisation/data/models/weather_history.dart';
import 'package:smat_crow/features/organisation/data/repository/weather_soil_repository.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';

final weatherSoilProvider = ChangeNotifierProvider<WeatherSoilNotifier>((ref) {
  return WeatherSoilNotifier(ref);
});

class WeatherSoilNotifier extends ChangeNotifier {
  final Ref ref;

  WeatherSoilNotifier(this.ref);
  final Pandora _pandora = Pandora();

  bool _loading = false;
  bool get loading => _loading;

  bool _loader = false;
  bool get loader => _loader;

  List<WeatherHistory> _weatherHistoryList = [];
  List<WeatherHistory> get weatherHistoryList => _weatherHistoryList;

  List<WeatherHistory> _weatherForecastList = [];
  List<WeatherHistory> get weatherForecastList => _weatherForecastList;

  WeatherHistory? _currentForecast;
  WeatherHistory? get currentForecast => _currentForecast;

  List<SoilHistory> _soilHistoryList = [];
  List<SoilHistory> get soilHistoryList => _soilHistoryList;

  SoilHistory? _soilHistory;
  SoilHistory? get soilHistory => _soilHistory;

  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  set loader(bool state) {
    _loader = state;
    notifyListeners();
  }

  set weatherHistoryList(List<WeatherHistory> list) {
    _weatherHistoryList = list;
    notifyListeners();
  }

  set weatherForecastList(List<WeatherHistory> list) {
    _weatherForecastList = list;
    notifyListeners();
  }

  set currentForecast(WeatherHistory? fore) {
    _currentForecast = fore;
    notifyListeners();
  }

  set soilHistoryList(List<SoilHistory> list) {
    _soilHistoryList = list;
    notifyListeners();
  }

  set soilHistory(SoilHistory? soil) {
    _soilHistory = soil;
    notifyListeners();
  }

  Future<void> getWeatherHistory(DateTime start, DateTime end) async {
    loading = true;
    try {
      final resp = await locator.get<WeatherSoilRepository>().getWeatherHistory(
            ref.read(siteProvider).site!.polygonId,
            start,
            end,
          );
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        weatherHistoryList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_WEATHER_HISTORY',
        '$BASE_URL/smatagro/get-geolocation-weather-hist',
        'FAILED',
        e.toString(),
      );
    }
  }

  Future<void> getWeatherForecast() async {
    loading = true;
    try {
      final resp =
          await locator.get<WeatherSoilRepository>().getWeatherForecast(ref.read(mapProvider).siteLatLng.first);
      loading = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        weatherForecastList = resp.response;
      }
    } catch (e) {
      loading = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_WEATHER_FORECAST',
        '$BASE_URL/smatagro/get-geolocation-forecast/',
        'FAILED',
        e.toString(),
      );
    }
  }

  Future<void> getCurrentWeatherInfo() async {
    loader = true;
    try {
      final resp =
          await locator.get<WeatherSoilRepository>().getCurrentWeatherInfo(ref.read(mapProvider).siteLatLng.first);
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        currentForecast = resp.response;
      }
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_currentLY_WEATHER_FORECAST',
        '$BASE_URL/smatagro/get-current-geolocation-weather/',
        'FAILED',
        e.toString(),
      );
    }
  }

  Future<void> getSoilHistory(DateTime start, DateTime end) async {
    loader = true;
    try {
      final resp = await locator.get<WeatherSoilRepository>().getSoilHistory(
            ref.read(siteProvider).site!.polygonId,
            start,
            end,
          );
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        soilHistoryList = resp.response;
      }
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SOIL_HISTORY',
        '$BASE_URL/smatagro/get-current-soil-data/',
        'FAILED',
        e.toString(),
      );
    }
  }

  Future<void> getCurrentSoilInfo() async {
    loader = true;
    try {
      final resp =
          await locator.get<WeatherSoilRepository>().getCurrentSoilInfo(ref.read(siteProvider).site!.polygonId);
      loader = false;
      if (resp.hasError()) {
        snackBarMsg(resp.error!.message);
      } else {
        soilHistory = resp.response;
      }
    } catch (e) {
      loader = false;
      snackBarMsg(e.toString());
      _pandora.logAPIEvent(
        'GET_SOIL_HISTORY',
        '$BASE_URL/smatagro/get-current-soil-data/',
        'FAILED',
        e.toString(),
      );
    }
  }
}
