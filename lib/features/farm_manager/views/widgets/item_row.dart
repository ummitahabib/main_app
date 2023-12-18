import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ItemRow extends StatelessWidget {
  const ItemRow({
    super.key,
    required this.asset,
    required this.title,
    this.body,
  });
  final String asset;
  final String title;
  final String? body;
  @override
  Widget build(BuildContext context) {
    if (body == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: SpacingConstants.font10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            asset,
            color: AppColors.SmatCrowNeuBlue600,
            fit: BoxFit.scaleDown,
            width: 20,
            height: 20,
          ),
          const Xmargin(SpacingConstants.font10),
          Text(
            title,
            style: Styles.smatCrowSubParagraphRegular(
              color: AppColors.SmatCrowNeuBlue600,
            ),
          ),
          const Spacer(),
          Text(
            body!,
            style: Styles.smatCrowSubParagraphRegular(
              color: AppColors.SmatCrowNeuBlue900,
            ),
          )
        ],
      ),
    );
  }
}
