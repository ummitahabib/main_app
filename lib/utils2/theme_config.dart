import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/styles.dart';

class ThemeConfig {
  static final lightTheme = ThemeData(
    colorScheme: const ColorScheme.light(),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0,
      toolbarHeight: 40,
      iconTheme: const IconThemeData(color: AppColors.SmatCrowNeuBlue900),
      titleTextStyle:
          Styles.smatCrowMediumBody(color: AppColors.SmatCrowNeuBlue900).copyWith(fontWeight: FontWeight.bold),
    ),
    useMaterial3: false,
    dividerColor: AppColors.SmatCrowNeuBlue200,
    dividerTheme: const DividerThemeData(thickness: 1.2, color: AppColors.SmatCrowNeuBlue200),
    iconButtonTheme: IconButtonThemeData(style: TextButton.styleFrom(backgroundColor: AppColors.SmatCrowNeuBlue900)),
    iconTheme: const IconThemeData(color: AppColors.SmatCrowNeuBlue900, size: 20),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: AppColors.SmatCrowPrimary500,
      cursorColor: AppColors.SmatCrowPrimary500,
      selectionHandleColor: AppColors.SmatCrowPrimary500,
    ),
  );
}
