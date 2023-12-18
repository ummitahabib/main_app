import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:weather/weather.dart';

class DashboardWeather extends StatefulWidget {
  const DashboardWeather({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DashboardWeatherState();
  }
}

class _DashboardWeatherState extends State<DashboardWeather> {
  late Position position;
  late Weather weather;
  late Timer timer;
  bool isloading = true;

  WeatherFactory weatherFactory = WeatherFactory(WTH_KEY);
  final AsyncMemoizer _asyncLocation = AsyncMemoizer();
  final AsyncMemoizer _asyncWeather = AsyncMemoizer();
  DateTime? now;
  Pandora pandora = Pandora();

  @override
  void initState() {
    super.initState();
    pandora.requestLocation();
    getUserLocation();
    timer = Timer.periodic(const Duration(minutes: 1), (Timer t) => _getTime());
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 10,
      shadowColor: AppColors.shadowColor,
      child: ClipPath(
        clipper: ShapeBorderClipper(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey[500]!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            } else {
              return isloading
                  ? Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.grey[500]!.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )
                  : Stack(
                      children: [
                        Container(
                          width: size.width,
                          height: 150,
                          color: AppColors.landingOrangeButton,
                        ),
                        SizedBox(
                          width: size.width,
                          height: 150,
                          child: Image.asset(
                            "assets/nsvgs/dashboard/weather_background.png",
                          ),
                        ),
                        Container(
                          width: size.width,
                          height: 150,
                          color: AppColors.landingOrangeButton.withOpacity(0.788),
                        ),
                        SizedBox(
                          height: 150,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image.network(
                                      'https://openweathermap.org/img/wn/${weather.weatherIcon}@2x.png',
                                      width: 50,
                                      height: 50,
                                    ),
                                    Text(
                                      '${weather.temperature!.celsius!.ceil()}°C',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'semibold',
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${weather.weatherMain}, ${weather.weatherDescription}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'regular',
                                          ),
                                        ),
                                        Text(
                                          '${weather.areaName}, ${weather.country}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.5,
                                            fontFamily: 'regular',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 2,
                                    ),
                                    if (now != null)
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            DateFormat('h:mm a').format(now!),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'regular',
                                            ),
                                          ),
                                          Text(
                                            '${DateFormat('EEE').format(now!)} ${now!.day}, ${now!.year}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'regular',
                                            ),
                                          ),
                                        ],
                                      )
                                    else
                                      Container()
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
            }
          },
          future: getUserLocation(),
        ),
      ),
    );
  }

  Future<dynamic> getUserLocation() async {
    return _asyncLocation.runOnce(() async {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      setState(() {
        position = position;
        getCurrentWeather();
        Session.position = position;
      });
      return position;
    });
  }

  Future<dynamic> getCurrentWeather() async {
    return _asyncWeather.runOnce(() async {
      weather = await weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      debugPrint('${weather.weatherMain}, ${weather.weatherDescription}');
      if (mounted) {
        setState(() {
          weather = weather;
          isloading = false;
        });
      }
      return weather;
    });
  }

  void _getTime() {
    if (mounted) {
      setState(() {
        now = DateTime.now();
      });
    }
  }
}
