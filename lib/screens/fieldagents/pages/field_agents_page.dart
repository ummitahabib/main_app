import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/fieldagents/widgets/field_agents_grid_menu.dart';
import 'package:smat_crow/screens/fieldagents/widgets/recent_missions_list.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/dashboard_weather.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../utils/styles.dart';

class FieldAgentsPage extends StatefulWidget {
  const FieldAgentsPage({Key? key}) : super(key: key);

  @override
  _FieldAgentsPageState createState() => _FieldAgentsPageState();
}

class _FieldAgentsPageState extends State<FieldAgentsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        title: Text('Field Agents',
            overflow: TextOverflow.fade, style: GoogleFonts.poppins(textStyle: Styles.TextStyleField()),),
        leading: IconButton(
            icon: const Icon(
              Icons.keyboard_backspace_rounded,
              color: AppColors.fieldAgentText,
            ),
            onPressed: () {
              pandora.logAPPButtonClicksEvent('FIELD_AGENTS_PAGE_BACK_BUTTON_CLICKED');
              Navigator.pop(context);
            },),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      backgroundColor: AppColors.fieldAgentDashboard,
      body: Container(
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: FieldAgentGridMenu(),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: DashboardWeather(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              AgentMissionsList(
                fieldAgentId: USER_ID,
              )
            ],
          ),
        ),),
      ),
    );
  }
}
