import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/icons.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../utils2/spacing_constants.dart';

class UploadFile extends StatelessWidget {
  final String label1;
  final String label2;

  const UploadFile({
    Key? key,
    required this.label1,
    required this.label2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          AppIcons.cloudUpload,
          color: AppColors.SmatCrowPrimary500,
        ),
        Text(
          label1,
          style: Styles.smatCrowMediumCaption(AppColors.SmatCrowPrimary800),
        ),
        const SizedBox(height: SpacingConstants.size8),
        Text(
          label2,
          style: Styles.smatCrowSmallTextRegular(),
        )
      ],
    );
  }
}
