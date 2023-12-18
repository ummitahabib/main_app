import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/signin_route_config.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../signin_main.dart';

// signin tablet view

class LoginPageTablet extends StatelessWidget {
  final LoginRouteConfig? loginRouterConfig;
  const LoginPageTablet({
    Key? key,
    this.loginRouterConfig,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SignInMainPage(
      fieldWidth: SpacingConstants.size342,
      buttonWidth: SpacingConstants.size342,
      logoSizeBox: SpacingConstants.size59,
      buttonSizeBox: SpacingConstants.size100,
      image: SmatCrowLogo(),
    );
  }
}
