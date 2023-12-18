import 'package:flutter/material.dart';
import 'package:smat_crow/features/institution/views/mobile/notification_mobile.dart';
import 'package:smat_crow/features/institution/views/web/notification_settings_web.dart';
import 'package:smat_crow/utils2/responsive.dart';

class InstitutionNottySettings extends StatelessWidget {
  const InstitutionNottySettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: NotificationSettingsWeb(),
      desktopTablet: NotificationSettingsWeb(),
      tablet: NotificationMobile(),
      mobile: NotificationMobile(),
    );
  }
}
