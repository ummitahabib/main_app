import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/weather_soil_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/weather_info_forecast.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/weather_info_history.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/soil_info_header.dart';
import 'package:smat_crow/features/organisation/views/widgets/tap_card.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class WeatherInfo extends HookConsumerWidget {
  const WeatherInfo({super.key, this.showCancelIcon = true});
  final bool showCancelIcon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = useState<int>(0);
    final startDate =
        useState(DateTime.now().subtract(const Duration(days: 6)));
    final endDate = useState(DateTime.now());
    final themeData = Theme.of(context);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          if (ref.read(siteProvider).site!.polygonId != '0') {
            ref
                .read(weatherSoilProvider)
                .getWeatherHistory(startDate.value, endDate.value);
          } else {
            snackBarMsg(polygonSizeWarning);
          }
        });
        return null;
      },
      [],
    );
    return DialogContainer(
      height: Responsive.yHeight(context, percent: 0.85),
      child: RefreshIndicator(
        onRefresh: () async {
          if (ref.read(siteProvider).site!.polygonId != '0') {
            await ref
                .read(weatherSoilProvider)
                .getWeatherHistory(startDate.value, endDate.value);
          } else {
            snackBarMsg(polygonSizeWarning);
          }
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SoilInfoHeader(
              title: weatherInfo,
              showIcon: showCancelIcon,
            ),
            if (ref.read(siteProvider).site!.polygonId != '0')
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    icon: SvgPicture.asset(AppAssets.calendar),
                    onPressed: () async {
                      final result = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2019),
                        lastDate: DateTime.now(),
                        currentDate: DateTime.now(),
                        saveText: 'Done',
                        builder: (context, child) {
                          return Theme(
                            data: themeData.copyWith(
                              appBarTheme: themeData.appBarTheme.copyWith(
                                backgroundColor: Colors.blue,
                                iconTheme:
                                    const IconThemeData(color: Colors.white),
                              ),
                              colorScheme: const ColorScheme.light(),
                            ),
                            child: SafeArea(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 450,
                                    width: 700,
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: child,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        initialDateRange: DateTimeRange(
                          start: startDate.value,
                          end: endDate.value,
                        ),
                      );
                      if (result != null) {
                        startDate.value = result.start;
                        endDate.value = result.end;
                        await ref
                            .read(weatherSoilProvider)
                            .getWeatherHistory(startDate.value, endDate.value);
                      }
                    },
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(DateFormat.yMMMd().format(endDate.value)),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: AppColors.SmatCrowNeuBlue900,
                        )
                      ],
                    ),
                  )
                ],
              ),
            customSizedBoxHeight(SpacingConstants.size20),
            Container(
              height: SpacingConstants.size32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(SpacingConstants.size8),
                color: AppColors.SmatCrowNeuBlue100,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: Responsive.isTablet(context)
                    ? SpacingConstants.size50
                    : SpacingConstants.size20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TapCard(
                      selectedIndex: selectedIndex.value,
                      tap: () {
                        selectedIndex.value = 0;
                        if (ref
                            .read(weatherSoilProvider)
                            .weatherHistoryList
                            .isEmpty) {
                          ref.read(weatherSoilProvider).getWeatherHistory(
                                startDate.value,
                                endDate.value,
                              );
                        }
                      },
                      name: historicalText,
                      index: 0,
                    ),
                  ),
                  Expanded(
                    child: TapCard(
                      index: 1,
                      selectedIndex: selectedIndex.value,
                      tap: () {
                        selectedIndex.value = 1;
                        if (ref.read(siteProvider).site!.polygonId != '0') {
                          ref.read(weatherSoilProvider).getCurrentWeatherInfo();
                          if (ref
                              .read(weatherSoilProvider)
                              .weatherForecastList
                              .isEmpty) {
                            ref.read(weatherSoilProvider).getWeatherForecast();
                          }
                        } else {
                          snackBarMsg(polygonSizeWarning);
                        }
                      },
                      name: forecastText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height:
                  kIsWeb ? SpacingConstants.size10 : SpacingConstants.size20,
            ),
            if (selectedIndex.value == 0)
              const WeatherInfoHistory()
            else
              const WeatherInfoForecast(),
          ],
        ),
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}
