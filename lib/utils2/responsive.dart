import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class Responsive extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? desktopTablet;

  const Responsive({
    Key? key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.desktopTablet,
  }) : super(key: key);

//size for tablet, mobile and desktop app
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < SpacingConstants.size550;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < SpacingConstants.size850 && MediaQuery.of(context).size.width >= 550;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= SpacingConstants.size850;

  static double yHeight(BuildContext context, {double percent = 1}) => MediaQuery.of(context).size.height * percent;
  static double xWidth(BuildContext context, {double percent = 1}) => MediaQuery.of(context).size.width * percent;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // if width is more than 1100 it is consider desktop
      builder: (context, constraints) {
        if (constraints.maxWidth >= SpacingConstants.size850) {
          return desktop ?? Container();
        }

        if (constraints.maxWidth >= SpacingConstants.size550) {
          return tablet ?? Container();
        }

        return mobile ?? Container();
      },
    );
  }
}

class Responsiveness extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;

  const Responsiveness({Key? key, this.mobile, this.tablet, this.desktop}) : super(key: key);

  //size for tablet, mobile and desktop app
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < SpacingConstants.size550;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < SpacingConstants.size850 &&
      MediaQuery.of(context).size.width >= SpacingConstants.size550;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= SpacingConstants.size850;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // if width is more than 1100 it is consider desktop
      builder: (context, constraints) => constraints.maxWidth >= SpacingConstants.size850
          ? desktop ?? Container()
          : constraints.maxWidth >= SpacingConstants.size550
              ? tablet ?? Container()
              : mobile ?? Container(),
    );
  }
}
