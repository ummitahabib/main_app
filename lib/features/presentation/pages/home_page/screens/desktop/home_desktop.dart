import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_assistant/views/pages/farm_assistant_base_ui.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/activity_widget.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/text_widget.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/weather_widget.dart';
import 'package:smat_crow/features/presentation/widgets/desktop_constants.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

// home desktop view

final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

class HomeDesktop extends StatelessWidget {
  const HomeDesktop({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const FarmAssistantBaseUi(),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DesktopDashboardConstant(),
            //  const UserInfoWidget(),
            Padding(
              padding: const EdgeInsets.only(
                left: SpacingConstants.size40,
                top: SpacingConstants.size12,
              ),
              child: Row(
                children: [
                  Text(
                    welcomeBack,
                    style: Styles.dashboradTextStyle(),
                  ),
                ],
              ),
            ),
            const WeatherWidget(),
            const Padding(
              padding: EdgeInsets.only(
                left: SpacingConstants.size40,
                top: SpacingConstants.size10,
              ),
              child: Row(
                children: [
                  TextWidget(),
                ],
              ),
            ),
            customSizedBoxHeight(SpacingConstants.size12),
            const Padding(
              padding: EdgeInsets.only(
                left: SpacingConstants.size10,
                right: SpacingConstants.size70,
                top: SpacingConstants.size20,
              ),
              child: SizedBox(
                height: SpacingConstants.size275,
                width: SpacingConstants.size900,
                child: ActivityWidgets(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
