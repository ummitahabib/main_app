// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/data/models/register_request.dart';
import 'package:smat_crow/features/presentation/pages/splash/screens/splash_page.dart';
import 'package:smat_crow/features/presentation/widgets/alert.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/enum.dart';

final signUpStateProvider = ChangeNotifierProvider<SignUpState>((ref) {
  return SignUpState();
});

class SignUpState extends ChangeNotifier {
  final Ref? ref;
  SignUpState({this.ref});

  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  final helpers = ApplicationHelpers();

  Future<void> createNewUser(
    BuildContext context,
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    final authenticationNotifier = ref?.read(authenticationProvider);
    final registerRequest = RegisterRequest(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    try {
      await authenticationNotifier?.registerUser(
        context,
        registerRequest,
        email,
        password,
      );

      if (authenticationNotifier?.authResponse != null) {
        accountCreated(context);
      } else {
        showErrorDialog(
          alertHeaderText: createAccountFailedHeader,
          messageType: MessageTypes.WARNING.toString().split(splitString).last,
          alertBodyDescription: createAccountFailedDescription,
          onPressedFirstbutton: () {
            helpers.reRouteUser(context, ConfigRoute.signup, null);
          },
          onPressedSecondbutton: () {
            helpers.reRouteUser(context, ConfigRoute.onboarding, null);
          },
          leftbuttonText: tryAgainError,
          rightbuttonText: cancel,
        );
      }
    } catch (e) {
      helpers.trackAPIEvent(
        'CREATE_NEW_USER',
        'register',
        'FAILED',
        e.toString(),
      );
    }
  }

  void accountCreated(BuildContext context) {
    showErrorDialog(
      alertHeaderText: createSuccessHeader,
      messageType: MessageTypes.SUCCESS.toString().split(splitString).last,
      alertBodyDescription: createSuccessDescription,
      onPressedFirstbutton: () {
        helpers.reRouteUser(context, ConfigRoute.verifyEmailPage, null);
      },
      onPressedSecondbutton: () {
        helpers.reRouteUser(context, ConfigRoute.login, null);
      },
      leftbuttonText: continueText,
      rightbuttonText: backText,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const SplashScreen(),
      ),
      (route) => false,
    );
  }
}
