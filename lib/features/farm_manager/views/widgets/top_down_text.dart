import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class TopDownText extends StatelessWidget {
  const TopDownText({
    super.key,
    required this.top,
    required this.down,
    this.crossAxisAlignment,
    this.downFontSize,
    this.fontFamily,
  });
  final String top;
  final String down;
  final String? fontFamily;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? downFontSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: Text(
            top,
            style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowGrayLabel),
            maxLines: SpacingConstants.int2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Ymargin(SpacingConstants.font10),
        BoldHeaderText(
          text: down,
          fontSize: downFontSize,
          fontFamily: fontFamily,
          color: AppColors.SmatCrowNeuBlue700,
        ),
      ],
    );
  }
}
