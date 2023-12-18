import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/credential/signin/screens/desktop/signin_desktop.dart';
import 'package:smat_crow/features/presentation/pages/credential/signin/screens/mobile/signin_mobile.dart';
import 'package:smat_crow/features/presentation/pages/credential/signin/screens/tablet/signin_tablet.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/signin_route_config.dart';

// signin responsive

class SigninPage extends StatelessWidget {
  final LoginRouteConfig? loginRouterConfig;
  const SigninPage({
    super.key,
    this.loginRouterConfig,
  });

  @override
  Widget build(BuildContext context) {
    return const Responsiveness(
      tablet: LoginPageTablet(),
      mobile: LoginPageMobile(),
      desktop: LoginPageDesktop(),
    );
  }
}
