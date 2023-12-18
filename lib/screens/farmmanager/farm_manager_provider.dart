// ignore_for_file: prefer_final_locals

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/organizations_response.dart';
import 'package:smat_crow/network/crow/models/soil_history_response.dart' as histor;
import 'package:smat_crow/network/crow/models/weather_forecast_response.dart' as forecast;
import 'package:smat_crow/network/crow/models/weather_history_response.dart' as history;
import 'package:smat_crow/network/crow/organization_operations.dart';
import 'package:smat_crow/screens/farmmanager/widgets/organizations_item.dart';
import 'package:smat_crow/screens/farmmanager/widgets/star_grid_item.dart';
import 'package:smat_crow/screens/farmmanager/widgets/weekly_forecast_item.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../../hive/implementation/organizations_impl.dart';
import '../../network/crow/industries_operations.dart';
import '../../network/crow/models/industries_response.dart';
import '../../network/crow/models/site_by_id_response.dart';
import '../../network/crow/sites_operations.dart';
import '../../network/crow/star_operations.dart';
import '../../network/crow/weather_operations.dart';
import '../../pandora/pandora.dart';

class FarmManagerProvider extends ChangeNotifier {
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  final AsyncMemoizer _siteAsyncMemoizer = AsyncMemoizer();
  final AsyncMemoizer _historyAsyncMemoizer = AsyncMemoizer();
  final AsyncMemoizer _forecastAsyncMemoizer = AsyncMemoizer();
  final AsyncMemoizer _getIndustriesAsync = AsyncMemoizer();
  final AsyncMemoizer _organizationsAsync = AsyncMemoizer();
  bool loading = true;
  List<Widget> organizations = [];
  String organizationId = emptyString, organizationName = emptyString;
  int siteCount = 0;
  bool clickedOrganization = false;
  OrganizationsImpl store = OrganizationsImpl();

  List<GetIndustriesResponse> industries = [];
  GetIndustriesResponse? industry;

  GetSiteById? siteData;
  history.WeatherHistoryResponse? weatherData;
  forecast.WeatherForecastResponse? wkForecastData;
  Pandora pandora = Pandora();
  List<Widget> wkForecast = [];
  List<history.Datum> weatherInfo = [];

  // GetMissionsInSite? siteMissionsData;
  List<Widget> siteAnalysisItems = [];
  String missionId = emptyString, siteName = emptyString, missionName = emptyString;
  bool clickedMission = false;
  histor.SoilHistoryResponse? soilData;

  List<histor.Datum> soilInfo = [];

  bool get mounted => false;

  void _updateOrganizationId(
    String id,
    String name,
    int count,
    bool isTapped,
    widget,
  ) {
    organizationId = id;
    organizationName = name;
    siteCount = count;
    clickedOrganization = isTapped;
    widget.getSelectedId(
      organizationId,
      organizationName,
      siteCount,
      clickedOrganization,
    );
    notifyListeners();
  }

  Future getSignedInUserOganizations() async {
    return _organizationsAsync.runOnce(() async {
      final organizationData = await getUserOrganizations();
      List<Widget> organizationItem = [];
      if (organizationData.isNotEmpty) {
        for (final organization in organizationData) {
          await addOrganization(organization);

          // organizationItem.add(
          //   // OrganizationsItem(
          //   //   organizationName: organization.name,
          //   //   siteCount: organization.sites.length,
          //   //   organizationId: organization.id,
          //   //   isDummy: false,
          //   //   getSelectedId: _updateOrganizationId,
          //   // ),
          // );
        }
        for (int i = 0; i < 3; i++) {
          organizationItem.add(
            OrganizationsItem(
              organizationName: emptyString,
              siteCount: 0,
              organizationId: emptyString,
              isDummy: true,
              getSelectedId: _updateOrganizationId,
            ),
          );
        }
        if (mounted) {
          organizations = organizationItem;
          notifyListeners();
        }
      } else {
        for (int i = 0; i < 4; i++) {
          organizationItem.add(
            OrganizationsItem(
              organizationName: emptyString,
              siteCount: 0,
              organizationId: emptyString,
              isDummy: true,
              getSelectedId: _updateOrganizationId,
            ),
          );
        }
        if (mounted) {
          organizations = organizationItem;
          notifyListeners();
        }
      }
      return organizationData;
    });
  }

  Future<void> addOrganization(GetUserOrganizations organization) async {
    //   await store.insertOrganization(
    //     OrganizationsEntity(
    //       organization.id,
    //       organization.name,
    //       organization.longDescription,
    //       organization.shortDescription,
    //       organization.name,
    //       organization.address,
    //       organization.industry,
    //       organization.user,
    //       0,
    //     ),
    //   );
    // }

    Future getAllIndustries() async {
      return _getIndustriesAsync.runOnce(() async {
        final industryData = await getIndustriesResponse();
        if (industryData.isNotEmpty) {
          industries = industryData;
          notifyListeners();
        }
      });
    }

    Future getSiteDetails(String siteId) async {
      return _siteAsyncMemoizer.runOnce(() async {
        final data = await getSiteById(siteId);
        if (mounted) {
          siteData = data;
          notifyListeners();
          // await getWeeklyForecastInformation(
          //   siteData!.docktarPolygonId.toString(),
          // );
        }
      });
    }

    Future getWeatherHistoryInformation(String polygonKey) async {
      final currDt = DateTime.now();
      final prevDate = DateTime.now().subtract(const Duration(days: 30));
      return _historyAsyncMemoizer.runOnce(() async {
        final data = await getWeatherHistory(
          polygonKey,
          '${prevDate.year}-${prevDate.month}-${prevDate.day}',
          '${currDt.year}-${currDt.month}-${currDt.day}',
        );
        if (mounted) {
          weatherData = data;
          weatherInfo = weatherData!.data!.data!;
          notifyListeners();
        }
      });
    }

    Future getWeeklyForecastInformation(String polygonKey) async {
      return _forecastAsyncMemoizer.runOnce(() async {
        final weeklyForecast = await getWeatherForecast(
          polygonKey,
        );

        List<Widget> forecastItem = [];

        if (weeklyForecast != null && weeklyForecast.data!.data!.isNotEmpty) {
          for (final forecast in weeklyForecast.data!.data!) {
            forecastItem.add(
              WeeklyForecastItem(
                CloudCover: forecast.cloudCover,
                DataCalculationDate: forecast.dataCalculationDate,
                Description: forecast.description,
                ForecastDate: forecast.forecastDate,
                Icon: forecast.icon,
                MaxTemperature: forecast.maxTemperature,
                MinTemperature: forecast.minTemperature,
                PressureSea: forecast.pressureSea,
                RelativeHumidity: forecast.relativeHumidity,
                UVI: forecast.uvi,
                WeatherStatus: forecast.weatherStatus,
                WindDirection: forecast.windDirection,
                WindSpeed: forecast.windSpeed,
              ),
            );
          }
          if (mounted) {
            wkForecast = forecastItem;
            notifyListeners();
          }
        } else {
          for (int i = 0; i < 4; i++) {
            forecastItem.add(
              Container(
                height: 150,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[350],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
          if (mounted) {
            wkForecast = forecastItem;
            notifyListeners();
          }
        }
        return weeklyForecast;
      });
    }

    void _updateMissionId(String id, bool isTapped, widget) {
      missionId = id;
      clickedMission = isTapped;
      widget.getSelectedId(missionId, clickedMission);
      notifyListeners();
    }

    Future getSiteMissions(String siteId, dynamic widget) async {
      return _asyncMemoizer.runOnce(() async {
        final missionData = await getMissionsInSite(siteId);
        List<Widget> missionItem = [];

        if (missionData.isNotEmpty) {
          for (final mission in missionData) {
            missionItem.add(
              StarGridItem(
                isDummy: false,
                description: mission.description!,
                inProgress: mission.progress!,
                missionId: mission.id!,
                siteId: mission.site!,
                name: mission.name!,
                organizationId: widget.organizationId,
                getSelectedId: _updateMissionId,
              ),
            );
          }
          for (int i = 0; i < 3; i++) {
            missionItem.add(
              StarGridItem(
                isDummy: true,
                description: emptyString,
                inProgress: emptyString,
                missionId: emptyString,
                name: emptyString,
                siteId: widget.siteId,
                organizationId: widget.organizationId,
                getSelectedId: _updateMissionId,
              ),
            );
          }
          if (mounted) {
            siteAnalysisItems = missionItem;
            notifyListeners();
          }
        } else {
          for (int i = 0; i < 8; i++) {
            missionItem.add(
              StarGridItem(
                name: emptyString,
                isDummy: true,
                description: emptyString,
                inProgress: emptyString,
                missionId: emptyString,
                siteId: widget.siteId,
                organizationId: widget.organizationId,
              ),
            );
          }

          if (mounted) {
            siteAnalysisItems = missionItem;
            notifyListeners();
          }
        }

        return missionData;
      });
    }

    Future getSoilHistoryInformation(String polygonKey) async {
      final currDt = DateTime.now();
      final prevDate = DateTime.now().subtract(const Duration(days: 30));
      return _historyAsyncMemoizer.runOnce(() async {
        final data = await getSoilHistory(
          polygonKey,
          '${prevDate.year}-${prevDate.month}-${prevDate.day}',
          '${currDt.year}-${currDt.month}-${currDt.day}',
        );
        if (mounted) {
          soilData = data;
          soilInfo = soilData!.data!.data!;
        }
      });
    }

    // Future getSiteDetails(String siteId) async {
    //   return _siteAsyncMemoizer.runOnce(() async {
    //     final data = await getSiteById(siteId);
    //     if (mounted) {
    //       siteData = data;

    //       await getSoilHistoryInformation(siteData!.docktarPolygonId.toString());
    //     }
    //   });
    // }
  }
}
