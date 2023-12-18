import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/industries_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

Pandora _pandora = Pandora();

Future<List<GetIndustriesResponse>> getIndustriesResponse() async {
  debugPrint('getting all Industries');
  List<GetIndustriesResponse> result = [];
  final response = await http.get(
    Uri.parse('$BASE_URL/in/industries'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_ALL_INDUSTRIES',
      '$BASE_URL/in/industries',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = List<GetIndustriesResponse>.from(
      jsonDecode(response.body).map((model) => GetIndustriesResponse.fromJson(model)),
    );
    //return result;
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_ALL_INDUSTRIES',
      '$BASE_URL/in/industries',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_USER_ORGANIZATIONS_BY_ID',
      '$BASE_URL/in/industries',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}
