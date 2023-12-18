import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../signup_main.dart';

// signup tablet view

class SignupTablet extends StatelessWidget {
  const SignupTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignUpMainPage(
      image: SmatCrowLogo(),
      height: SpacingConstants.size94,
      signupSizedBox: SpacingConstants.size40,
    );
  }
}
