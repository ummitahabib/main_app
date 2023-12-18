import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../network/crow/models/request/update_device_id.dart';
import '../../../network/crow/models/user_response.dart';
import '../../../network/crow/notifications_operations.dart';
import '../../../network/crow/user_operations.dart';
import '../../../pandora/pandora.dart';
import '../../../utils/colors.dart';
import '../../../utils/session.dart';
import '../../../utils/styles.dart';
import '../../farmmanager/widgets/loader_tile.dart';
import '../../fieldagents/widgets/promos_carousel.dart';
import '../../splash/splash_page.dart';
import '../../widgets/header_with_image.dart';
import '../widgets/dashboard/commodity_prices_marquee.dart';
import '../widgets/dashboard/dashboard_grid_menu.dart';
import '../widgets/dashboard/dashboard_weather.dart';

class DashboardProvider extends ChangeNotifier {
  int currentIndex = 0;
  UserDetailsResponse? _userDetailsResponse;
  String firstName = '', lastName = '', email = '';
  final AsyncMemoizer _profileAsync = AsyncMemoizer();
  Pandora pandora = Pandora();
  UserDetailsResponse? get userDetailsResponse => _userDetailsResponse;

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

  Widget dashBoardPage(BuildContext context) {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          try {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return _showLoader();
            }

            if (_userDetailsResponse == null) {
              return const Center(
                child: Text(
                  'Loading profile information...',
                  style: TextStyle(fontSize: 16.0),
                ),
              );
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
                                    if (userDetailsResponse != null)
                                      HeaderWithImage(
                                        firstName: userDetailsResponse!.user!.firstName!,
                                        lastName: userDetailsResponse!.user!.lastName!,
                                        email: userDetailsResponse!.user!.email!,
                                      ),
                                    const SizedBox(
                                      height: 22.0,
                                    ),
                                    const DashboardWeather(),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    Text(
                                      'What would you like to do today',
                                      style: Styles.labelTextStyle2(),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                    DashboardGridMenu(
                                      userId: userDetailsResponse!.user!.id!,
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
          } catch (error, stackTrace) {
            Fluttertoast.showToast(
              msg: "An error occurred: $error",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            debugPrint("Error: $error\nStack trace: $stackTrace");
            return const Center(
              child: Text(
                'Oops, something went wrong. Please try again later.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          }
        },
        future: getProfileInformation(context),
      ),
    );
  }

  Future getProfileInformation(BuildContext context) async {
    return _profileAsync.runOnce(() async {
      _userDetailsResponse = await getUserDetails();
      if (_userDetailsResponse != null) {
        Session.userDetailsResponse = _userDetailsResponse;
        firstName = _userDetailsResponse!.user!.firstName!;
        lastName = _userDetailsResponse!.user!.lastName!;
        email = _userDetailsResponse!.user!.email!;
        notifyListeners();
        await updateDeviceToken(
          UpdateDeviceIdRequest(
            notificationToken: Session.FirebaseDeviceToken,
            userId: Session.userDetailsResponse!.user!.id!,
          ),
        );
        debugPrint('getProfile executed');
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
