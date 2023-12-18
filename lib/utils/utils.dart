import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
      'Location permissions are permanently denied, we cannot request permissions.',
    );
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return Geolocator.getCurrentPosition();
}

WeatherType weatherType(String weather) {
  WeatherType type = WeatherType.cloudyNight;
  switch (weather) {
    case "Clouds, scattered clouds":
    case "Clouds, broken clouds":
      type = WeatherType.cloudy;
      break;
    case "Clouds, overcast clouds":
      type = WeatherType.overcast;
      break;
    case "Clear, clear sky":
    case "Clouds, few clouds":
      return WeatherType.sunny;
    case "Mist, mist":
    case "Haze, haze":
      type = WeatherType.hazy;
      break;
    case "Fog, fog":
      type = WeatherType.foggy;
      break;
    case "Smoke, smoke":
    case "Sand, sand":
    case "Dust, sand/ dust whirls":
    case "Ash, volcanic ash":
    case "Squall, squalls":
      type = WeatherType.dusty;
      break;
    case "Tornado, tornado":
    case "Thunderstorm, thunderstorm with light rain":
    case "Thunderstorm, thunderstorm with rain":
    case "Thunderstorm, thunderstorm with heavy rain":
    case "Thunderstorm, light thunderstorm":
    case "Thunderstorm, thunderstorm":
    case "Thunderstorm, heavy thunderstorm":
    case "Thunderstorm, ragged thunderstorm":
    case "Thunderstorm, thunderstorm with light drizzle":
    case "Thunderstorm, thunderstorm with drizzle":
    case "Thunderstorm, thunderstorm with heavy drizzle":
      type = WeatherType.thunder;
      break;
    case "Snow, light snow":
    case "Snow, Sleet":
    case "Snow, Light shower sleet":
    case "Snow, Light shower snow":
      type = WeatherType.lightSnow;
      break;
    case "Snow, Snow":
    case "Snow, Shower sleet":
    case "Snow, Shower snow":
      type = WeatherType.middleSnow;
      break;
    case "Snow, Heavy snow":
    case "Snow, Heavy shower snow":
      type = WeatherType.heavySnow;
      break;
    case "Rain, light rain":
    case "Rain, shower rain":
    case "Snow, Light rain and snow":
    case "Drizzle, light intensity drizzle":
    case "Drizzle, drizzle":
    case "Drizzle, heavy intensity drizzle":
    case "Drizzle, light intensity drizzle rain":
    case "Drizzle, drizzle rain":
    case "Drizzle, heavy intensity drizzle rain":
    case "Drizzle, shower rain and drizzle":
    case "Drizzle, shower drizzle":
      type = WeatherType.lightRainy;
      break;
    case "Rain, moderate rain":
    case "Snow, Rain and snow":
    case "Rain, ragged shower rain":
    case "Rain, heavy shower rain and drizzle":
      type = WeatherType.middleRainy;
      break;
    case "Rain, heavy intensity rain":
    case "Rain, very heavy rain":
    case "Rain, extreme rain":
    case "Rain, freezing rain":
    case "Rain, heavy intensity shower rain":
      type = WeatherType.heavyRainy;
      break;
  }
  return type;
}

String getMonthNumberFromName({String month = ''}) {
  switch (month) {
    case 'Jan':
      return '01';

    case 'Feb':
      return '02';

    case 'Mar':
      return '03';

    case 'Apr':
      return '04';

    case 'May':
      return '05';

    case 'Jun':
      return '06';

    case 'Jul':
      return '07';

    case 'Aug':
      return '08';

    case 'Sep':
      return '09';

    case 'Oct':
      return '10';

    case 'Nov':
      return '11';

    case 'Dec':
      return '12';

    default:
      return '';
  }
}

String getMonthNumberInWords({int month = 0}) {
  switch (month) {
    case 1:
      return 'Jan';

    case 2:
      return 'Feb';

    case 3:
      return 'Mar';

    case 4:
      return 'Apr';

    case 5:
      return 'May';

    case 6:
      return 'Jun';

    case 7:
      return 'Jul';

    case 8:
      return 'Aug';

    case 9:
      return 'Sep';

    case 10:
      return 'Oct';

    case 11:
      return 'Nov';

    case 12:
      return 'Dec';
    default:
      return '';
  }
}
