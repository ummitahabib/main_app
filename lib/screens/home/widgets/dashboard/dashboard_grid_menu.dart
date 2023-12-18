import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/user_by_id_response.dart';
import 'package:smat_crow/network/crow/user_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/dashboard_grid_item.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/constants.dart';

class DashboardGridMenu extends StatefulWidget {
  final String userId;

  const DashboardGridMenu({Key? key, required this.userId}) : super(key: key);

  @override
  _DashboardGridMenuState createState() => _DashboardGridMenuState();
}

class _DashboardGridMenuState extends State<DashboardGridMenu> {
  GetUserByIdResponse? _userByIdResponse;
  final AsyncMemoizer _profileAsync = AsyncMemoizer();
  final farmMenu = dashboardMenuList;
  List<Widget> dashboardGridItem = [];
  final Pandora _pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.none &&
        //         snapshot.hasData == null ||
        //     snapshot.connectionState == ConnectionState.waiting) {
        //
        // }
        if (snapshot.hasError) {
          return Center(child: Text("ERR ${snapshot.error}"));
        }
        if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(0),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: MediaQuery.of(context).size.height * 0.001500,
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              shrinkWrap: true,
              children: dashboardGridItem,
            ),
          );
        }
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: GridLoader(),
        );
      },
      future: getUserInformation(widget.userId),
    );
  }

  Future getUserInformation(String userId) async {
    return _profileAsync.runOnce(() async {
      _userByIdResponse = await getUserById(userId);

      setState(() {
        if (farmMenu.isEmpty) {
          return;
          //
        } else {
          for (final element in _userByIdResponse!.role!.subscription!.permissions!) {
            debugPrint("elemnts from permision $element");
            if (element.name == AppPermissions.user_field_manager) {
              dashboardGridItem.add(
                DashboardGridItem(
                  route: farmMenu[0]["route"],
                  image: farmMenu[0]["image"],
                  text: farmMenu[0]["text"],
                  background: farmMenu[0]["background"],
                ),
              );
            }

            if (element.name == AppPermissions.farm_shop) {
              dashboardGridItem.add(
                DashboardGridItem(
                  route: farmMenu[2]["route"],
                  image: farmMenu[2]["image"],
                  text: farmMenu[2]["text"],
                  background: farmMenu[2]["background"],
                ),
              );

              if (element.name == AppPermissions.farm_sense_devices) {
                dashboardGridItem.add(
                  DashboardGridItem(
                    route: farmMenu[4]["route"],
                    image: farmMenu[4]["image"],
                    text: farmMenu[4]["text"],
                    background: farmMenu[4]["background"],
                  ),
                );
              }
            }

            if (element.name == AppPermissions.field_pro_offline) {
              _pandora.saveToSharedPreferences('field_pro_offline', 'Y');
            }

            if (element.name == AppPermissions.field_pro_in_app) {
              _pandora.saveToSharedPreferences('field_pro_in_app', 'Y');
            }
          }

          _userByIdResponse!.role!.role == AppPermissions.field_agents
              ? dashboardGridItem.add(
                  DashboardGridItem(
                    route: farmMenu[1]["route"],
                    image: farmMenu[1]["image"],
                    text: farmMenu[1]["text"],
                    background: farmMenu[1]["background"],
                    // ignore: unnecessary_statements
                  ),
                )
              // ignore: unnecessary_statements
              : null;

          dashboardGridItem.add(
            DashboardGridItem(
              route: farmMenu[3]["route"],
              image: farmMenu[3]["image"],
              text: farmMenu[3]["text"],
              background: farmMenu[3]["background"],
            ),
          );
        }
      });
      return _userByIdResponse;
    });
  }
}
