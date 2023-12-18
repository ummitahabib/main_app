import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/profile/screens/desktop_profile.dart';
import 'package:smat_crow/features/presentation/pages/profile/screens/mobile_profile.dart';
import 'package:smat_crow/features/presentation/pages/profile/screens/tablet_profile.dart';
import 'package:smat_crow/utils2/responsive.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({
    Key? key,
    this.uid,
  }) : super(key: key);
  final String? uid;

  @override
  State<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: ProfileMobile(),
      tablet: ProfileTablet(),
      desktop: ProfileDesktop(),
    );
  }
}
