import 'package:flutter/material.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ImageText extends StatelessWidget {
  const ImageText({
    super.key,
    required this.asset,
    required this.title,
  });
  final String asset;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SpacingConstants.font12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SpacingConstants.font10),
      ),
      width: double.maxFinite,
      child: Row(
        children: [
          SizedBox(
            width: SpacingConstants.font32,
            height: SpacingConstants.font32,
            child: Image.asset(asset),
          ),
          const Xmargin(SpacingConstants.font10),
          Text(
            title,
            style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: SpacingConstants.font14,
            color: AppColors.SmatCrowNeuBlue900,
          )
        ],
      ),
    );
  }
}
