import 'package:flutter/material.dart';
import 'package:smat_crow/features/institution/views/mobile/institution_settings_mobile.dart';
import 'package:smat_crow/features/institution/views/web/institution_settings_web.dart';
import 'package:smat_crow/utils2/responsive.dart';

class InstitutionSettings extends StatelessWidget {
  const InstitutionSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: InstitutionSettingsWeb(),
      desktopTablet: InstitutionSettingsWeb(),
      tablet: InstitutionSettingsMobile(),
      mobile: InstitutionSettingsMobile(),
    );
  }
}
