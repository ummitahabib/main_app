// ignore_for_file: deprecated_member_use

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/feeds/network/rss_to_json.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/pages/information_page.dart';
import 'package:smat_crow/screens/home/pages/smat_ml_page.dart';
import 'package:smat_crow/utils/colors.dart';

import '../farmprobe/farm_probe_menu.dart';
import 'pages/community_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/news_page.dart';
import 'pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    Key? key,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0;
  final List<Widget> screens = [
    const DashboardPage(),
    const InformationPage(),
    const NewsPage(),
    const SmatMlPage(),
    const CommunityPage(),
    const ProfilePage(),
  ];

  Map<String, List> newsData = <String, List>{};
  bool isLoading = true;
  late Widget currentScreen;
  final Pandora _pandora = Pandora();

  getData() async {
    await Future.wait([
      rssToJson('agriculture'),
      rssToJson('agriculture+in+nigeria'),
      rssToJson('agriculture+in+africa'),
      rssToJson('agriculture+in+north+america'),
      rssToJson('agriculture+in+south+america'),
      rssToJson('agriculture+in+europe'),
      rssToJson('agriculture+in+middle+east'),
      rssToJson('agriculture+in+asia'),
      rssToJson('agriculture+in+australia'),
    ])
        .then((value) {
          newsData['agriculture'] = value[0];
          newsData['nigeria'] = value[1];
          newsData['africa'] = value[2];
          newsData['north-america'] = value[3];
          newsData['south-america'] = value[4];
          newsData['europe'] = value[5];
          newsData['middle-east'] = value[6];
          newsData['asia'] = value[7];
          newsData['australia'] = value[8];

          setState(() {
            isLoading = false;
          });
        })
        .timeout(const Duration(seconds: 10))
        .whenComplete(
          () => setState(() {
            isLoading = false;
          }),
        );
  }

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    super.initState();
    getData();
    Provider.of<FirebaseOperations>(context, listen: false).initUserData(context);
    currentScreen = const DashboardPage();
  }

  @override
  Widget build(BuildContext context) {
    return (currentTab == 6)
        ? SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.fieldAgentDashboard,
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : DoubleBackToCloseApp(
                      snackBar: const SnackBar(
                        content: Text('Tap back again to leave'),
                      ),
                      child: PageStorage(bucket: bucket, child: currentScreen),
                    ),
              floatingActionButton: FloatingActionButton(
                mini: true,
                child: SvgPicture.asset('assets/nsvgs/ml/close_fab.svg'),
                onPressed: () {
                  setState(() {
                    currentScreen = const DashboardPage();
                    currentTab = 0;
                  });
                },
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            ),
          )
        : SafeArea(
            child: Scaffold(
              backgroundColor: AppColors.fieldAgentDashboard,
              body: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : DoubleBackToCloseApp(
                      snackBar: const SnackBar(
                        content: Text('Tap back again to leave'),
                      ),
                      child: PageStorage(bucket: bucket, child: currentScreen),
                    ),
              bottomNavigationBar: bottomNavigationBar(),
            ),
          );
  }

  BottomNavigationBar bottomNavigationBar() {
    return BottomNavigationBar(
      onTap: (int index) {
        switchPage(index);
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: currentTab,
      selectedItemColor: AppColors.landingOrangeButton,
      elevation: 0,
      selectedLabelStyle: const TextStyle(fontSize: 12, fontFamily: 'regular', color: AppColors.landingOrangeButton),
      unselectedLabelStyle: const TextStyle(fontSize: 12, fontFamily: 'regular', color: AppColors.unselectedItemColor),
      items: [
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/home.svg',
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/home.svg',
              color: AppColors.landingOrangeButton,
            ),
          ),
          label: 'Dashboard',
        ),
        const BottomNavigationBarItem(
          icon: Padding(
            padding: EdgeInsets.only(bottom: 11.67),
            child: Icon(EvaIcons.activity, color: AppColors.unselectedItemColor),
          ),
          activeIcon: Padding(
            padding: EdgeInsets.only(bottom: 11.67),
            child: Icon(EvaIcons.activity, color: AppColors.landingOrangeButton),
          ),
          label: 'News',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/category.svg',
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/category.svg',
              color: AppColors.landingOrangeButton,
            ),
          ),
          label: 'Highlights',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/scan.svg',
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/scan.svg',
              color: AppColors.landingOrangeButton,
            ),
          ),
          label: 'Farm Probe',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/chat.svg',
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/chat.svg',
              color: AppColors.landingOrangeButton,
            ),
          ),
          label: 'Community',
        ),
        BottomNavigationBarItem(
          icon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/profile.svg',
              color: AppColors.unselectedItemColor,
            ),
          ),
          activeIcon: Padding(
            padding: const EdgeInsets.only(bottom: 11.67),
            child: SvgPicture.asset(
              'assets/nsvgs/dashboard/profile.svg',
              color: AppColors.landingOrangeButton,
            ),
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  void switchPage(int index) {
    switch (index) {
      case 0:
        _pandora.logAPPButtonClicksEvent('DASHBOARD_BUTTON_CLICKED');
        setState(() {
          currentScreen = const DashboardPage();
          currentTab = 0;
        });
        break;
      case 1:
        _pandora.logAPPButtonClicksEvent('INFO_BUTTON_CLICKED');
        setState(() {
          currentScreen = InformationPage(
            newsData: newsData,
          );
          currentTab = 1;
        });
        break;
      case 2:
        _pandora.logAPPButtonClicksEvent('FEEDS_BUTTON_CLICKED');
        setState(() {
          currentScreen = const NewsPage();
          currentTab = 2;
        });
        break;
      case 3:
        _pandora.logAPPButtonClicksEvent('DISEASE_DETECTION_BUTTON_CLICKED');
        setState(() {
          displayModalWithChild(const FarmProbeMenu(), 'Farm Probe', context);
        });
        break;
      case 4:
        _pandora.logAPPButtonClicksEvent('MESSAGING_BUTTON_CLICKED');
        setState(() {
          currentScreen = const CommunityPage();
          currentTab = 4;
        });
        break;
      case 5:
        setState(() {
          _pandora.logAPPButtonClicksEvent('PROFILE_BUTTON_CLICKED');
          currentScreen = const ProfilePage();
          currentTab = 5;
        });
        break;
    }
  }
}
