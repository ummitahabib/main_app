import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/home_page/screens/desktop/home_desktop.dart';
import 'package:smat_crow/utils2/responsive.dart';

import 'screens/mobile/home_page_mobile.dart';
import 'screens/tablet/home_page_tablet.dart';

//home desktop responsive

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      tablet: HomePageTablet(),
      mobile: HomePageMobile(),
      desktop: HomeDesktop(),
    );
  }
}
