import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ModalStick extends StatelessWidget {
  const ModalStick({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return const SizedBox.shrink();
    }
    return Center(
      child: Container(
        height: SpacingConstants.size5,
        width: SpacingConstants.size70,
        margin: const EdgeInsets.only(top: SpacingConstants.size10, bottom: SpacingConstants.size10),
        decoration: const BoxDecoration(color: AppColors.SmatCrowNeuBlue200),
      ),
    );
  }
}
