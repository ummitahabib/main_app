import 'package:flutter/material.dart';
import 'package:smat_crow/features/institution/views/mobile/institution_organization_mobile.dart';
import 'package:smat_crow/features/institution/views/web/institution_organzation_web.dart';
import 'package:smat_crow/utils2/responsive.dart';

class InstitutionOrganization extends StatelessWidget {
  const InstitutionOrganization({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: InstitutionOrganizationWeb(),
      desktopTablet: InstitutionOrganizationWeb(),
      tablet: InstitutionOrganizationMobile(),
      mobile: InstitutionOrganizationMobile(),
    );
  }
}
