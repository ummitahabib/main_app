import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';

import '../../utils2/decoration.dart';
import '../../utils2/spacing_constants.dart';

class CustomButton extends StatelessWidget {
  final IconData? leftIcon;
  final IconData? rightIcon;
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? width;
  final double? height;
  final double? fontSize;
  final MainAxisAlignment? iconPosition;
  final bool loading;

  const CustomButton({
    Key? key,
    this.leftIcon,
    this.rightIcon,
    required this.text,
    required this.onPressed,
    this.color,
    this.borderColor,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.width,
    this.height,
    this.fontSize,
    this.iconPosition,
    this.loading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: loading ? null : onPressed,
      child: Container(
        width: width,
        height: height ?? SpacingConstants.size47,
        decoration: DecorationBox.customButtonDecoration(
          borderColor: borderColor,
          color: loading ? AppColors.SmatCrowNeuBlue400 : color ?? AppColors.SmatCrowPrimary500,
        ),
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                height: SpacingConstants.size30,
                width: SpacingConstants.size30,
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: textColor ?? AppColors.SmatCrowNeuBlue900,
                ),
              )
            : ButtonBody(
                iconPosition: iconPosition,
                leftIcon: leftIcon,
                iconColor: iconColor,
                iconSize: iconSize,
                textColor: textColor,
                text: text,
                fontSize: fontSize,
                rightIcon: rightIcon,
              ),
      ),
    );
  }
}

class ButtonBody extends StatelessWidget {
  const ButtonBody({
    super.key,
    required this.iconPosition,
    required this.leftIcon,
    required this.iconColor,
    required this.iconSize,
    required this.textColor,
    required this.text,
    required this.fontSize,
    required this.rightIcon,
  });

  final MainAxisAlignment? iconPosition;
  final IconData? leftIcon;
  final Color? iconColor;
  final double? iconSize;
  final Color? textColor;
  final String text;
  final double? fontSize;
  final IconData? rightIcon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: iconPosition ?? MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (leftIcon != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                leftIcon,
                color: iconColor,
                size: iconSize,
              ),
              const SizedBox(
                width: SpacingConstants.size4,
              ),
            ],
          ),
        if (text.isNotEmpty)
          DecorationBox.customButtonText(
            text: text,
            color: textColor ?? AppColors.SmatCrowNeuBlue900,
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
          ),
        if (rightIcon != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: SpacingConstants.size4,
              ),
              Icon(
                rightIcon,
                color: iconColor,
                size: iconSize,
              ),
            ],
          ),
      ],
    );
  }
}
