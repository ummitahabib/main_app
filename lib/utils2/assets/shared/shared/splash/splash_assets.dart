import 'package:flutter/material.dart';

class SplashAssets {
  static const String splashLogo = 'assets2/shared/splash_assets/splash_logo.png';
  static const String mailLogo = 'assets2/shared/mail_logo.png';
}

Image profileImage() {
  return Image.asset(
    'assets/profile_default.png',
    fit: BoxFit.cover,
  );
}
