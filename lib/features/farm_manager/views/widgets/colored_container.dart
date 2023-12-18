import 'package:flutter/material.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ColoredContainer extends StatelessWidget {
  const ColoredContainer({
    super.key,
    required this.color,
    this.text,
    this.verticalPadding,
  });

  final Color color;
  final String? text;
  final double? verticalPadding;

  @override
  Widget build(BuildContext context) {
    if (text == null) {
      return const SizedBox.shrink();
    }
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: SpacingConstants.font12,
        vertical: verticalPadding ?? SpacingConstants.size4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SpacingConstants.size100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: SpacingConstants.size4,
            backgroundColor: color,
          ),
          const Xmargin(SpacingConstants.size5),
          Flexible(
            child: Text(
              text!,
              style: Styles.smatCrowSubParagraphRegular(color: color),
              maxLines: 2,
            ),
          )
        ],
      ),
    );
  }
}
