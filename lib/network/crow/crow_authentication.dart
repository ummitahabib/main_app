import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/crow/models/login_response.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/constants.dart';

class CrowAuthentication with ChangeNotifier {
  String sessionToken = emptyString;
  Exception? failed;

  String get getSessionToken => sessionToken;

  Exception? get getFailed => failed;

  final Pandora _pandora = Pandora();

  Future<LoginResponse?> loginIntoAccount(
    BuildContext context,
    String email,
    String password,
  ) async {
    // OneContext().showProgressIndicator();
    LoginResponse? result;
    final response = await http.post(
      Uri.parse('$BASE_URL/smatauth/auth/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      _pandora.logAPIEvent(
        'CROW_LOGIN',
        '$BASE_URL/smatauth/auth/login',
        response.statusCode.toString(),
        emptyString,
      );

      result = LoginResponse.fromJson(jsonDecode(response.body));

      final firebaseLogin = Provider.of<Authentication>(context, listen: false);

      await firebaseLogin.loginIntoAccount(context, email, password);
      sessionToken = result.token!;
      Session.SessionToken = result.token!;
      debugPrint('loggedIn successfully');
// ;      OneContext().removeAllOverlays();
    } else if (response.statusCode == HttpStatus.unauthorized) {
      _pandora.logAPIEvent(
        'CROW_LOGIN',
        '$BASE_URL/smatauth/auth/login',
        'FAILED',
        response.statusCode.toString(),
      );

      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(
          content: Text('Incorrect Login Details'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      _pandora.logAPIEvent(
        'CROW_LOGIN',
        '$BASE_URL/smatauth/auth/login',
        'FAILED',
        response.statusCode.toString(),
      );
    }
    OneContext().hideProgressIndicator();
    notifyListeners();
    return result;
  }

  Future<bool> createNewAccount(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String password,
  ) async {
    await OneContext().showProgressIndicator();
    bool result;
    final response = await http.post(
      Uri.parse('$BASE_URL/smatauth/auth/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'firstName': firstName,
        'lastName': lastName,
        'phone': phoneNumber,
        'email': email,
        'password': password,
      }),
    );
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      _pandora.logAPIEvent(
        'CROW_SIGNUP',
        '$BASE_URL/smatauth/auth/register',
        response.statusCode.toString(),
        emptyString,
      );
      final firebaseLogin = Provider.of<Authentication>(context, listen: false);
      await firebaseLogin.loginIntoAccount(context, email, password);
      result = true;
    } else if (response.statusCode == HttpStatus.badRequest) {
      _pandora.logAPIEvent(
        'CROW_LOGIN',
        '$BASE_URL/smatauth/auth/login',
        'FAILED',
        response.statusCode.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(content: Text('User Already Exist !')),
      );
      result = false;
    } else {
      _pandora.logAPIEvent(
        'CROW_LOGIN',
        '$BASE_URL/smatauth/auth/login',
        'FAILED',
        response.statusCode.toString(),
      );
      result = false;
    }
    OneContext().hideProgressIndicator();
    notifyListeners();
    return result;
  }

  Future<bool> resetPassword(BuildContext context, String email) async {
    await OneContext().showProgressIndicator();
    bool result;
    final response = await http.post(
      Uri.parse('$BASE_URL/smatauth/auth/forgotpassword'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
      }),
    );
    if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
      _pandora.logAPIEvent(
        'CROW_RESET',
        '$BASE_URL/smatauth/auth/forgotpassword',
        response.statusCode.toString(),
        emptyString,
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(
          content: Text('Password Reset Success, Please Check your email!'),
        ),
      );
      result = true;
    } else if (response.statusCode == HttpStatus.badRequest) {
      _pandora.logAPIEvent(
        'CROW_RESET',
        '$BASE_URL/smatauth/auth/forgotpassword',
        'FAILED',
        response.statusCode.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(content: Text('Password Reset Failed !')),
      );
      result = false;
    } else {
      _pandora.logAPIEvent(
        'CROW_RESET',
        '$BASE_URL/smatauth/auth/forgotpassword',
        'FAILED',
        response.statusCode.toString(),
      );
      await OneContext().showSnackBar(
        builder: (_) => const SnackBar(content: Text('Password Reset Failed !')),
      );
      result = false;
    }
    OneContext().hideProgressIndicator();
    notifyListeners();
    return result;
  }
}
