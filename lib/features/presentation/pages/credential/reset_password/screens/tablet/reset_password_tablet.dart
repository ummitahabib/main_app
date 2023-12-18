import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../reset_main.dart';

// reset password tablet view
class ResetPasswordTablet extends StatelessWidget {
  const ResetPasswordTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResetPassword(
      image: SmatCrowLogo(),
    );
  }
}
