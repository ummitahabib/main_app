import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../forget_password_main.dart';

//forget password tablet view

class ForgetPasswordTablet extends StatelessWidget {
  const ForgetPasswordTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ForgetPasswordPage(
      buttonSizeBoxHeight: SpacingConstants.size42,
      image: SmatCrowLogo(),
    );
  }
}
