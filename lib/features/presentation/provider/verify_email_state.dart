import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/widgets/alert.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/enum.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class VerifyUserState extends ChangeNotifier {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? _timer;
  ApplicationHelpers appHelper = ApplicationHelpers();

  void initState(context) {
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail(context);
      _timer = Timer.periodic(
        const Duration(seconds: SpacingConstants.int3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    notifyListeners();

    if (isEmailVerified) _timer?.cancel();
  }

  Future sendVerificationEmail(BuildContext context) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();

      canResendEmail = false;
      notifyListeners();
      await Future.delayed(const Duration(seconds: SpacingConstants.int5));
      canResendEmail = true;
      notifyListeners();
    } catch (e) {
      ApplicationHelpers().trackAPIEvent(
        'VERIFY_EMAIL',
        'VERIFY',
        'FAILED',
        verificationError + e.toString(),
      );
      showErrorDialog(
        alertHeaderText: resendMailFailedHeader,
        messageType: MessageTypes.FAILED.toString().split(splitString).last,
        alertBodyDescription: resendMailFailedDescription,
        onPressedFirstbutton: () {
          appHelper.reRouteUser(context, ConfigRoute.verifyEmailPage, null);
        },
        onPressedSecondbutton: () {
          appHelper.reRouteUser(context, ConfigRoute.login, null);
        },
        leftbuttonText: tryAgainError,
        rightbuttonText: cancel,
      );
    }
  }

  Future<void> resendVerificationEmail(BuildContext context) async {
    try {
      await sendVerificationEmail(context);
    } catch (e) {
      appHelper.trackAPIEvent(
        'RESEND_MAIL',
        'RESENDMAIL',
        'FAILED',
        resendEmailError + e.toString(),
      );
      showErrorDialog(
        alertHeaderText: resendMailFailedHeader,
        messageType: MessageTypes.FAILED.toString().split(splitString).last,
        alertBodyDescription: resendMailFailedDescription,
        onPressedFirstbutton: () {
          appHelper.reRouteUser(context, ConfigRoute.verifyEmailPage, null);
        },
        onPressedSecondbutton: () {
          appHelper.reRouteUser(context, ConfigRoute.login, null);
        },
        leftbuttonText: tryAgainError,
        rightbuttonText: cancel,
      );
    }
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(openMailApp),
          content: const Text(noMailApp),
          actions: <Widget>[
            TextButton(
              child: const Text(ok),
              onPressed: () {
                appHelper.reRouteUser(context, ConfigRoute.login, null);
              },
            )
          ],
        );
      },
    );
  }
}
