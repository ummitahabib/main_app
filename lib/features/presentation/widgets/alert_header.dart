import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import 'package:smat_crow/utils2/styles.dart';

class AlertHeader extends StatelessWidget {
  final String? alertHeaderText;
  final Icon? alertHeaderfirstIcon;
  final Icon? alertHeadersecondIcon;
  final Color? alertIconColorFirst;
  final Color? alertIconColorSecond;
  final Color? alertHeaderBackgroundcolor;

  const AlertHeader({
    Key? key,
    required this.alertHeaderText,
    required this.alertHeaderfirstIcon,
    required this.alertHeadersecondIcon,
    required this.alertIconColorFirst,
    required this.alertIconColorSecond,
    this.alertHeaderBackgroundcolor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingConstants.size8,
        horizontal: SpacingConstants.size16,
      ),
      width: SpacingConstants.size320,
      height: SpacingConstants.size40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpacingConstants.size100),
        color: alertHeaderBackgroundcolor,
        boxShadow: const [
          BoxShadow(
            offset: Offset(SpacingConstants.double0, SpacingConstants.size12),
            blurRadius: SpacingConstants.size18,
            spreadRadius: SpacingConstants.sizeMinus2,
            color: Color.fromRGBO(
              SpacingConstants.sizeInt0,
              SpacingConstants.sizeInt0,
              SpacingConstants.sizeInt0,
              SpacingConstants.size07,
            ),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            alertHeaderfirstIcon?.icon ?? EvaIcons.checkmarkCircle2Outline,
            size: SpacingConstants.size24,
            color: alertIconColorFirst ?? AppColors.SmatCrowRed500,
          ),
          Text(
            alertHeaderText!,
            style: Styles.alertTextStyle(),
          ),
          Icon(
            alertHeadersecondIcon?.icon ?? EvaIcons.closeCircleOutline,
            size: SpacingConstants.size24,
            color: alertIconColorSecond ?? AppColors.SmatCrowRed500,
          ),
        ],
      ),
    );
  }
}
