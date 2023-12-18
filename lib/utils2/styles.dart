import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import 'assets/shared/splash/splash_assets.dart';

class Styles {
  //Display
  static TextStyle smatCrowDisplayRegular1({Color? color, double? fontsize}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font96,
      color: color,
    );
  }

  static TextStyle smatCrowDisplayRegular2({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font80,
      color: color,
    );
  }

  static TextStyle smatCrowDisplayRegular3({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font64,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle commentTextStyle() {
    return const TextStyle(
      fontFamily: FontName,
      fontSize: SpacingConstants.size21,
      fontWeight: FontWeight.w600,
      color: AppColors.SmatCrowNeuBlue900,
    );
  }

  //Heading
  static TextStyle smatCrowHeadingRegular1({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontSize: SpacingConstants.font64,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle profileOptionTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowNeuBlue800,
      fontFamily: FontName,
      fontSize: SpacingConstants.font14,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: SpacingConstants.size1point6,
      letterSpacing: -0.14,
    );
  }

  static Text noPostTextStyle() {
    return const Text(
      noPostText,
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: SpacingConstants.size18,
      ),
    );
  }

  static TextStyle deleteTextStyle() {
    return const TextStyle(
      color: Color(
        0xFF111A27,
      ),
      fontFamily: FontName,
      fontSize: SpacingConstants.size16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: SpacingConstants.size1point6,
      letterSpacing: -0.16,
    );
  }

  static TextStyle deletePostAlertTextStyle() {
    return const TextStyle(
      color: Color(0xFF111A27),
      fontFamily: "Basier Circle",
      fontSize: 16.0,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: 1.6,
      letterSpacing: -0.16,
    );
  }

  static TextStyle updateTextStyle() {
    return const TextStyle(
      color: Color(
        0xFF111A27,
      ),
      fontFamily: FontName,
      fontSize: SpacingConstants.size16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: SpacingConstants.size1point6,
      letterSpacing: -0.16,
    );
  }

  static TextStyle viewAllTextStyle() {
    return const TextStyle(
      color: Color(0xFF111A27),
      fontFamily: 'Basier Circle',
      fontSize: 10.0,
      fontWeight: FontWeight.w600,
      height: SpacingConstants.size1point6,
      letterSpacing: -0.1,
    );
  }

  static TextStyle emailTextStyle2() {
    return const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle likeTextStyle() {
    return const TextStyle(
      color: Color(0xFF1F2937),
      fontFamily: 'Basier Circle',
      fontSize: 10.0,
      fontWeight: FontWeight.w500,
      height: SpacingConstants.size1point6,
      letterSpacing: -0.1,
    );
  }

  static TextStyle dateTextStyle() {
    return const TextStyle(
      color: Color(
        0xFF6B7380,
      ),
      fontFamily: 'Basier Circle',
      fontSize: 10.0,
      fontWeight: FontWeight.w400,
      height: SpacingConstants.size1point6,
      letterSpacing: -0.1,
    );
  }

  static TextStyle emailTextStyle() {
    return const TextStyle(
      color: Color(
        0xFF111A27,
      ),
      fontFamily: 'Basier Circle',
      fontSize: 12.0,
      fontWeight: FontWeight.w500,
      height: SpacingConstants.size1point6,
      letterSpacing: -0.12,
    );
  }

  static TextStyle modelTextStyle = const TextStyle(
    color: AppColors.SmatCrowNeuBlue900,
    fontFamily: FontName,
    fontSize: SpacingConstants.size16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: SpacingConstants.size1point6,
    letterSpacing: SpacingConstants.sizeOpoint16,
  );

  static TextStyle modelTextStyleRed = const TextStyle(
    color: AppColors.SmatCrowRed800,
    fontFamily: FontName,
    fontSize: SpacingConstants.size16,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w400,
    height: SpacingConstants.size1point6,
    letterSpacing: SpacingConstants.sizeOpoint16,
  );
  static TextStyle smatCrowHeadingRegular2({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontSize: SpacingConstants.font36,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle socialTextStyle() {
    return const TextStyle(
      fontFamily: FontName,
      fontSize: SpacingConstants.font21,
      fontWeight: FontWeight.w500,
      color: AppColors.SmatCrowNeuBlue800,
      letterSpacing: SpacingConstants.doubleMinus021,
      height: SpacingConstants.double1Point2,
    );
  }

  static TextStyle smatCrowHeadingRegular3({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontSize: SpacingConstants.font32,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle smatCrowHeadingRegular4({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle smatCrowHeadingRegular5({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontSize: SpacingConstants.font24,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle smatCrowHeadingRegular6({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontSize: SpacingConstants.font21,
      fontWeight: FontWeight.w400,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle smatCrowHeadingRegular7({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: 9.0,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle smatCrowUnderline({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font10,
      color: color ?? AppColors.SmatCrowPrimary500,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle smatCrowUnderline2() {
    return const TextStyle(
      fontSize: SpacingConstants.font14,
      fontFamily: FontName,
      color: AppColors.SmatCrowNeuBlue900,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle smatCrowHeadingRegular8({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font12,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  //Body/Regular
  static TextStyle smatCrowBodyRegular({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font18,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

//Paragraph Regular
  static TextStyle smatCrowParagraphRegular({Color? color, double? fontSize}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: fontSize ?? SpacingConstants.font16,
      color: color ?? AppColors.SmatCrowDefaultWhite,
    );
  }

  static TextStyle smatCrowParagraphRegular500({
    Color? color,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? SpacingConstants.font16,
      color: color ?? AppColors.SmatCrowDefaultWhite,
    );
  }

  static TextStyle smatCrowSubParagraphRegular({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font14,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle alertbodyDescriptionStyle(Color? alertbodyDescriptionColor) {
    return TextStyle(
      color: alertbodyDescriptionColor,
      fontFamily: FontName,
      fontSize: SpacingConstants.size14,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: SpacingConstants.size1point6,
      letterSpacing: SpacingConstants.size0Mpoint14,
    );
  }

  static TextStyle smatCrowSubRegularUnderline({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font14,
      color: color ?? AppColors.SmatCrowNeuBlue800,
      decoration: TextDecoration.underline,
    );
  }

  static TextStyle smatCrowCaptionRegular({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font12,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle smatCrowSmallTextRegular({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font10,
      color: color ?? AppColors.SmatCrowNeuBlue800,
    );
  }

  static TextStyle smatCrowSmallTextRegularUnderline({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      fontSize: SpacingConstants.font10,
      color: color ?? AppColors.SmatCrowPrimary500,
    );
  }

  //Medium

  //Display
  static TextStyle smatCrowMediumDisplay1({double? fontSize, Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? SpacingConstants.font96,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumDisplay2({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font80,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumDisplay3({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font64,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  //Heading
  static TextStyle smatCrowMediumHeading1({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font64,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumHeading2({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font36,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumHeading3({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font32,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumHeading4({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.size28,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowHeading4({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.size28,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumHeading5({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font24,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumHeading6({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font21,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumBody({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font18,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumParagraph({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font10,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumSubParagraph({
    Color? color,
    double? fontSize,
  }) {
    return TextStyle(
      fontFamily: FontName,
      fontWeight: FontWeight.w500,
      fontSize: fontSize ?? SpacingConstants.font14,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumCaption(Color? color) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font12,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumLabel({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font12,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowMediumSmall({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: SpacingConstants.font10,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  //Bold

//Display

  static TextStyle smatCrowDisplayBold1({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: SpacingConstants.font96,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowDisplayBold2({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: SpacingConstants.font80,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowDisplayBold3({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w700,
      fontSize: SpacingConstants.font64,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowHeadingBold1({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font64,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowHeadingBold2({Color? color, double? fontSize}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: fontSize ?? SpacingConstants.font36,
      color: color ?? AppColors.SmatCrowDefaultWhite,
    );
  }

  static TextStyle smatCrowHeadingBold3({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font32,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowHeadingBold4({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: 28,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowHeadingBold5({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font24,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowHeadingBold6({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font21,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowBodyBold({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font18,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowParagrahBold({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font10,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowSubParagrahBold({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font14,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowCaptionBold({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font12,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowLabelBold({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font12,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle smatCrowSmallBold({Color? color}) {
    return TextStyle(
      fontFamily: FontName,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w600,
      fontSize: SpacingConstants.font10,
      color: color ?? AppColors.SmatCrowNeuOrange900,
    );
  }

  static TextStyle newsTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowDefaultBlack,
      fontSize: SpacingConstants.size23,
      fontFamily: 'semibold',
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle newPostTextStyle() {
    return const TextStyle(
      fontFamily: FontName,
      fontSize: SpacingConstants.size12,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      height: SpacingConstants.size1point6,
      letterSpacing: SpacingConstants.minus0point12,
      color: AppColors.black,
    );
  }

  static TextStyle alertbodyStyle(
    Color? alertbodyColor,
  ) {
    return TextStyle(
      color: alertbodyColor,
      fontFamily: FontName,
      fontSize: SpacingConstants.size16,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      height: SpacingConstants.size1point6,
      letterSpacing: SpacingConstants.sizeOpoint16,
    );
  }

  static TextStyle alertTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowNeuBlue900,
      fontFamily: FontName,
      fontSize: SpacingConstants.font14,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w400,
      height: SpacingConstants.size1point6,
      letterSpacing: SpacingConstants.size0Mpoint14,
    );
  }

  static TextStyle commodityTextStyle({Color? color}) {
    return TextStyle(
      fontFamily: "regular",
      fontWeight: FontWeight.normal,
      fontSize: SpacingConstants.size14,
      color: color,
    );
  }

  static TextStyle firstNameTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowDefaultBlack,
      fontSize: SpacingConstants.size16,
      fontWeight: FontWeight.bold,
      fontFamily: FontFamily.regular,
    );
  }

  static TextStyle greetingText() {
    return const TextStyle(
      color: Colors.black,
      fontSize: SpacingConstants.size16,
      fontWeight: FontWeight.bold,
      fontFamily: FontFamily.regular,
    );
  }

  static TextStyle desktopTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowNeuBlue700,
      fontFamily: FontName,
      fontSize: SpacingConstants.size14,
      fontWeight: FontWeight.w500,
      letterSpacing: SpacingConstants.letterSpacing,
    );
  }

  static TextStyle weatherMainTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowDefaultBlack,
      fontSize: SpacingConstants.font16,
      fontWeight: FontWeight.bold,
      fontFamily: FontFamily.regular,
    );
  }

  static TextStyle areaNameTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowDefaultBlack,
      fontSize: SpacingConstants.font12,
      fontFamily: FontFamily.regular,
    );
  }

  static TextStyle dashboradTextStyle() {
    return const TextStyle(
      fontSize: SpacingConstants.size20,
      color: AppColors.SmatCrowNeuBlue900,
      fontFamily: FontName,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle weatherTemperatureTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowDefaultBlack,
      fontSize: SpacingConstants.font40,
      fontWeight: FontWeight.bold,
      fontFamily: 'semibold',
    );
  }

  static TextStyle bottomNavTextStyle() {
    return const TextStyle(
      fontSize: SpacingConstants.double12,
      fontFamily: FontFamily.regular,
      color: AppColors.landingOrangeButton,
    );
  }

//Display

  double calculateButtonWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * SpacingConstants.size0point08;
  }

  double calculateButtonHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return screenHeight * SpacingConstants.size0point07;
  }
}

// shape: RoundedRectangleBorder
class Shape extends RoundedRectangleBorder {
  Shape({double borderRadius = SpacingConstants.size4}) : super(borderRadius: BorderRadius.circular(borderRadius));
}

class CustomBoxDecoration extends BoxDecoration {
  static BorderRadiusGeometry defaultBorderRadius = BorderRadius.circular(SpacingConstants.size8);
  const CustomBoxDecoration({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
    BlendMode? backgroundBlendMode,
    BoxShape shape = BoxShape.rectangle,
  }) : super(
          color: color,
          image: image,
          border: border,
          boxShadow: boxShadow,
          gradient: gradient,
          backgroundBlendMode: backgroundBlendMode,
          shape: shape,
        );
}

class FolderIcon extends IconButton {
  FolderIcon({
    super.key,
    VoidCallback? onPressed,
    IconData? icon,
    double size = SpacingConstants.size32,
    Color? color = AppColors.SmatCrowPrimary500,
  }) : super(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: size,
            color: color,
          ),
        );
}

class MailLogo extends Image {
  MailLogo({
    Key? key,
  }) : super.asset(
          SplashAssets.mailLogo,
          key: key,
        );
}

class SmatCrowLogo extends Image {
  SmatCrowLogo({
    Key? key,
  }) : super.asset(
          SplashAssets.splashLogo,
          key: key,
        );
}

double calculateButtonWidth(BuildContext context) {
  final screenWidth = MediaQuery.of(context).size.width;
  return screenWidth * SpacingConstants.size0point08;
}

double calculateButtonHeight(BuildContext context) {
  final screenHeight = MediaQuery.of(context).size.height;
  return screenHeight * SpacingConstants.size0point07;
}

class ButtonDimensions {
  final double buttonWidth;
  final double buttonHeight;

  ButtonDimensions(this.buttonWidth, this.buttonHeight);
}

TextStyle postandStoryTextStyle() {
  return const TextStyle(
    fontSize: SpacingConstants.size16,
    fontWeight: FontWeight.normal,
    color: AppColors.SmatCrowNeuBlue900,
  );
}
