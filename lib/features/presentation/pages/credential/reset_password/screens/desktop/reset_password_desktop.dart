import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/onboarding_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../reset_main.dart';

// reset password desktop view
class ResetPasswordDesktop extends StatefulWidget {
  const ResetPasswordDesktop({Key? key}) : super(key: key);

  @override
  State<ResetPasswordDesktop> createState() => _ResetPasswordDesktopState();
}

class _ResetPasswordDesktopState extends State<ResetPasswordDesktop> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const OnboardingConstants(),
        Expanded(
          child: Container(
            color: AppColors.SmatCrowDefaultWhite,
            child: const ResetPassword(
              textFieldWidth: SpacingConstants.size408,
            ),
          ),
        ),
      ],
    );
  }
}
