import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/crow/models/request/update_profile.dart';
import 'package:smat_crow/network/crow/models/user_by_id_response.dart';
import 'package:smat_crow/network/crow/models/user_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

Pandora _pandora = Pandora();

Future<UserDetailsResponse?> getUserDetails() async {
  //OneContext().showProgressIndicator();
  UserDetailsResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/smatauth/auth/profile'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_USER_DETAILS',
      '$BASE_URL/smatauth/auth/profile',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = UserDetailsResponse.fromJson(
      jsonDecode(response.body),
    );
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_USER_DETAILS',
      '$BASE_URL/smatauth/auth/profile',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_USER_DETAILS',
      '$BASE_URL/smatauth/auth/profile',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  //OneContext().hideProgressIndicator();
  return result;
}

Future<GetUserByIdResponse?> getUserById(String userId) async {
  try {
    //OneContext().showProgressIndicator();
    GetUserByIdResponse? result;
    final response = await http.get(
      Uri.parse('$BASE_URL/smatauth/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${Session.SessionToken}',
      },
    );
    if (response.statusCode == HttpStatus.ok) {
      _pandora.logAPIEvent(
        'GET_USER_DETAILS',
        '$BASE_URL/smatauth/users/$userId',
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      result = GetUserByIdResponse.fromJson(jsonDecode(response.body));
      userData = result;
      USER_ID = result.id!;
    } else if (response.statusCode == HttpStatus.unauthorized) {
      _pandora.logAPIEvent(
        'GET_USER_DETAILS',
        '$BASE_URL/smatauth/users/$userId',
        'FAILED',
        HttpStatus.unauthorized.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
      );
    } else {
      _pandora.logAPIEvent(
        'GET_USER_DETAILS',
        '$BASE_URL/smatauth/users/$userId',
        'FAILED',
        response.statusCode.toString(),
      );
    }
    //OneContext().hideProgressIndicator();
    return result;
  } catch (e) {
    return null;
  }
}

Future<bool> updateUserProfile(
  UpdateProfileRequest request,
  String userId,
) async {
  await OneContext().showProgressIndicator();
  bool result;
  final response = await http.post(
    Uri.parse('$BASE_URL/smatauth/users/$userId/update'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer ${Session.SessionToken}',
    },
    body: jsonEncode(<String, String>{
      'firstName': request.firstName!,
      'lastName': request.lastName!,
      'email': request.email!,
      "phone": request.phone!,
    }),
  );
  if (response.statusCode == HttpStatus.ok ||
      response.statusCode == HttpStatus.created ||
      response.statusCode == HttpStatus.noContent) {
    _pandora.logAPIEvent(
      'UPDATE_PROFILE',
      '$BASE_URL/smatauth/users/$userId/update',
      HttpStatus.ok.toString(),
      HttpStatus.ok.toString(),
    );
    result = true;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(
        content: Text('Profile Updated'),
        backgroundColor: Colors.green,
      ),
    );
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'UPDATE_PROFILE',
      '$BASE_URL/smatauth/users/$userId/update',
      'FAILED',
      HttpStatus.unauthorized.toString(),
    );
    result = false;
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'UPDATE_PROFILE',
      '$BASE_URL/smatauth/users/$userId/update',
      'FAILED',
      response.statusCode.toString(),
    );
    result = false;
  }
  OneContext().hideProgressIndicator();
  return result;
}
