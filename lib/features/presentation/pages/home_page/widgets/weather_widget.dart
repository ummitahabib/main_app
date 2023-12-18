import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';
import 'package:smat_crow/utils2/weather_location_date_constants.dart';
import 'package:weather/weather.dart';

//weather widget

class WeatherWidget extends StatefulWidget {
  const WeatherWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  ApplicationHelpers appHelper = ApplicationHelpers();
  late Position position;
  Weather? weather;
  bool isLoading = true;
  WeatherType currentWeatherType = WeatherType.sunny;

  WeatherFactory weatherFactory = WeatherFactory(WTH_KEY);

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: buildWeatherCard(context),
      tablet: buildWeatherCard(context, isTablet: true),
      desktop: buildWeatherCard(context, isDesktop: true),
    );
  }

  Widget buildWeatherCard(
    BuildContext context, {
    bool isTablet = false,
    bool isDesktop = false,
  }) {
    const EdgeInsets cardPadding =
        EdgeInsets.symmetric(horizontal: SpacingConstants.size20, vertical: SpacingConstants.size10);

    return Padding(
      padding: cardPadding,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpacingConstants.size10),
        ),
        elevation: SpacingConstants.size10,
        shadowColor: AppColors.shadowColor,
        child: ClipPath(
          clipper: DecorationBox.shapeBorderClipper(),
          child: Stack(
            children: [
              WeatherBg(
                weatherType: currentWeatherType,
                width: MediaQuery.sizeOf(context).width,
                height: SpacingConstants.size150,
              ),
              SizedBox(
                height: SpacingConstants.size150,
                child: Padding(
                  padding: const EdgeInsets.all(SpacingConstants.size15),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        customSizedBoxHeight(
                          SpacingConstants.size15,
                        ),
                        Text(
                          '${weather?.temperature?.celsius?.ceil() ?? SpacingConstants.int0}$defaultCelcius',
                          style: Styles.weatherTemperatureTextStyle(),
                        ),
                        customSizedBoxHeight(
                          SpacingConstants.size10,
                        ),
                        Text(
                          ' ${weather?.weatherMain ?? emptyString}, ${weather?.weatherDescription ?? emptyString}',
                          style: Styles.weatherMainTextStyle(),
                        ),
                        Text(
                          '${weather?.areaName ?? emptyString}, ${weather?.country ?? emptyString}',
                          style: Styles.areaNameTextStyle(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> getUserLocation() async {
    try {
      position = await determinePosition();

      setState(() {
        position = position;
        getCurrentWeather();
      });
      return position;
    } catch (e) {
      appHelper.trackAPIEvent(
        'GET_USER_LOCATION',
        "GET_USER_LOCATION",
        'WARNING',
        'ERROR $e',
      );
    }
  }

  Future<dynamic> getCurrentWeather() async {
    try {
      weather = await weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        weather = weather;
        isLoading = false;
        currentWeatherType = weatherType(weather?.weatherDescription);
      });
      log(currentWeatherType.toString());
      return weather;
    } catch (e) {
      appHelper.trackAPIEvent(
        'GET_USER_CURRENT_WEATHER',
        "GET_USER_CURRENT_WEATHER",
        'WARNING',
        'ERROR $e',
      );
    }
  }
}
