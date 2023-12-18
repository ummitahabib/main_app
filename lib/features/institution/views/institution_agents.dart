import 'package:flutter/material.dart';
import 'package:smat_crow/features/institution/views/mobile/agent_mobile.dart';
import 'package:smat_crow/features/institution/views/web/agent_table_web.dart';
import 'package:smat_crow/utils2/responsive.dart';

class InstitutionAgents extends StatelessWidget {
  const InstitutionAgents({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      desktop: AgentTableWeb(),
      desktopTablet: AgentTableWeb(),
      tablet: AgentMobile(),
      mobile: AgentMobile(),
    );
  }
}
