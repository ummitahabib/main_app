import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/credential/signup/screens/desktop/signup_desktop.dart';
import 'package:smat_crow/features/presentation/pages/credential/signup/screens/mobile/signup_mobile.dart';
import 'package:smat_crow/features/presentation/pages/credential/signup/screens/tablet/signup_tablet.dart';
import 'package:smat_crow/utils2/responsive.dart';

// signup responsive page

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Responsiveness(
      mobile: SignUpMobile(),
      tablet: SignupTablet(),
      desktop: SignUpDesktop(),
    );
  }
}
