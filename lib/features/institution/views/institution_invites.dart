import 'package:flutter/material.dart';
import 'package:smat_crow/features/institution/views/mobile/manage_invite_mobile.dart';
import 'package:smat_crow/features/institution/views/web/manage_invite_web.dart';
import 'package:smat_crow/utils2/responsive.dart';

class InstitutionInvites extends StatelessWidget {
  const InstitutionInvites({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: ManageInviteWeb(),
      desktopTablet: ManageInviteWeb(),
      tablet: ManageInviteMobile(),
      mobile: ManageInviteMobile(),
    );
  }
}
