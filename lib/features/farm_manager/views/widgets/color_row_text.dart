import 'package:flutter/material.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ColorTextRow extends StatelessWidget {
  const ColorTextRow({
    super.key,
    required this.color,
    required this.text,
  });
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: SpacingConstants.size5,
          backgroundColor: color,
        ),
        const Xmargin(SpacingConstants.size5),
        Text(
          text,
          style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
        )
      ],
    );
  }
}
