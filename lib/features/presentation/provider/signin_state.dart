// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/data/models/signin_request.dart';
import 'package:smat_crow/features/data/repository/authentication_repository.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_in_user_usecase.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/user/sign_up_user_usecase.dart';
import 'package:smat_crow/features/presentation/widgets/alert.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/enum.dart';
import 'package:smat_crow/utils2/service_locator.dart';
import 'package:smat_crow/utils2/signin_route_config.dart';

final signinStateProvider = ChangeNotifierProvider<SigninState>((ref) {
  return SigninState();
});

enum CredentialProviderStatus { initial, loading, loaded, failure }

class SigninState extends ChangeNotifier {
  final SignInUserUseCase? _signInUserUseCase;
  final SignUpUseCase? _signUpUseCase;

  SigninState({
    SignInUserUseCase? signInUserUseCase,
    SignUpUseCase? signUpUseCase,
  })  : _signInUserUseCase = signInUserUseCase,
        _signUpUseCase = signUpUseCase;

  late final Ref ref;
  final ApplicationHelpers _applicationHelpers = ApplicationHelpers();
  late String validateEmail, pass;

  CredentialProviderStatus _state = CredentialProviderStatus.initial;
  CredentialProviderStatus get state => _state;

  Future<void> signInUser({
    required String email,
    required String password,
  }) async {
    _updateState(CredentialProviderStatus.loading);

    try {
      if (_signInUserUseCase != null) {
        await _signInUserUseCase!.call(UserEntity(email: email, password: password));

        _updateState(CredentialProviderStatus.loaded);
      }
    } on FirebaseAuthException {
      _updateState(CredentialProviderStatus.failure);
    }
  }

  Future<void> signUpUser({
    required UserEntity user,
  }) async {
    _updateState(CredentialProviderStatus.loading);
    try {
      await _signUpUseCase!.call(
        user,
      );
      _updateState(CredentialProviderStatus.loaded);
    } on FirebaseAuthException catch (_) {
      _updateState(CredentialProviderStatus.failure);
    } catch (_) {
      _updateState(CredentialProviderStatus.failure);
    }
  }

  void _updateState(CredentialProviderStatus newState) {
    _state = newState;
    notifyListeners();
  }

  Future<void> logInUser(
    String emailAddress,
    String password,
    String route,
    String args,
    BuildContext context,
  ) async {
    final authenticationNotifier = ref.read(authenticationProvider);
    final signinRequest = SigninRequest(
      email: emailAddress,
      password: password,
    );
    try {
      await authenticationNotifier.signinUser(
        signinRequest,
      );
      final response = await locator.get<AuthenticationRepository>().signinUser(signinRequest);
      if (response.hasError()) {
        _applicationHelpers.trackAPIEvent(
          'USER_SIGNIN',
          'LOGIN',
          'FAILED',
          response.error!.message,
        );
      } else {
        _applicationHelpers.trackButtonAndDeviceEvent(loginClicked);
        _applicationHelpers.reRouteUser(context, route, args);
      }
    } catch (e) {
      _applicationHelpers.trackAPIEvent(
        'USER_SIGNIN',
        'LOGIN',
        'WARNING',
        'Error occured : $e',
      );
    }
  }

  bool validateLogInCredentials(String emailAddress, String password) {
    return (password.isEmpty || emailAddress.isEmpty) ? false : true;
  }

  void validateLoginRouter(
    LoginRouteConfig loginRouterConfig,
    String validateEmail,
    String pass,
    BuildContext context,
  ) {
    if (pass.isNotEmpty) {
      logInUser(
        validateEmail,
        pass,
        loginRouterConfig.reroutePage,
        loginRouterConfig.reroutePageId as String,
        context,
      );
    } else {
      showErrorDialog(
        alertHeaderText: loginFailedHeader,
        messageType: MessageTypes.WARNING.toString().split(splitString).last,
        alertBodyDescription: loginFailedDescription,
        onPressedFirstbutton: () {
          _applicationHelpers.reRouteUser(context, ConfigRoute.login, null);
        },
        onPressedSecondbutton: () {
          _applicationHelpers.reRouteUser(
            context,
            ConfigRoute.onboarding,
            null,
          );
        },
        leftbuttonText: tryAgain,
        rightbuttonText: cancel,
      );
    }
  }
}
