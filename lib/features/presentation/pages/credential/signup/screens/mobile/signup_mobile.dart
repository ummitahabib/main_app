import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../signup_main.dart';

// signup mobile view

class SignUpMobile extends StatelessWidget {
  const SignUpMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignUpMainPage(
      image: SmatCrowLogo(),
    );
  }
}
