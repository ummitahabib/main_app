import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../verify_email_page.dart';

class VerifyEmailMobile extends StatelessWidget {
  const VerifyEmailMobile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerifyEmailPage(
      image: SmatCrowLogo(),
    );
  }
}
