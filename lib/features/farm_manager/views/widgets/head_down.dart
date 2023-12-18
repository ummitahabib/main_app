import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class HeadDownWidget extends StatelessWidget {
  const HeadDownWidget({
    super.key,
    required this.head,
    this.down,
    this.crossAxisAlignment,
    this.coloredText = false,
  });
  final String head;
  final String? down;
  final CrossAxisAlignment? crossAxisAlignment;
  final bool coloredText;

  @override
  Widget build(BuildContext context) {
    if (down == null || down == "null") {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingConstants.font16),
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Color600Text(text: head),
          const Ymargin(SpacingConstants.font10),
          if (coloredText)
            Text(
              down ?? emptyString,
              style: Styles.smatCrowSubParagraphRegular(
                color: AppColors.SmatCrowPrimary500,
              ).copyWith(decoration: TextDecoration.underline),
            )
          else
            BoldHeaderText(text: down ?? "", fontSize: SpacingConstants.font14)
        ],
      ),
    );
  }
}
