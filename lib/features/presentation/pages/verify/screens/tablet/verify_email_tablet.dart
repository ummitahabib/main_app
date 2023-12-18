import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../verify_email_page.dart';

class VerifyEmailTablet extends StatelessWidget {
  const VerifyEmailTablet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VerifyEmailPage(
      image: SmatCrowLogo(),
      sizedBoxHeight: SpacingConstants.size59,
      imageSizedBox: SpacingConstants.size59,
      buttonSizeBox: SpacingConstants.size21,
    );
  }
}
