import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class CustomSendButton extends StatelessWidget {
  const CustomSendButton({
    this.onTapSend,
    this.buttonSize,
    this.buttonText,
    super.key,
  });
  final Function()? onTapSend;
  final Size? buttonSize;
  final String? buttonText;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          AppColors.SmatCrowPrimary500,
        ),
        fixedSize: MaterialStateProperty.all<Size>(
          buttonSize ?? const Size(SpacingConstants.size50, SpacingConstants.size50),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              SpacingConstants.size10,
            ), // Adjust the value as needed
          ),
        ),
      ),
      onPressed: onTapSend,
      child: buttonText != null
          ? Text(
              buttonText ?? emptyString,
              style: Styles.smatCrowCaptionRegular(
                color: AppColors.SmatCrowNeuBlue900,
              ).copyWith(
                height: 1.9,
                fontSize: 20,
              ),
            )
          : Transform.rotate(
              angle: -3.14 / 4,
              child: const Icon(
                Icons.send,
                color: AppColors.black,
              ),
            ),
    );
  }
}
