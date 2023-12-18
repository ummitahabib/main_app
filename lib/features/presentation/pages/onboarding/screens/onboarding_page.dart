import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'desktop/onboarding_desktop.dart';
import 'mobile/onboarding_mobile.dart';
import 'tablet/onboarding_tablet.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Responsiveness(
      mobile: MobileOnboarding(),
      tablet: TabletOnboarding(),
      desktop: OnboardingDesktop(),
    );
  }
}
