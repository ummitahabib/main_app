import 'package:smat_crow/utils2/constants.dart';

class MenuItemModel {
  final String name;
  final String asset;
  final String route;

  MenuItemModel({
    required this.name,
    required this.asset,
    this.route = emptyString,
  });
}
