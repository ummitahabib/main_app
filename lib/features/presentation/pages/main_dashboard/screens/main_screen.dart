import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/views/mobile/inst_dashboard_mobile.dart';
import 'package:smat_crow/features/presentation/pages/home_page/screens/home_page.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/marquee.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/widgets/nav_bar.dart';
import 'package:smat_crow/features/presentation/pages/news/views/presentation/screens/news_page_animated_tab.dart';
import 'package:smat_crow/features/presentation/pages/profile/profile_main_screen.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils/geolocation_service.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class MainDashboard extends StatefulHookConsumerWidget {
  const MainDashboard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainDashboardState();
}

class _MainDashboardState extends ConsumerState<MainDashboard> {
  late int currentTab;
  late PageController pageController;
  final ApplicationHelpers appHelper = ApplicationHelpers();

  Map<String, List>? newsData = <String, List>{};

  @override
  void initState() {
    currentTab = SpacingConstants.int0;
    pageController = PageController(initialPage: currentTab);
    GeoLocatorService().getCurrentLocation().then((value) {
      setState(() {
        Session.position = value;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int index) {
    setState(() {
      currentTab = index;
    });
  }

  void switchPage(int index) {
    appHelper.trackButtonAndDeviceEvent(_getEventName(index));
    setState(() {
      currentTab = index;
      pageController.jumpToPage(index);
    });
  }

  void switchPage2(int index) {
    appHelper.trackButtonAndDeviceEvent(_getEventInstitutionName(index));
    setState(() {
      currentTab = index;
      pageController.jumpToPage(index);
    });
  }

  String _getEventName(int index) {
    switch (index) {
      case 0:
        return 'HOME_BUTTON_CLICKED';
      case 1:
        return 'NEWS_BUTTON_CLICKED';
      // case 2:
      //   return 'SOCIAL_BUTTON_CLICKED';
      case 2:
        return 'PROFILE_BUTTON_CLICKED';
      default:
        return 'ERROR_BUTTON_CLICKED';
    }
  }

  String _getEventInstitutionName(int index) {
    switch (index) {
      case 0:
        return 'HOME_BUTTON_CLICKED';
      case 1:
        return 'NEWS_BUTTON_CLICKED';
      // case 2:
      //   return 'SOCIAL_BUTTON_CLICKED';
      case 2:
        return 'INSTITUTION_BUTTON_CLICKED';
      case 3:
        return 'PROFILE_BUTTON_CLICKED';
      default:
        return 'ERROR_BUTTON_CLICKED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final shared = ref.watch(sharedProvider);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(
        currentTab: currentTab,
        switchPage: shared.userInfo != null && shared.userInfo!.user.role.role == UserRole.institution.name
            ? switchPage2
            : switchPage,
      ),
      appBar: AppBar(
        title: const MarqueeWidget(),
        leading: const SizedBox.shrink(),
        leadingWidth: 0,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: onPageChanged,
          children: shared.userInfo != null && shared.userInfo!.user.role.role == UserRole.institution.name
              ? [
                  const HomePageMain(),
                  const NewsPage(),
                  //     const SocialHomePage(),
                  const InstDashboardViewMobile(),
                  const ProfileMainScreen(),
                ]
              : const [
                  HomePageMain(),
                  NewsPage(),
                  //     SocialHomePage(),
                  ProfileMainScreen(),
                ],
        ),
      ),
    );
  }
}
