import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/signin_route_config.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../signin_main.dart';

// signin mobile view

class LoginPageMobile extends StatefulWidget {
  final LoginRouteConfig? loginRouterConfig;
  // final AppEntity? appEntity;
  const LoginPageMobile({
    super.key,
    this.loginRouterConfig,
    //this.appEntity
  });

  @override
  State<LoginPageMobile> createState() => _LoginPageMobileState();
}

class _LoginPageMobileState extends State<LoginPageMobile> {
  @override
  Widget build(BuildContext context) {
    return SignInMainPage(
      fieldWidth: SpacingConstants.size342,
      buttonWidth: SpacingConstants.size342,
      sizeHeight: SpacingConstants.size42,
      logoSizeBox: SpacingConstants.size40,
      buttonSizeBox: SpacingConstants.size45,
      image: SmatCrowLogo(),
      // appEntity: widget.appEntity!,
    );
  }
}
