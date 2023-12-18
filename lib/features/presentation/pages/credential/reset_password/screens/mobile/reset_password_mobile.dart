import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../reset_main.dart';

// reset password mobile view
class ResetPasswordMobile extends StatelessWidget {
  const ResetPasswordMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResetPassword(
      image: SmatCrowLogo(),
    );
  }
}
