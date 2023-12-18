import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:smat_crow/utils/session.dart';

import '../../utils/constants.dart';
import 'models/request/update_device_id.dart';

Future<bool> updateDeviceToken(UpdateDeviceIdRequest request) async {
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/notification/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': Session.SessionToken,
    },
    body: jsonEncode(request.toJson()),
  );
  if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
    result = true;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    result = false;
  } else {
    result = false;
  }
  return result;
}
