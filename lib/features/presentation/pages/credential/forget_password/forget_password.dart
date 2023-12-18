import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/credential/forget_password/screens/desktop/forget_password_desktop.dart';
import 'package:smat_crow/features/presentation/pages/credential/forget_password/screens/mobile/forget_password_mobile.dart';
import 'package:smat_crow/features/presentation/pages/credential/forget_password/screens/tablet/forget_password_tablet.dart';
import 'package:smat_crow/utils2/responsive.dart';

//forget password responsive page

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      tablet: ForgetPasswordTablet(),
      mobile: ForgetPasswordMobile(),
      desktop: ForgetPasswordDesktop(),
    );
  }
}
