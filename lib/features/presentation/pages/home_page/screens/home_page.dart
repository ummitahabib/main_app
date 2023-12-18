import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:smat_crow/features/farm_assistant/views/pages/farm_assistant_base_ui.dart';
import 'package:smat_crow/features/presentation/pages/home_page/screens/desktop/home_desktop.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/activity_widget.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/text_widget.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/user_info_desktop.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/user_info_widget.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/weather_widget.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class HomePageMain extends StatefulWidget {
  const HomePageMain({Key? key}) : super(key: key);

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Geolocator.getCurrentPosition().then(
        (value) {
          setState(() {
            Session.position = value;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: const FarmAssistantBaseUi(),
      backgroundColor: Colors.white,
      body: SizedBox(
        height: Responsive.yHeight(context),
        width: Responsive.xWidth(context),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (width < SpacingConstants.size550) const UserInfoWidget() else const UserInfoDesk(),
              const SizedBox(
                height: SpacingConstants.userInfoWidgetSpacing,
              ),
              const WeatherWidget(),
              customSizedBoxHeight(
                SpacingConstants.size20,
              ),
              const TextWidget(),
              customSizedBoxHeight(
                SpacingConstants.size20,
              ),
              const ActivityWidgets(),
              const SizedBox(
                height: SpacingConstants.activityWidgetSpacing,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
