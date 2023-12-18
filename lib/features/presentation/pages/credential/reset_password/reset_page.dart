import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/features/presentation/pages/credential/reset_password/screens/desktop/reset_password_desktop.dart';
import 'package:smat_crow/features/presentation/pages/credential/reset_password/screens/mobile/reset_password_mobile.dart';
import 'package:smat_crow/features/presentation/pages/credential/reset_password/screens/tablet/reset_password_tablet.dart';

// reset password responsive page

class ResetPasswordPage extends StatelessWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Responsiveness(
      mobile: ResetPasswordMobile(),
      desktop: ResetPasswordDesktop(),
      tablet: ResetPasswordTablet(),
    );
  }
}
