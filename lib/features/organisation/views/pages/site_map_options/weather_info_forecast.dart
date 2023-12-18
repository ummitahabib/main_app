import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/features/organisation/data/controller/weather_soil_controller.dart';
import 'package:smat_crow/features/organisation/data/models/weather_history.dart';
import 'package:smat_crow/features/organisation/views/widgets/chart_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class WeatherInfoForecast extends StatelessWidget {
  const WeatherInfoForecast({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        final weather = ref.watch(weatherSoilProvider);
        if (weather.loading) {
          return SizedBox(
            height: Responsive.yHeight(context, percent: kIsWeb ? 0.60 : 0.75),
            child: const GridLoader(arrangement: 1),
          );
        }
        if (weather.weatherForecastList.isEmpty) {
          return const EmptyListWidget(text: noWeatherInfo);
        }
        return Container(
          height: Responsive.yHeight(context, percent: kIsWeb ? 0.60 : 0.75),
          margin: EdgeInsets.symmetric(
            horizontal: Responsive.isTablet(context)
                ? SpacingConstants.size50
                : SpacingConstants.size20,
          ),
          child: RefreshIndicator(
            onRefresh: () => ref.read(weatherSoilProvider).getWeatherForecast(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                if (weather.currentForecast != null)
                  Container(
                    padding: const EdgeInsets.all(20),
                    margin: EdgeInsets.symmetric(
                      vertical: Responsive.isTablet(context)
                          ? SpacingConstants.size30
                          : SpacingConstants.size10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(SpacingConstants.font10),
                      border: Border.all(color: AppColors.SmatCrowNeuBlue200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            cloudCondition,
                            style: Styles.smatCrowSubParagraphRegular(
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        customSizedBoxHeight(SpacingConstants.size20),
                        const Divider(),
                        customSizedBoxHeight(SpacingConstants.size20),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(epochToDayString(weather.currentForecast!.dt)),
                            customSizedBoxHeight(SpacingConstants.size20),
                            SizedBox(
                              width: SpacingConstants.size30,
                              height: SpacingConstants.size30,
                              child: Image.network(
                                "$weatherIconUrl${weather.currentForecast!.weather.first.icon}@2x.png",
                              ),
                            ),
                            customSizedBoxHeight(SpacingConstants.size20),
                            Text(
                              "${weather.currentForecast!.main.tempMax.toInt() - 273}°",
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                if (weather.currentForecast != null)
                  customSizedBoxHeight(SpacingConstants.size20),
                Text(
                  "${filterList(weather.weatherForecastList).length} $daysForcast",
                  style: Styles.smatCrowHeadingBold6(
                    color: AppColors.SmatCrowNeuBlue900,
                  ),
                ),
                SizedBox(
                  height: Responsive.isTablet(context)
                      ? SpacingConstants.size40
                      : SpacingConstants.size10,
                ),
                ...filterList(weather.weatherForecastList)
                    .map(
                      (e) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: SpacingConstants.size8,
                            ),
                            child: Row(
                              children: [
                                Text(epochToDayString(e.dt)),
                                const Spacer(),
                                Text("${(e.main.temp - 273).toInt()} °"),
                                customSizedBoxWidth(
                                  SpacingConstants.size10,
                                ),
                                SizedBox(
                                  width: SpacingConstants.size30,
                                  height: SpacingConstants.size30,
                                  child: Image.network(
                                    "$weatherIconUrl${e.weather.first.icon}@2x.png",
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Divider()
                        ],
                      ),
                    )
                    .toList(),
                customSizedBoxHeight(SpacingConstants.size50),
              ],
            ),
          ),
        );
      },
    );
  }
}

List<WeatherHistory> filterList(List<WeatherHistory> dataList) {
  final List<int> uniqueDaysOfWeek = [];
  final List<WeatherHistory> uniqueObjects = [];

  for (final data in dataList) {
    final DateTime dateTime =
        DateTime.fromMillisecondsSinceEpoch(data.dt * 1000);
    final int dayOfWeek = dateTime.weekday;

    if (!uniqueDaysOfWeek.contains(dayOfWeek)) {
      uniqueDaysOfWeek.add(dayOfWeek);
      uniqueObjects.add(data);
    }
  }

  return uniqueObjects;
}
