// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/onboarding/screens/mobile/onboarding_mobile.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class Animations {
  static Future<void> signInAnimation(BuildContext context) async {
    await Future.delayed(
      const Duration(milliseconds: SpacingConstants.size300),
    );
    // Trigger the animation only if the user is signed in
    const bool isSignedIn = true; // Will be Replace with  sign-in logic
    if (isSignedIn) {
      await Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) {
            return const MobileOnboarding(); // will be replace with the next screen
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      );
    }
  }
}
