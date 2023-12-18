import 'package:beamer/beamer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smat_crow/features/data/models/register_request.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/strings.dart';

class ApplicationHelpers {
  void reRouteUser(BuildContext context, String route, Object? args) {
    if (kIsWeb) {
      context.beamToNamed(route, data: args, routeState: args);
    } else {
      Navigator.pushNamed(context, route, arguments: args);
    }
  }

  void navigationHelper(
    BuildContext context,
    Widget destination,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => destination,
      ),
    );
  }

  void routeBack(BuildContext context) {
    if (kIsWeb) {
      context.beamBack();
    } else {
      Navigator.pop(context);
    }
  }

  void replaceRoute(BuildContext context, String route, Object? args) {
    if (kIsWeb) {
      context.beamToReplacementNamed(route, data: args);
    } else {
      Navigator.pushReplacementNamed(context, route, arguments: args);
    }
  }

  String? nextRoute;
  Object? args;

  bool validateEmail(String emailAddress) {
    return (emailAddress.isEmpty) ? false : true;
  }

  bool isValidEmail(String email) {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(email);
  }

  bool isValidPassword(String password) {
    return password.length >= SpacingConstants.int6;
  }

  String moneyFormatNew(String price) {
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), emptyString);
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      return value;
    }
    return price;
  }

  void trackAPIEvent(
    String action,
    String endpoint,
    String status,
    String error,
  ) {
    GetIt.I<FirebaseAnalytics>().logEvent(
      name: USER_NAME,
      parameters: <String, dynamic>{
        'device_name': DeviceName,
        'action': action,
        'endpoint': endpoint,
        'status': status,
        'error': error
      },
    );
  }

  void trackButtonAndDeviceEvent(String buttonName) {
    GetIt.I<FirebaseAnalytics>().logEvent(
      name: applicationButtonClicked,
      parameters: <String, dynamic>{
        deviceName: DeviceName,
        deviceButtonName: buttonName,
      },
    );

    GetIt.I<FirebaseAnalytics>().logEvent(
      name: deviceButtonClicked,
      parameters: <String, dynamic>{
        deviceName: DeviceName,
        deviceButtonName: buttonName,
      },
    );
  }

  Future<bool> saveToSharedPreferences(String key, String value) async {
    final pref = await SharedPreferences.getInstance();
    return pref.setString(key, value);
  }

  Future<String> getFromSharedPreferences(String key) async {
    final pref = await SharedPreferences.getInstance();
    final value = pref.getString(key) ?? emptyString;
    return value;
  }

  bool isRequestValid(RegisterRequest request) {
    return request.email.isNotEmpty && request.password.isNotEmpty;
  }

  static String getEmailUserName(String s) {
    if (s.isNotEmpty) {
      if (s
              .substring(SpacingConstants.int0, s.indexOf(atCharacterString))
              .replaceAll(splitString, emptyString)
              .toUpperCase() !=
          info) {
        return s
            .substring(SpacingConstants.int1, s.indexOf(atCharacterString))
            .replaceAll(splitString, emptyString);
      }
      return s
          .substring(s.indexOf(atCharacterString) + SpacingConstants.int1)
          .substring(
            SpacingConstants.int0,
            s
                .substring(s.indexOf(atCharacterString) + SpacingConstants.int1)
                .indexOf(splitString),
          )
          .replaceAll(splitString, emptyString);
    }
    return s;
  }
}
