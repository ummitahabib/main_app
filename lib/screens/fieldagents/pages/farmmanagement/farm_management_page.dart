import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../utils/colors.dart';
import '../../../../utils/constants.dart';
import '../../widgets/field_agent_statistics_carousel_holder.dart';
import '../../widgets/field_agents_organizations_list.dart';

class FarmManagementPage extends StatefulWidget {
  const FarmManagementPage({Key? key}) : super(key: key);

  @override
  _FarmManagementPageState createState() {
    return _FarmManagementPageState();
  }
}

class _FarmManagementPageState extends State<FarmManagementPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        title: Text('Farm Manager',
            overflow: TextOverflow.fade,
            style: GoogleFonts.poppins(
                textStyle: const TextStyle(
              color: AppColors.fieldAgentText,
              fontSize: 16.0,
            ),),),
        leading: IconButton(
            icon: const Icon(
              Icons.keyboard_backspace_rounded,
              color: AppColors.fieldAgentText,
            ),
            onPressed: () {
              pandora.logAPPButtonClicksEvent('FARM_MANAGER_BACK_BTN');
              Navigator.pop(context);
            },),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      backgroundColor: AppColors.dashboardBackground,
      body: Container(
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20),
                child: FieldAgentStatisticsCarouselHolder(),
              ),
              const SizedBox(
                height: 10.0,
              ),
              FieldAgentsOrganizationsList(
                fieldAgentId: USER_ID,
              )
            ],
          ),
        ),),
      ),
    );
  }
}
