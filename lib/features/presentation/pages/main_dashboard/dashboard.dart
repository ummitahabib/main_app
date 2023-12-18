import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/screens/desktop/main_dashboard_desktop.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/screens/mobile/main_dashboard_mobile.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/screens/tablet/main_page_tablet.dart';
import 'package:smat_crow/utils2/responsive.dart';

//main dashboard responsive

class Dashbaord extends StatelessWidget {
  final String? uid;
  // final AppEntity appEntity;
  const Dashbaord({
    super.key,
    this.uid,
    //  required this.appEntity
  });

  @override
  Widget build(BuildContext context) {
    String? uid;
    return Responsiveness(
      desktop: MainDashboardDesktop(
        uid: uid!,
      ),
      tablet: MainDashboardTablet(
        uid: uid,
        // appEntity: appEntity,
      ),
      mobile: MainDashboardMobile(
        uid: uid,
        // appEntity: appEntity,
      ),
    );
  }
}
