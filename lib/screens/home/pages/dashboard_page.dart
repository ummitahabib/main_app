import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smat_crow/network/crow/models/user_response.dart';
import 'package:smat_crow/network/crow/user_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';
import 'package:smat_crow/screens/fieldagents/widgets/promos_carousel.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/commodity_prices_marquee.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/dashboard_grid_menu.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/dashboard_weather.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/header_with_image.dart';
import 'package:smat_crow/screens/splash/splash_page.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../network/crow/models/request/update_device_id.dart';
import '../../../network/crow/notifications_operations.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;
  String firstName = '', lastName = '', email = '';
  UserDetailsResponse? _userDetailsResponse;
  final AsyncMemoizer _profileAsync = AsyncMemoizer();

  Pandora pandora = Pandora();

  @override
  void initState() {
    super.initState();
    getProfileInformation();
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _showLoader() {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 40),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
            return _showLoader();
          }
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white,
                ),
                SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Container(
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 230,
                          color: AppColors.headerTopHalf,
                        ),
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const CommodityPricesMarquee(),
                            Container(
                              margin: const EdgeInsets.only(
                                left: 20.0,
                                right: 20.0,
                                top: 10.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HeaderWithImage(
                                    firstName: firstName,
                                    lastName: lastName,
                                    email: email,
                                  ),
                                  const SizedBox(
                                    height: 22.0,
                                  ),
                                  const DashboardWeather(),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  const Text(
                                    'What would you like to do today',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'regular',
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  DashboardGridMenu(
                                    userId: _userDetailsResponse!.user!.id!,
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  const PromosCarousel(),
                                  const SizedBox(
                                    height: 18.0,
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        },
        future: getProfileInformation(),
      ),
    );
  }

  Future getProfileInformation() async {
    return _profileAsync.runOnce(() async {
      _userDetailsResponse = await getUserDetails();
      if (_userDetailsResponse != null) {
        Session.userDetailsResponse = _userDetailsResponse;
        setState(() {
          firstName = _userDetailsResponse!.user!.firstName!;
          email = _userDetailsResponse!.user!.email!;
        });
        await updateDeviceToken(
          UpdateDeviceIdRequest(
            notificationToken: Session.FirebaseDeviceToken,
            userId: Session.userDetailsResponse!.user!.id!,
          ),
        );
      } else {
        pandora.clearUserData();
        await Fluttertoast.showToast(
          msg: 'Oops... An Error Occurred',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
        );
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SplashPage(),
          ),
          (route) => false,
        );
      }
      return _userDetailsResponse;
    });
  }
}
