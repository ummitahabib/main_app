import 'dart:io';

import 'package:dio/dio.dart';
import 'package:smat_crow/features/data/models/auth_response.dart';
import 'package:smat_crow/features/data/models/forget_password_request.dart';
import 'package:smat_crow/features/data/models/register_request.dart';
import 'package:smat_crow/features/data/models/signin_request.dart';
import 'package:smat_crow/features/data/models/update_user_request.dart';
import 'package:smat_crow/features/organisation/data/models/request_res.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';

//auth controller

class AuthenticationRepository {
  final helpers = ApplicationHelpers();

  Future<RequestRes> registerUser(
    RegisterRequest request,
  ) async {
    final client = locator.get<ApiClient>();

    try {
      final response = await client.post(Endpoints.register, data: request.toJson());

      final authResponse = AuthResponse.fromJson(response);

      helpers.trackAPIEvent(
        'CREATE_NEW_USER',
        client.baseUrl + Endpoints.register,
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: authResponse);
    } catch (e) {
      final errorMessage = e.toString();
      helpers.trackAPIEvent(
        'CREATE_NEW_USER',
        client.baseUrl + Endpoints.register,
        'FAILED',
        errorMessage,
      );
      return RequestRes(error: ErrorRes(message: errorMessage));
    }
  }

  Future<RequestRes> signinUser(SigninRequest request) async {
    final client = locator.get<ApiClient>();

    try {
      final response = await client.post(
        Endpoints.login,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
          },
        ),
      );
      final authResponse = AuthResponse.fromJson(response);
      ApplicationHelpers().trackAPIEvent(
        'SIGN_IN_USER',
        client.baseUrl + Endpoints.login,
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: authResponse);
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'SIGN_IN_USER',
        client.baseUrl + Endpoints.login,
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> userResetPassword(ForgetpasswordRequest request) async {
    final client = locator.get<ApiClient>();

    try {
      final response = await client.post(
        Endpoints.forgetPassword,
        data: request.toJson(),
        options: Options(
          headers: {
            'Content-type': 'application/json',
          },
        ),
      );
      final authResponse = AuthResponse.fromJson(response);
      ApplicationHelpers().trackAPIEvent(
        'RESET_USER_PASSWORD',
        client.baseUrl + Endpoints.forgetPassword,
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: authResponse);
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'RESET_USER_PASSWORD',
        client.baseUrl + Endpoints.forgetPassword,
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> changeToAgent(String id) async {
    final client = locator.get<ApiClient>();

    try {
      final response = await client.put(
        "/smatauth/users/$id/change-to-agent",
        data: {},
      );

      ApplicationHelpers().trackAPIEvent(
        'SWITCH_TO_AGENT',
        "${client.baseUrl}/smatauth/users/$id/change-to-agent",
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'SWITCH_TO_AGENT',
        "${client.baseUrl}/smatauth/users/$id/change-to-agent",
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updateUser(UpdateInfoRequest request, String id) async {
    final client = locator.get<ApiClient>();

    try {
      final response = await client.put(
        "/smatauth/users/$id/update",
        data: request.toJson(),
      );

      ApplicationHelpers().trackAPIEvent(
        'UPDATE_USER_INFO',
        "${client.baseUrl}/smatauth/users/$id/update",
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'UPDATE_USER_INFO',
        "${client.baseUrl}/smatauth/users/$id/update",
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> updatePassword(String oldPass, String newPass) async {
    final client = locator.get<ApiClient>();

    try {
      final response = await client.put(
        "/smatauth/users/change-password",
        data: {"currentPassword": oldPass, "password": newPass},
      );

      ApplicationHelpers().trackAPIEvent(
        'UPDATE_PASSWORD',
        "${client.baseUrl}/smatauth/users/change-password",
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: response);
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'UPDATE_PASSWORD',
        "${client.baseUrl}/smatauth/users/change-password",
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }

  Future<RequestRes> resetPassword(String request, String token) async {
    final client = locator.get<ApiClient>();

    try {
      final response = await client.put(
        "${Endpoints.resetPassword}$token/resetpassword",
        data: {"password": request},
        options: Options(
          headers: {
            'Content-type': 'application/json',
          },
        ),
      );
      final authResponse = AuthResponse.fromJson(response);
      ApplicationHelpers().trackAPIEvent(
        'RESET_USER_PASSWORD',
        client.baseUrl + Endpoints.forgetPassword,
        HttpStatus.ok.toString(),
        HttpStatus.ok.toString(),
      );
      return RequestRes(response: authResponse);
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'RESET_USER_PASSWORD',
        client.baseUrl + Endpoints.forgetPassword,
        'FAILED',
        e.toString(),
      );
      return RequestRes(error: ErrorRes(message: e.toString()));
    }
  }
}
