import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/views/pages/organisation.dart';
import 'package:smat_crow/features/organisation/views/pages/web/site_details_web.dart';
import 'package:smat_crow/utils2/constants.dart';

final orgNavigationProvider = ChangeNotifierProvider<OrgNavigationNotifier>((ref) {
  return OrgNavigationNotifier();
});

class OrgNavigationNotifier extends ChangeNotifier {
  PageController _pageController = PageController();
  PageController get pageController => _pageController;

  PageController _mapPageController = PageController();
  PageController get mapPageController => _mapPageController;

  set pageController(PageController controller) {
    _mapPageController = controller;
    notifyListeners();
  }

  set mapPageController(PageController controller) {
    _pageController = controller;
    notifyListeners();
  }

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  Future<dynamic> navigateTo(
    String routeName, {
    Map<String, String>? queryParams,
  }) {
    routeName = Uri(path: routeName, queryParameters: queryParams).toString();
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Route<dynamic> generateRoute(RouteSettings settings) {
    final routingData = settings.name!.getRoutingData; // Get the routing Data
    switch (routingData.route) {
      // Switch on the path from the data
      case ConfigRoute.siteDetails:
        return _getPageRoute(const SiteDetailsWeb(), settings);
      case "/org":
        return _getPageRoute(const Organization(), settings);
      default:
        return _getPageRoute(const Organization(), settings);
    }
  }
}

extension StringExtension on String {
  RoutingData get getRoutingData {
    final uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}

class RoutingData {
  final String route;
  final Map<String, String>? _queryParameters;

  RoutingData({
    required this.route,
    Map<String, String>? queryParameters,
  }) : _queryParameters = queryParameters;

  String? operator [](String key) => _queryParameters![key];
}

PageRoute _getPageRoute(Widget child, RouteSettings settings) {
  return _FadeRoute(child: child, routeName: settings.name!);
}

class _FadeRoute extends PageRouteBuilder {
  final Widget child;
  final String routeName;
  _FadeRoute({required this.child, required this.routeName})
      : super(
          settings: RouteSettings(name: routeName),
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              child,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
