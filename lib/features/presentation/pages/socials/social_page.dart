import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/socials/screens/mobile/social_page_mobile.dart';
import 'package:smat_crow/utils2/responsive.dart';

import 'screens/desktop/social_page_desktop.dart';

class SocialPage extends StatefulWidget {
  const SocialPage({
    Key? key,
    this.uid,
  }) : super(key: key);

  final String? uid;

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: SocialMobile(),
      tablet: SocialMobile(),
      desktop: SocialDesktop(),
    );
  }
}
