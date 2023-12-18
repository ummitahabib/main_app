import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CustomOutlineButton extends StatelessWidget {
  const CustomOutlineButton({
    this.onTapButton,
    required this.buttonWidget,
    this.buttonHeight,
    this.buttonWidth,
    this.outlineColor,
    super.key,
  });
  final Function()? onTapButton;
  final Widget buttonWidget;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? outlineColor;
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTapButton,
        child: Container(
          width: buttonWidth ?? SpacingConstants.size280,
          height: buttonHeight ?? SpacingConstants.size44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: outlineColor ?? AppColors.SmatCrowPrimary500,
              width: 1.5,
            ),
          ),
          child: buttonWidget,
        ),
      ),
    );
  }
}
