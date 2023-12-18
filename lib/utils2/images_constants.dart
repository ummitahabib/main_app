// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ImageConstants {
  static const String transparentLogo = 'assets/logo.png';
  static const String errorImage = 'assets/images/Onboarding1.png';
  static const String desktopSideImage = 'assets/images/Onboarding1.png';
  static const String desktopAdImage = 'assets/images/desktop_ad_image.png';
  static const String UserProfile = 'assets/nsvgs/dashboard/UserProfile.png';
  // home images

  static const String cloudy = 'assets2/shared/dashboard_assets/cloudy.png';
  static const String rainy = 'assets2/shared/dashboard_assets/rainy.png';
  static const String sunny = 'assets2/shared/dashboard_assets/sunny.png';
  static const String windy = 'assets2/shared/dashboard_assets/windy.png';
  static const String farmManager = 'assets2/shared/dashboard_assets/farmmanager.png';
  static const String farmProbe = 'assets2/shared/dashboard_assets/organization.png';
  static const String farmSense = 'assets2/shared/dashboard_assets/farmsense.png';
  static const String fieldAgent = 'assets2/shared/dashboard_assets/fieldagent.png';
  static const String fieldMeasure = 'assets2/shared/dashboard_assets/fieldmeasure.png';
  static const String fieldtTool = 'assets2/shared/dashboard_assets/fieldtool.png';
  static const String organization = 'assets2/shared/dashboard_assets/organization.png';
  static const String plantDatabase = 'assets2/shared/dashboard_assets/plantdatabase.png';
  static const String soilSampling = 'assets2/shared/dashboard_assets/soilsampling.png';
}

Padding desktopAdImageWidget() {
  return Padding(
    padding: const EdgeInsets.only(
      top: SpacingConstants.size16,
    ),
    child: Container(
      decoration: DecorationBox.smatCrowBoxDecoration(),
      child: Image.asset(
        ImageConstants.desktopAdImage,
        width: SpacingConstants.size185,
        height: SpacingConstants.size86,
      ),
    ),
  );
}
