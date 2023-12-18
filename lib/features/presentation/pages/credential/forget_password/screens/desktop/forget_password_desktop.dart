import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/onboarding_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../forget_password_main.dart';

//forget password desktop view

class ForgetPasswordDesktop extends StatefulWidget {
  const ForgetPasswordDesktop({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordDesktop> createState() => _ForgetPasswordDesktopState();
}

class _ForgetPasswordDesktopState extends State<ForgetPasswordDesktop> {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        OnboardingConstants(),
        Expanded(
          child: Center(
            child: ForgetPasswordPage(
              textFieldWidth: SpacingConstants.size408,
              buttonSizeBoxHeight: SpacingConstants.size40,
              sizedBoxHeight: SpacingConstants.size48,
              extraSizeBox: SpacingConstants.size185,
            ),
          ),
        ),
      ],
    );
  }
}
