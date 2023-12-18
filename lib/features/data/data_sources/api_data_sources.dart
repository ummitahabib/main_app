import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/data/models/auth_response.dart';
import 'package:smat_crow/features/data/models/forget_password_request.dart';
import 'package:smat_crow/features/data/models/register_request.dart';
import 'package:smat_crow/features/data/models/signin_request.dart';
import 'package:smat_crow/features/data/models/update_user_request.dart';
import 'package:smat_crow/features/data/repository/authentication_repository.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/api_client.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/service_locator.dart';
import 'package:smat_crow/utils2/strings.dart';

//api data sources

final authenticationProvider = ChangeNotifierProvider<AuthenticationNotifier>(
  (ref) => AuthenticationNotifier(ref),
);

//Auth class extends ChangeNotifier
enum AuthStatus { initial, loading, success, failure }

class AuthenticationNotifier extends ChangeNotifier {
  final ApplicationHelpers _applicationHelpers = ApplicationHelpers();
  final Ref ref;

  AuthenticationNotifier(this.ref);

  AuthResponse? _authResponse;
  AuthResponse? get authResponse => _authResponse;
  set authResponse(AuthResponse? authRes) {
    _authResponse = authRes;
    notifyListeners();
  }

  AuthStatus _status = AuthStatus.initial;
  AuthStatus get status => _status;

  set status(AuthStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  bool _loading = false;
  bool get loading => _loading;
  set loading(bool state) {
    _loading = state;
    notifyListeners();
  }

  Future<void> registerUser(
    BuildContext context,
    RegisterRequest request,
    String? email,
    String? password,
  ) async {
    try {
      status = AuthStatus.loading;

      final response = await locator.get<AuthenticationRepository>().registerUser(request);

      if (response.hasError()) {
        final errorResponse = response.error;
        if (errorResponse != null && errorResponse.message == emailAreadyexistError) {
          status = AuthStatus.failure;
          _handleUserExistsError(errorResponse.message);
        } else {
          status = AuthStatus.failure;
          _handleRegistrationError(errorResponse?.message);
        }
      } else {
        status = AuthStatus.success;
        await _handleRegistrationSuccess(request);
      }
    } catch (e) {
      status = AuthStatus.failure;
      _handleRegistrationError(e.toString());
    }
  }

  void _handleUserExistsError(String errorMessage) {
    _applicationHelpers.trackAPIEvent(
      'CREATE_NEW_USER',
      'SIGNUP',
      'USER_ALREADY_TAKEN',
      errorMessage,
    );
  }

  void _handleRegistrationError(String? errorMessage) {
    if (errorMessage != null) {
      debugPrint("$accountCreationError: $errorMessage");
    }
  }

  Future<void> _handleRegistrationSuccess(RegisterRequest request) async {
    final response = await locator.get<AuthenticationRepository>().registerUser(request);

    if (response.response != null) {
      authResponse = response.response;

      await _applicationHelpers.saveToSharedPreferences(
        userEmail,
        request.email,
      );
      await _applicationHelpers.saveToSharedPreferences(
        userPassword,
        request.password,
      );

      USER_NAME = ApplicationHelpers.getEmailUserName(request.email);
      _applicationHelpers.trackButtonAndDeviceEvent(createButtonClicked);
    } else {
      status = AuthStatus.failure;
    }
  }

  Future<bool> signinUser(SigninRequest request) async {
    try {
      final response = await locator.get<AuthenticationRepository>().signinUser(request);

      if (response.hasError()) {
        _applicationHelpers.trackAPIEvent(
          'SIGN_IN',
          'login',
          'FAILED',
          response.error!.message,
        );
        authResponse = null;
        snackBarMsg(response.error!.message);
        return false;
      } else {
        authResponse = response.response;

        await _applicationHelpers.saveToSharedPreferences(
          userEmail,
          request.email,
        );

        Session.SessionToken = authResponse!.token ?? "";
        await _applicationHelpers.saveToSharedPreferences(
          "token",
          authResponse!.token ?? "",
        );
        await _applicationHelpers.saveToSharedPreferences(
          userPassword,
          request.password,
        );
        await ref.read(sharedProvider).getProfile();
        USER_NAME = ApplicationHelpers.getEmailUserName(request.email);
        _applicationHelpers.trackButtonAndDeviceEvent(createButtonClicked);

        return true;
      }
    } catch (e) {
      authResponse = null;
      _applicationHelpers.trackAPIEvent(
        'SIGN_IN',
        'LOGIN',
        'FAILED',
        "Sign in error: $e",
      );
      snackBarMsg(e.toString());
      return false;
    }
  }

  Future<bool> userResetPassword(
    BuildContext context,
    ForgetpasswordRequest request,
  ) async {
    try {
      final response = await locator.get<AuthenticationRepository>().userResetPassword(request);

      if (response.hasError()) {
        _applicationHelpers.trackAPIEvent(
          'RESET_PASSWORD',
          'FORGET_PASSWORD',
          'FAILED',
          response.error!.message,
        );
        snackBarMsg(response.error!.message);
        return false;
      }

      authResponse = response.response;
      return true;
    } catch (e) {
      _applicationHelpers.trackAPIEvent(
        'RESET_PASSWORD',
        'FORGET_PASSWORD',
        'FAILED',
        e.toString(),
      );
      snackBarMsg(e.toString());
      return false;
    }
  }

  Future<bool> switchToAgent() async {
    await OneContext().showProgressIndicator();
    try {
      final id = ref.read(sharedProvider).userInfo!.user.id;
      final response = await locator.get<AuthenticationRepository>().changeToAgent(id);
      OneContext().hideProgressIndicator();
      if (response.hasError()) {
        _applicationHelpers.trackAPIEvent(
          'RESET_PASSWORD',
          'FORGET_PASSWORD',
          'FAILED',
          response.error!.message,
        );

        snackBarMsg(response.error!.message);
        return false;
      }
      await ref.read(sharedProvider).getProfile();

      return true;
    } catch (e) {
      OneContext().hideProgressIndicator();

      _applicationHelpers.trackAPIEvent(
        'SWITCH_TO_AGENT',
        "${ApiClient().baseUrl}/smatauth/users/id/change-to-agent",
        'FAILED',
        e.toString(),
      );
      snackBarMsg(e.toString());
      return false;
    }
  }

  Future<bool> updateUser(UpdateInfoRequest request) async {
    loading = true;
    try {
      final id = ref.read(sharedProvider).userInfo!.user.id;
      final response = await locator.get<AuthenticationRepository>().updateUser(request, id);

      if (response.hasError()) {
        loading = false;
        snackBarMsg(response.error!.message);
        return false;
      }
      snackBarMsg("Profile Updated");
      await ref.read(sharedProvider).getProfile();
      loading = false;
      return true;
    } catch (e) {
      loading = false;
      _applicationHelpers.trackAPIEvent(
        'SWITCH_TO_AGENT',
        "${ApiClient().baseUrl}/smatauth/users/id/change-to-agent",
        'FAILED',
        e.toString(),
      );
      snackBarMsg(e.toString());
      return false;
    }
  }

  Future<bool> updatePassword(String oldPass, String newPass) async {
    loading = true;
    try {
      final response = await locator.get<AuthenticationRepository>().updatePassword(oldPass, newPass);

      if (response.hasError()) {
        loading = false;
        snackBarMsg(response.error!.message);
        return false;
      }
      log(response.response.toString());
      snackBarMsg("Password Updated");

      loading = false;
      return true;
    } catch (e) {
      loading = false;
      _applicationHelpers.trackAPIEvent(
        'SWITCH_TO_AGENT',
        "${ApiClient().baseUrl}/smatauth/users/id/change-to-agent",
        'FAILED',
        e.toString(),
      );
      snackBarMsg(e.toString());
      return false;
    }
  }

  Future<bool> resetPassword(
    String token,
    String request,
  ) async {
    loading = true;
    try {
      final response = await locator.get<AuthenticationRepository>().resetPassword(request, token);
      loading = false;
      if (response.hasError()) {
        authResponse = null;
        snackBarMsg(response.error!.message);
        return false;
      }
      snackBarMsg("Password Reset successful");
      authResponse = response.response;
      return true;
    } catch (e) {
      loading = false;
      authResponse = null;
      _applicationHelpers.trackAPIEvent(
        'RESET_PASSWORD',
        'FORGET_PASSWORD',
        'FAILED',
        e.toString(),
      );
      snackBarMsg(e.toString());
      return false;
    }
  }
}
