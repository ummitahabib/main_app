import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get_it/get_it.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmsense/widgets/farm_sense_devices.dart';
import 'package:smat_crow/screens/farmtools/widgets/field_tools_menu.dart';
import 'package:smat_crow/utils/colors.dart';

class DashboardGridItem extends StatelessWidget {
  final String text, image, route;
  final Color background;

  const DashboardGridItem({
    Key? key,
    required this.text,
    required this.background,
    required this.image,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();

    return Card(
      color: background,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          pandora.logAPPButtonClicksEvent(
            'DASHBOARD_ITEM_${route.replaceAll('/', '').toUpperCase()}_CLICKED',
          );
          if (route == '/farmShop') {
            //TODO remove for farmchop
            OneContext().showSnackBar(
              builder: (_) => const SnackBar(content: Text('Not Available')),
            );
            //pandora.reRouteUser(context, route, 'null');
          } else if (route == '/farmTools') {
            GetIt.I<FirebaseAnalytics>()
                .setCurrentScreen(screenName: 'FARM_TOOLS_SCREEN');
            displayModalWithChild(const FarmToolsMenu(), 'Farm Tools', context);
          } else if (route == '/farmSense') {
            GetIt.I<FirebaseAnalytics>()
                .setCurrentScreen(screenName: 'FARM_SENSE_SCREEN');
            displayModalWithChild(
              const FarmSenseDevices(),
              'Your Devices',
              context,
            );
          } else {
            pandora.reRouteUser(context, route, 'null');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    image,
                    width: 40.0,
                    height: 40.0,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: const TextStyle(
                      color: AppColors.dashGridTextColor,
                      fontSize: 13.0,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'regular',
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
