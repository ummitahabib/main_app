import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sensors/sensors.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:weather/weather.dart';

import '../../../utils/styles.dart';

class FarmNavigatorPage extends StatefulWidget {
  const FarmNavigatorPage({Key? key}) : super(key: key);

  @override
  _FarmNavigatorPageState createState() => _FarmNavigatorPageState();
}

class _FarmNavigatorPageState extends State<FarmNavigatorPage> {
  int mode = 0, map = 0;
  late AniControl compass;
  late AniControl earth;
  double? lat, lon;
  late Position position;

  String city = '', weather = '', icon = '01d';
  double temp = 0, humidity = 0;
  WeatherFactory weatherFactory = WeatherFactory(WTH_KEY);
  Weather? wth;
  final Pandora _pandora = Pandora();
  final GeoLocatorService geoService = GeoLocatorService();

  Future<void> getWeather() async {
    wth = await weatherFactory.currentWeatherByLocation(lat ?? 0, lon ?? 0);
    city = wth!.areaName!;
    weather = wth!.weatherMain!;
    icon = wth!.weatherIcon!;
    temp = wth!.temperature!.celsius!;
    humidity = wth!.humidity!;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    compass = AniControl([
      Anim('dir', 0, 360, 45, true),
      Anim('hor', -9.6, 9.6, 20, false),
      Anim('ver', -9.6, 9.6, 20, false),
    ]);

    earth = AniControl([
      Anim('dir', 0, 360, 20, true),
      Anim('lat', -90, 90, 1, false),
      Anim('lon', -180, 180, 1, true),
    ]);

    try {
      FlutterCompass.events!.listen((angle) {
        compass['dir']!.value = angle.heading ?? 0;
        earth['dir']!.value = angle.heading ?? 0;
      });
    } catch (ex) {}

    accelerometerEvents.listen((event) {
      compass['hor']!.value = -event.x;
      compass['ver']!.value = -event.y;
    });

    geoService.streamCurrentLocation().listen((position) {
      centerScreen(position);
    });
  }

  Widget Compass() {
    return Stack(
      children: [
        GestureDetector(
          onTap: () => setState(() => mode++),
          child: FlareActor(
            "assets/flrs/compass.flr",
            animation: 'mode${mode % 2}',
            controller: compass,
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (lat != null && lon != null)
                Text(
                  '${lat!.toStringAsFixed(4)}, ${lon!.toStringAsFixed(4)}',
                  style: GoogleFonts.orbitron(
                    textStyle: Styles.boldTextStyleWhite(),
                  ),
                )
              else
                Text(
                  'Fetching Location',
                  style: GoogleFonts.orbitron(
                    textStyle: Styles.boldTextStyleWhite(),
                  ),
                ),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget Earth() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          city,
          style: GoogleFonts.poppins(textStyle: Styles.largeBoldWhite()),
        ),
        if (lat != null && lon != null)
          Text(
            '${lat!.toStringAsFixed(4)}, ${lon!.toStringAsFixed(4)}',
            style: GoogleFonts.poppins(textStyle: Styles.largeBoldWhite()),
          )
        else
          Text(
            'Fetching Location',
            style: GoogleFonts.orbitron(textStyle: Styles.boldTextStyleWhite()),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.transperant,
        title: Text(
          'Field Navigator',
          overflow: TextOverflow.fade,
          style: GoogleFonts.poppins(textStyle: Styles.regularTextWhite()),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace_rounded,
            color: AppColors.whiteColor,
          ),
          onPressed: () {
            _pandora.logAPPButtonClicksEvent('NAVIGATOR_ITEM_BACK_CLICKED');
            Navigator.pop(context);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Compass(),
    );
  }

  Future<void> centerScreen(Position position) async {
    if (mounted) {
      setState(() {
        position = position;
        lat = position.latitude;
        lon = position.longitude;
        earth['lat']!.value = position.latitude;
        earth['lon']!.value = position.longitude;
      });
    }
  }
}

class Anim {
  String name;
  double _value = 0, pos = 0, min, max, speed;
  bool endless = false;
  ActorAnimation? actor;

  Anim(this.name, this.min, this.max, this.speed, this.endless);

  double get value => _value * (max - min) + min;

  set value(double v) => _value = (v - min) / (max - min);
}

class AniControl extends FlareControls {
  List<Anim> items;

  AniControl(this.items);

  @override
  bool advance(FlutterActorArtboard board, double elapsed) {
    super.advance(board, elapsed);
    for (final a in items) {
      if (a.actor == null) continue;
      var d = (a.pos - a._value).abs();
      var m = a.pos > a._value ? -1 : 1;
      if (a.endless && d > 0.5) {
        m = -m;
        d = 1.0 - d;
      }
      final e = elapsed / a.actor!.duration * (1 + d * a.speed);
      a.pos = e < d ? (a.pos + e * m) : a._value;
      if (a.endless) a.pos %= 1.0;
      a.actor!.apply(a.actor!.duration * a.pos, board, 1.0);
    }
    return true;
  }

  @override
  void initialize(FlutterActorArtboard board) {
    super.initialize(board);
    for (final a in items) {
      a.actor = board.getAnimation(a.name);
    }
  }

  Anim? operator [](String name) {
    for (final a in items) {
      if (a.name == name) return a;
    }
    return null;
  }
}
