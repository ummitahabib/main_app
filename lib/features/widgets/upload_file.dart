import 'package:flutter/material.dart';
import 'package:smat_crow/features/widgets/file.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../utils2/icons.dart';

class Upload extends StatelessWidget {
  final String label1;
  final String label2;
  final String label3;
  final Color IconColor;
  final Widget? progressIndicator;
  final TextStyle? style;
  const Upload({
    Key? key,
    required this.label1,
    required this.label2,
    required this.label3,
    required this.IconColor,
    this.progressIndicator,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SpacingConstants.uploadPadding(
          child: FolderIcon(icon: AppIcons.folder),
        ),
        const SizedBox(width: SpacingConstants.size16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FileWidget(label1: label1, label2: label2),
            const SizedBox(height: SpacingConstants.size8),
            SpacingConstants.uploadSize(
              child: progressIndicator,
            ),
            const SizedBox(height: SpacingConstants.size8),
            Text(label3, style: style),
          ],
        ),
      ],
    );
  }
}
