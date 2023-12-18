import 'package:flutter/material.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SelectContainer extends StatelessWidget {
  const SelectContainer({
    super.key,
    this.value,
    required this.title,
    required this.hintText,
    required this.function,
    this.icon,
  });

  final String? value;
  final String title;
  final String hintText;
  final VoidCallback function;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Text(
            title,
            style: Styles.smatCrowMediumSubParagraph(color: AppColors.SmatCrowNeuBlue900)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        if (title.isNotEmpty) const Ymargin(SpacingConstants.font10),
        InkWell(
          onTap: function,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingConstants.font10,
              vertical: SpacingConstants.font10,
            ),
            decoration: BoxDecoration(
              color: AppColors.SmatCrowNeuBlue50,
              borderRadius: BorderRadius.circular(SpacingConstants.size8),
              border: Border.all(color: AppColors.SmatCrowNeuBlue200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (value == null || value!.isEmpty)
                  Text(
                    hintText,
                    style: Styles.smatCrowSubParagraphRegular(
                      color: AppColors.SmatCrowNeuBlue400,
                    ),
                  )
                else
                  Text(value!),
                icon ?? const Icon(Icons.calendar_month_outlined)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
