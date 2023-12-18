import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RouteAnimator extends PageRouteBuilder {
  final Widget page;

  final RouteSettings? setting;
  RouteAnimator({required this.page, this.setting})
      : super(
          settings: RouteSettings(name: setting!.name),
          opaque: true,
          maintainState: false,
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return page;
          },
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            if (kIsWeb) {
              return child;
            } else {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 1.0),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeIn)).animate(animation),
                child: child,
              );
            }
          },
        );
}
