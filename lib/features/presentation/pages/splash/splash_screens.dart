import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/splash/screens/splash_page_desktop.dart';
import 'package:smat_crow/features/presentation/pages/splash/screens/splash_page_mobile.dart';
import 'package:smat_crow/features/presentation/pages/splash/screens/splash_page_tablet.dart';
import 'package:smat_crow/utils2/responsive.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: SplashMobile(),
      tablet: SplashTablet(),
      desktop: SplashDesktop(),
    );
  }
}
