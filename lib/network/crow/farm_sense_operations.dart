import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/get_farmsense_devices.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import 'device_detail_response.dart';

Pandora _pandora = Pandora();

Future<List<UserDevicesResponse>> getDevicesForUser(String userId) async {
  debugPrint('getting devices for user $userId');
  List<UserDevicesResponse> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/farmsense/devices/user/$userId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GETTING_USER_DEVICES',
      '$BASE_URL/farmsense/devices/user/$userId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<UserDevicesResponse>.from(
      jsonDecode(response.body).map((model) => UserDevicesResponse.fromJson(model)),
    );
    //  return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GETTING_USER_DEVICES',
      '$BASE_URL/farmsense/devices/user/$userId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GETTING_USER_DEVICES',
      '$BASE_URL/farmsense/devices/user/$userId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<List<DeviceDetailsResponse>> getDeviceDetails(String deviceId) async {
  debugPrint('getting devices details $deviceId');
  List<DeviceDetailsResponse> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/farmsense/devices/details/$deviceId'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GETTING_DEVICES_DETAILS',
      '$BASE_URL/farmsense/devices/details/$deviceId',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );

    result = List<DeviceDetailsResponse>.from(
      jsonDecode(response.body).map((model) => DeviceDetailsResponse.fromJson(model)),
    );

    // return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GETTING_DEVICES_DETAILS',
      '$BASE_URL/farmsense/devices/details/$deviceId',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GETTING_DEVICES_DETAILS',
      '$BASE_URL/farmsense/devices/details/$deviceId',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}
