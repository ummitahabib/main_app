import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/credential/signin/screens/signin_main.dart';
import 'package:smat_crow/utils2/onboarding_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class OnboardingDesktop extends StatelessWidget {
  const OnboardingDesktop({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        OnboardingConstants(),
        Expanded(
          child: Center(
            child: SignInMainPage(
              fieldWidth: SpacingConstants.size408,
              buttonWidth: SpacingConstants.size408,
              buttonHeight: SpacingConstants.size47,
              buttonSizeBox: SpacingConstants.size155,
              textSizeBox: SpacingConstants.size48,
              sizeHeight: SpacingConstants.size54,
              width: SpacingConstants.size408,
            ),
          ),
        ),
      ],
    );
  }
}
