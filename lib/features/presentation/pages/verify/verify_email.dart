import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/verify/screens/desktop/verify_email_desktop.dart';
import 'package:smat_crow/features/presentation/pages/verify/screens/mobile/verify_email_mobile.dart';
import 'package:smat_crow/features/presentation/pages/verify/screens/tablet/verify_email_tablet.dart';
import 'package:smat_crow/utils2/responsive.dart';

class VerifyEmail extends StatelessWidget {
  const VerifyEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: VerifyEmailMobile(),
      tablet: VerifyEmailTablet(),
      desktop: VerifyEmailDesktop(),
    );
  }
}
