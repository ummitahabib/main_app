import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class AlertBody extends StatelessWidget {
  final Icon? alertBodyIcon;
  final String? alertBodyTitle;
  final String? alertBodyDescription;
  final Color? alertbodyDescriptionColor;
  final Color? alertbodytitleColor;
  final String? leftbuttonText;
  final String? rightbuttonText;
  final double? customBottomWidth;
  final Color? alertBodyIconColor;
  final VoidCallback? onPressedFirstbutton;
  final VoidCallback? onPressedSecondbutton;

  const AlertBody({
    Key? key,
    this.alertBodyIcon,
    this.alertBodyTitle,
    this.alertBodyDescription,
    this.alertbodyDescriptionColor,
    this.alertbodytitleColor,
    this.leftbuttonText,
    this.rightbuttonText,
    this.customBottomWidth,
    this.alertBodyIconColor,
    this.onPressedFirstbutton,
    this.onPressedSecondbutton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTabletOrDesktop =
        MediaQuery.of(context).size.width >= SpacingConstants.size600;
    final bool showTwoButtons = onPressedSecondbutton != null;
    final double buttonWidth =
        showTwoButtons ? SpacingConstants.size163 : SpacingConstants.size342;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(
              top: SpacingConstants.size14,
              bottom: SpacingConstants.size14,
            ),
            width: SpacingConstants.size70,
            height: SpacingConstants.size5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpacingConstants.size100),
              color: isTabletOrDesktop ? null : AppColors.SmatCrowBlue200,
            ),
          ),
          const SizedBox(height: SpacingConstants.size39),
          Icon(
            alertBodyIcon?.icon ?? EvaIcons.checkmarkCircle2Outline,
            size: SpacingConstants.size56,
            color: alertBodyIconColor,
          ),
          const SizedBox(height: SpacingConstants.size12),
          Text(
            alertBodyTitle ?? emptyString,
            textAlign: TextAlign.center,
            style: Styles.alertbodyStyle(
              alertbodytitleColor,
            ),
          ),
          const SizedBox(height: SpacingConstants.size12),
          Text(
            alertBodyDescription ?? emptyString,
            textAlign: TextAlign.center,
            style: Styles.alertbodyDescriptionStyle(alertbodyDescriptionColor),
          ),
          const SizedBox(height: SpacingConstants.size58),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: SpacingConstants.size163,
                height: SpacingConstants.size47,
                child: ElevatedButton(
                  onPressed: onPressedFirstbutton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.SmatCrowNeuBlue100,
                  ),
                  child: Text(
                    leftbuttonText ?? cancel,
                    style: Styles.alertTextStyle(),
                  ),
                ),
              ),
              if (showTwoButtons)
                const SizedBox(width: SpacingConstants.size12),
              if (showTwoButtons)
                SizedBox(
                  width: buttonWidth,
                  height: SpacingConstants.size47,
                  child: ElevatedButton(
                    onPressed: onPressedSecondbutton,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.SmatCrowPrimary500,
                    ),
                    child: Text(
                      rightbuttonText ?? tryAgainError,
                      style: Styles.alertTextStyle(),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
