import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ButtonContainerWidget extends StatelessWidget {
  final Color? color;
  final String? text;
  final VoidCallback? onTapListener;
  const ButtonContainerWidget({
    Key? key,
    this.color,
    this.text,
    this.onTapListener,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTapListener,
      child: Container(
        width: SpacingConstants.size132,
        height: SpacingConstants.size40,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(SpacingConstants.size8),
        ),
        child: Center(
          child: Text(
            "$text",
            style: const TextStyle(
              color: AppColors.SmatCrowDefaultBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
