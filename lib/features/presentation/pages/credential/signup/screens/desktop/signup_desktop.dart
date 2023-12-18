import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/onboarding_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../signup_main.dart';

class SignUpDesktop extends StatefulWidget {
  const SignUpDesktop({Key? key}) : super(key: key);

  @override
  State<SignUpDesktop> createState() => _SignUpDesktopState();
}

class _SignUpDesktopState extends State<SignUpDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        OnboardingConstants(),
        Expanded(
          child: Center(
            child: SignUpMainPage(
              imageHeight: SpacingConstants.size0,
              signUpBottonWidth: SpacingConstants.size408,
              width: SpacingConstants.size408,
            ),
          ),
        ),
      ],
    );
  }
}
