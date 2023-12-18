import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CustomButton extends StatelessWidget {
  final IconData? leftIcon;
  final IconData? rightIcon;
  final String? text;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? borderColor;
  final Color? iconColor;
  final Color? textColor;
  final double? iconSize;
  final double? width;
  final double? height;
  final double? fontSize;
  final MainAxisAlignment? iconPosition;
  final bool isLoading;

  const CustomButton({
    Key? key,
    this.leftIcon,
    this.rightIcon,
    this.text,
    this.onPressed,
    this.color,
    this.borderColor,
    this.iconColor,
    this.textColor,
    this.iconSize,
    this.width,
    this.height,
    this.fontSize,
    this.iconPosition,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingConstants.size16,
          vertical: SpacingConstants.size12,
        ),
        decoration: DecorationBox.customButtonDecoration(
          borderColor: borderColor,
          color: color,
        ),
        child: isLoading
            ? const LoadingStateWidget()
            : Row(
                mainAxisAlignment: iconPosition ?? MainAxisAlignment.center,
                children: [
                  Icon(
                    leftIcon,
                    color: iconColor,
                    size: iconSize,
                  ),
                  const SizedBox(
                    width: SpacingConstants.size4,
                  ),
                  DecorationBox.customButtonText(
                    text: text.toString(),
                    color: textColor ?? AppColors.SmatCrowNeuBlue900,
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                  ),
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
      ),
    );
  }
}
