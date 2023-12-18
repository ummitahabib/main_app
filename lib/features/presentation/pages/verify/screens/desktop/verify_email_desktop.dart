import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/onboarding_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../verify_email_page.dart';

class VerifyEmailDesktop extends StatefulWidget {
  const VerifyEmailDesktop({Key? key}) : super(key: key);

  @override
  State<VerifyEmailDesktop> createState() => _VerifyEmailDesktopState();
}

class _VerifyEmailDesktopState extends State<VerifyEmailDesktop> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const OnboardingConstants(),
        Expanded(
          child: Container(
            color: AppColors.SmatCrowDefaultWhite,
            child: const VerifyEmailPage(
              mailLogoHeight: SpacingConstants.size150,
              mailLogoWidth: SpacingConstants.size152,
              sizedBoxHeight: SpacingConstants.size34,
              imageSizedBox: SpacingConstants.size10,
              buttonSizeBox: SpacingConstants.size21,
            ),
          ),
        ),
      ],
    );
  }
}
