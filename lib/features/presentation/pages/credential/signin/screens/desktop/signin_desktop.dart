import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/onboarding_constants.dart';
import 'package:smat_crow/utils2/signin_route_config.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../signin_main.dart';

// signin desktop view

class LoginPageDesktop extends StatelessWidget {
  final LoginRouteConfig? loginRouterConfig;
  const LoginPageDesktop({
    Key? key,
    this.loginRouterConfig,
  }) : super(key: key);
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
              buttonSizeBox: SpacingConstants.size90,
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
