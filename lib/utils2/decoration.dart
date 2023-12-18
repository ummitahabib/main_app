import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/icons.dart';
import 'package:smat_crow/utils2/images_constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class DecorationBox {
  static OutlineInputBorder customOutlineBorder({
    Color? color,
    double? width,
  }) {
    return OutlineInputBorder(
      borderSide: BorderSide(
        color: color ?? AppColors.SmatCrowNeuBlue200,
        width: width ?? SpacingConstants.size1point5,
      ),
    );
  }

  static Icon passwordIcon([bool obscured = true]) {
    return Icon(
      obscured ? AppIcons.eye : AppIcons.eyeoff,
      size: SpacingConstants.size20,
      color: AppColors.SmatCrowDefaultBlack,
    );
  }

  static BoxDecoration switchDecoration({Color? color}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(SpacingConstants.size100),
      color: color,
    );
  }

  static Duration switchDuration() {
    return const Duration(milliseconds: SpacingConstants.int200);
  }

  static BoxDecoration switchDecoration2() {
    return const BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.SmatCrowDefaultWhite,
    );
  }

  static BoxDecoration radioDecoration({Color? color, Color? borderColor}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(
        color: borderColor!,
      ),
    );
  }

  static BoxDecoration radioDecoration2() {
    return const BoxDecoration(
      shape: BoxShape.circle,
      color: AppColors.SmatCrowBlue500,
    );
  }

  static BoxDecoration checkBoxDecoration({Color? color, Color? borderColor}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(SpacingConstants.size4),
      color: color,
      border: Border.all(color: borderColor!),
    );
  }

  static Icon checkBoxIcon() {
    return const Icon(
      AppIcons.check,
      size: SpacingConstants.size10,
      color: AppColors.SmatCrowDefaultWhite,
    );
  }

  static InputDecoration dropDownInputDecoration({
    String hintText = emptyString,
  }) {
    return InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(SpacingConstants.size8),
      ),
      filled: true,
      fillColor: AppColors.SmatCrowNeuBlue50,
      hintText: hintText,
    );
  }

  static BoxDecoration customButtonDecoration({
    Color? color,
    Color? borderColor,
  }) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(SpacingConstants.size8),
      color: color,
      border: Border.all(
        color: borderColor ?? Colors.transparent,
        width: SpacingConstants.size1point5,
      ),
    );
  }

  static Text customButtonText({
    String text = emptyString,
    Color? color,
    double? fontSize,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Text(
      text,
      style: Styles.smatCrowParagraphRegular500(
        color: color,
        fontSize: fontSize ?? SpacingConstants.font16,
      ).copyWith(fontWeight: fontWeight),
      textAlign: TextAlign.center,
    );
  }

  static ClipRRect customProgressIndicator() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(SpacingConstants.size100),
      child: const LinearProgressIndicator(
        backgroundColor: AppColors.SmatCrowNeuBlue200, // Background color of the progress bar
        valueColor: AlwaysStoppedAnimation<Color>(
          AppColors.SmatCrowGreen500,
        ), // Color of the progress indicator
        value: SpacingConstants.size100, // The progress value (0.0 to 1.0)
      ),
    );
  }

  static Container buildBDotContainer({Color? color}) {
    return Container(
      height: SpacingConstants.size6,
      width: SpacingConstants.size6,
      margin: const EdgeInsets.only(right: SpacingConstants.size5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpacingConstants.size100),
        color: color,
      ),
    );
  }

  static OutlineInputBorder customOutlineBorder4() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.SmatCrowNeuBlue200,
      ),
      borderRadius: BorderRadius.circular(SpacingConstants.size8),
    );
  }

  static OutlineInputBorder customOutlineBorderSideAndRadius() {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: AppColors.SmatCrowNeuBlue200),
      borderRadius: BorderRadius.circular(SpacingConstants.size8),
    );
  }

  static OutlineInputBorder customOutlineBorderSide() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.SmatCrowPrimary500),
    );
  }

  static ShapeBorderClipper shapeBorderClipper() {
    return ShapeBorderClipper(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SpacingConstants.size10),
      ),
    );
  }

  static Icon validIcon() {
    return const Icon(
      AppIcons.circel2,
      size: SpacingConstants.size16,
      color: AppColors.SmatCrowGreen500,
    );
  }

  static Icon passwordIconOn([bool obscured = true]) {
    return const Icon(
      AppIcons.eye,
      size: SpacingConstants.size20,
      color: AppColors.SmatCrowDefaultBlack,
    );
  }

  static Icon passwordIconOff([bool obscured = true]) {
    return const Icon(
      AppIcons.eyeoff,
      size: SpacingConstants.size20,
      color: AppColors.SmatCrowDefaultBlack,
    );
  }

  static BoxDecoration boxDecorationWithShadow() {
    return BoxDecoration(
      color: AppColors.SmatCrowNeuBlue100,
      borderRadius: BorderRadius.circular(SpacingConstants.size8),
      boxShadow: const [
        BoxShadow(
          offset: Offset(
            SpacingConstants.double0,
            SpacingConstants.boxShadowOffset,
          ),
          blurRadius: SpacingConstants.boxBlurRadius,
          spreadRadius: SpacingConstants.spreadRadius,
          color: Color.fromRGBO(
            SpacingConstants.int0,
            SpacingConstants.int0,
            SpacingConstants.int0,
            SpacingConstants.size07,
          ),
        ),
      ],
    );
  }

  static BoxDecoration uploadImageBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(16.0),
      color: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color.fromRGBO(0, 0, 0, 0.07),
          offset: Offset(0, 12),
          blurRadius: 18,
          spreadRadius: -2,
        ),
      ],
    );
  }

  static BoxDecoration smatCrowBoxDecoration({Color? color}) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(SpacingConstants.size8),
      color: color,
    );
  }

  static BoxDecoration customDecorationDesktopTablet(BuildContext context) {
    final isTabletOrDesktop = MediaQuery.of(context).size.width >= SpacingConstants.size600;

    return BoxDecoration(
      color: AppColors.SmatCrowDefaultWhite,
      borderRadius: isTabletOrDesktop
          ? BorderRadius.circular(SpacingConstants.size24)
          : const BorderRadius.only(
              topLeft: Radius.circular(SpacingConstants.size24),
              topRight: Radius.circular(SpacingConstants.size24),
            ),
    );
  }

  static TextField desktopDashboardText() {
    return const TextField(
      enabled: false,
      decoration: InputDecoration(
        hintText: howMayIhelpYouText,
        border: InputBorder.none,
      ),
    );
  }

  static BoxDecoration activityGridDecoration = BoxDecoration(
    color: AppColors.SmatCrowDefaultWhite,
    borderRadius: BorderRadius.circular(SpacingConstants.size12),
    boxShadow: [
      BoxShadow(
        color: AppColors.SmatCrowDefaultBlack.withOpacity(
          SpacingConstants.double0point2,
        ),
        spreadRadius: SpacingConstants.size2,
        blurRadius: SpacingConstants.size5,
      ),
    ],
  );

  static BoxDecoration decorationWithShapeAndColor({Color? color}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: color ?? AppColors.SmatCrowDefaultWhite,
    );
  }

  static EdgeInsets padding25() {
    return const EdgeInsets.symmetric(
      horizontal: SpacingConstants.double25,
    );
  }

  static TextStyle newsTitleTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowNeuBlue800,
      fontFamily: FontName,
      fontSize: SpacingConstants.size12,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      height: SpacingConstants.double1Point4,
      letterSpacing: SpacingConstants.doubleMinus012,
    );
  }

  static TextStyle newsSourceTextStyle() {
    return const TextStyle(
      color: AppColors.SmatCrowPrimary500,
      fontFamily: FontName,
      fontSize: SpacingConstants.size8,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      height: SpacingConstants.size1point6,
    );
  }

  static Container newsConstantImage() {
    const String randomImageUrl = emptyString;
    return Container(
      width: SpacingConstants.size72,
      height: SpacingConstants.size72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          SpacingConstants.double12,
        ),
        color: AppColors.SmatCrowPrimary500,
      ),
      child: Image.network(randomImageUrl),
    );
  }

  static OutlineInputBorder customOutlineBorder2() {
    return const OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.SmatCrowPrimary500),
    );
  }

  static OutlineInputBorder customOutlineBorder3() {
    return const OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.SmatCrowNeuBlue50,
        width: SpacingConstants.size1point5,
      ),
    );
  }

  static RoundedRectangleBorder newsTextBorder() {
    return const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(SpacingConstants.double20),
        bottomRight: Radius.circular(SpacingConstants.double20),
      ),
    );
  }

  static Container newsContainer(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: AppColors.SmatCrowDefaultWhite,
    );
  }
}

Image userPhoto({double? width, double? height}) {
  return Image.asset(
    ImageConstants.UserProfile,
    width: width ?? SpacingConstants.size37,
    height: height ?? SpacingConstants.size37,
  );
}

Icon socialMessageIcon() {
  return const Icon(
    EvaIcons.messageSquareOutline,
    size: SpacingConstants.size24,
    color: AppColors.SmatCrowNeuBlue900,
  );
}

Icon socialSearchIcon() {
  return const Icon(
    EvaIcons.search,
    size: SpacingConstants.size24,
    color: AppColors.SmatCrowNeuBlue900,
  );
}

Icon socialAddIcon() {
  return const Icon(
    EvaIcons.plusCircleOutline,
    size: SpacingConstants.size24,
    color: AppColors.SmatCrowPrimary500,
  );
}

TextStyle socialTextStyle = const TextStyle(
  color: Color(0xFF111A27),
  fontFamily: FontName,
  fontSize: SpacingConstants.size21,
  fontStyle: FontStyle.normal,
  fontWeight: FontWeight.w500,
  letterSpacing: -0.21,
  height: 1.2,
);

Container storyAddWidget() {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.SmatCrowPrimary500,
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white),
    ),
    child: const Icon(EvaIcons.plus, color: Colors.white),
  );
}

TextStyle myStoryTextStyle() {
  return const TextStyle(
    color: AppColors.SmatCrowDefaultBlack,
    fontWeight: FontWeight.w500,
  );
}

OutlineInputBorder customOutlineBorder() {
  return const OutlineInputBorder(
    borderSide: BorderSide(
      color: AppColors.SmatCrowNeuBlue200,
      width: SpacingConstants.size1point5,
    ),
  );
}

OutlineInputBorder customOutlineBorder1() {
  return OutlineInputBorder(
    borderSide: const BorderSide(color: AppColors.SmatCrowNeuBlue200),
    borderRadius: BorderRadius.circular(SpacingConstants.size8),
  );
}
