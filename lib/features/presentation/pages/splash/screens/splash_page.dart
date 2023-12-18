import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/assets/shared/shared/splash/splash_assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        if (mounted) {
          ApplicationHelpers().reRouteUser(context, ConfigRoute.onboarding, emptyString);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Responsive(
        mobile: SplashImage(),
        tablet: SplashImage(),
        desktop: SplashImage(),
      ),
    );
  }
}

class SplashImage extends StatelessWidget {
  const SplashImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Image.asset(
          SplashAssets.splashLogo,
          width: MediaQuery.of(context).size.width * SpacingConstants.size05,
          height: MediaQuery.of(context).size.height * SpacingConstants.size05,
        ),
      ),
    );
  }
}
