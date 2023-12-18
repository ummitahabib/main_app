import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class DialogHeader extends StatelessWidget {
  const DialogHeader({
    super.key,
    required this.headText,
    this.callback,
    this.showIcon = kIsWeb,
    this.padding,
    this.showDivider = true,
    this.mainAxisAlignment = MainAxisAlignment.center,
  });
  final String headText;
  final VoidCallback? callback;
  final bool showIcon;
  final EdgeInsets? padding;
  final bool showDivider;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: SpacingConstants.double20,
                vertical: SpacingConstants.size10,
              ),
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            children: [
              Text(
                headText,
                style: kIsWeb
                    ? Styles.smatCrowMediumHeading6(color: AppColors.SmatCrowNeuBlue900)
                        .copyWith(fontWeight: FontWeight.bold)
                    : Styles.smatCrowMediumBody(color: AppColors.SmatCrowNeuBlue900)
                        .copyWith(fontWeight: FontWeight.bold),
              ),
              if (showIcon)
                GestureDetector(
                  onTap: callback,
                  child: const Icon(
                    Icons.close,
                    color: AppColors.SmatCrowNeuBlue400,
                  ),
                )
            ],
          ),
        ),
        if (showDivider) const Divider(),
        if (showDivider) const Ymargin(SpacingConstants.font10)
      ],
    );
  }
}
