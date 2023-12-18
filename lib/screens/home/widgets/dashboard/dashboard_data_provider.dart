import 'dart:async';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:weather/weather.dart';

import '../../../../network/crow/models/user_by_id_response.dart';
import '../../../../network/crow/user_operations.dart';
import '../../../../pandora/pandora.dart';
import '../../../../utils/assets/nsvgs_assets.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../../offline/sites/offline_sites_menu.dart';
import 'dashboard_grid_item.dart';

class DashboardDataProvider extends ChangeNotifier {
  late Position position;
  late Weather weather;
  bool isloading = true;

  WeatherFactory weatherFactory = WeatherFactory(WTH_KEY);
  final AsyncMemoizer _asyncLocation = AsyncMemoizer();
  final AsyncMemoizer _asyncWeather = AsyncMemoizer();
  DateTime? now;
  Pandora pandora = Pandora();
  GetUserByIdResponse? _userByIdResponse;
  final AsyncMemoizer _profileAsync = AsyncMemoizer();
  final farmMenu = dashboardMenuList;
  List<Widget> dashboardGridItem = [];
  final Pandora _pandora = Pandora();

  bool get mounted => false;

  Widget card(BuildContext context) {
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
              return const ReuseableWidget();
            } else {
              return isloading
                  ? const ReuseableWidget()
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
                            NsvgsAssets.kWeatherBackg,
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
                                      style: Styles.largeSemiBoldStyle(),
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
                                          style: Styles.labelTextStyleWhite(),
                                        ),
                                        Text(
                                          '${weather.areaName}, ${weather.country}',
                                          style: Styles.whiteRegularStyle(),
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
                                            style: Styles.whiteRegularStyleBold(),
                                          ),
                                          Text(
                                            '${DateFormat('EEE').format(now!)} ${now!.day}, ${now!.year}',
                                            style: Styles.whiteRegularStyleBold(),
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
    final LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      await Geolocator.requestPermission().then((value) async {
        if (value != LocationPermission.denied) {
          return _asyncLocation.runOnce(() async {
            var position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.medium,
            );

            position = position;
            await getCurrentWeather();
            Session.position = position;
            notifyListeners();
            return position;
          });
        }
      });
    } else {
      return _asyncLocation.runOnce(() async {
        var position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
        );
        position = position;
        await getCurrentWeather();
        Session.position = position;
        notifyListeners();
        return position;
      });
    }
  }

  Future<dynamic> getCurrentWeather() async {
    return _asyncWeather.runOnce(() async {
      var weather = await weatherFactory.currentWeatherByLocation(
        position.latitude,
        position.longitude,
      );
      debugPrint('${weather.weatherMain}, ${weather.weatherDescription}');
      if (mounted) {
        weather = weather;
        isloading = false;
        notifyListeners();
      }
      return weather;
    });
  }

  void getTime() {
    if (mounted) {
      now = DateTime.now();
      notifyListeners();
    }
  }

  Future getUserInformation(String userId) async {
    return _profileAsync.runOnce(() async {
      _userByIdResponse = await getUserById(userId);
      if (farmMenu.isEmpty) {
      } else {
        for (final element in _userByIdResponse!.role!.subscription!.permissions!) {
          if (element.name == AppPermissions.user_field_manager) {
            dashboardGridItem.add(
              DashboardGridItem(
                route: farmMenu[0]["route"],
                image: farmMenu[0]["image"],
                text: farmMenu[0]["text"],
                background: farmMenu[0]["background"],
              ),
            );
          }

          if (element.name == AppPermissions.farm_shop) {
            dashboardGridItem.add(
              DashboardGridItem(
                route: farmMenu[2]["route"],
                image: farmMenu[2]["image"],
                text: farmMenu[2]["text"],
                background: farmMenu[2]["background"],
              ),
            );

            if (element.name == AppPermissions.farm_sense_devices) {
              dashboardGridItem.add(
                DashboardGridItem(
                  route: farmMenu[4]["route"],
                  image: farmMenu[4]["image"],
                  text: farmMenu[4]["text"],
                  background: farmMenu[4]["background"],
                ),
              );
            }
          }

          if (element.name == AppPermissions.field_pro_offline) {
            await _pandora.saveToSharedPreferences('field_pro_offline', 'Y');
          }

          if (element.name == AppPermissions.field_pro_in_app) {
            await _pandora.saveToSharedPreferences('field_pro_in_app', 'Y');
          }
        }

        _userByIdResponse!.role!.role == AppPermissions.field_agents
            ? dashboardGridItem.add(
                DashboardGridItem(
                  route: farmMenu[1]["route"],
                  image: farmMenu[1]["image"],
                  text: farmMenu[1]["text"],
                  background: farmMenu[1]["background"],
                  // ignore: unnecessary_statements
                ),
              )
            // ignore: unnecessary_statements
            : null;

        dashboardGridItem.add(
          DashboardGridItem(
            route: farmMenu[3]["route"],
            image: farmMenu[3]["image"],
            text: farmMenu[3]["text"],
            background: farmMenu[3]["background"],
          ),
        );
      }
      notifyListeners();
      return _userByIdResponse;
    });
  }
}
