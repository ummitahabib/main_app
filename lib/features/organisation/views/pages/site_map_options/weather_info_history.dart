import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/features/organisation/data/controller/weather_soil_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/chart_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';

class WeatherInfoHistory extends HookConsumerWidget {
  const WeatherInfoHistory({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weather = ref.watch(weatherSoilProvider);
    return HookConsumer(
      builder: (context, ref, child) {
        if (weather.loading) {
          return SizedBox(
            height: kIsWeb ? null : Responsive.yHeight(context, percent: 0.75),
            child: const GridLoader(arrangement: 1),
          );
        }
        if (weather.weatherHistoryList.isEmpty) {
          return const EmptyListWidget(text: noWeatherInfo);
        }
        return SizedBox(
          height: Responsive.yHeight(context, percent: kIsWeb ? 0.60 : 0.75),
          child: ListView(
            children: [
              ChartWidget(
                name: cloudCover,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), e.clouds.all.toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              ),
              ChartWidget(
                name: maxTemp,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), (e.main.tempMax - 273).toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              ),
              ChartWidget(
                name: minTemp,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), (e.main.tempMin - 273).toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              ),
              ChartWidget(
                name: precipitation,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), e.main.temp.toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              ),
              ChartWidget(
                name: seaPressure,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), e.main.pressure.toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              ),
              ChartWidget(
                name: relHumd,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), e.main.humidity.toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              ),
              ChartWidget(
                name: windDir,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), e.wind.deg.toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              ),
              ChartWidget(
                name: windSpeed,
                dataSource: weather.weatherHistoryList
                    .map((e) => ChartModel(epochToDateString(e.dt), e.wind.speed.toInt()))
                    .toList(),
                xValue: (p0, p1) => p0.xAxis,
                yValue: (p0, p1) => p0.yAxis,
              )
            ],
          ),
        );
      },
    );
  }
}
