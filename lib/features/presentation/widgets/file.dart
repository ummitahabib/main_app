import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FileWidget extends StatelessWidget {
  const FileWidget({
    Key? key,
    required this.label1,
    required this.label2,
  }) : super(key: key);

  final String label1;
  final String label2;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label1,
          style: Styles.smatCrowMediumCaption(AppColors.SmatCrowPrimary800),
        ),
        const SizedBox(
          width: SpacingConstants.size10,
        ),
        Text(
          label2,
          style: Styles.smatCrowHeadingRegular7(
            color: AppColors.SmatCrowNeuBlue500,
          ),
        ),
      ],
    );
  }
}
