import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class TapCard extends StatelessWidget {
  const TapCard({
    super.key,
    required this.selectedIndex,
    required this.name,
    required this.tap,
    required this.index,
  });

  final int selectedIndex;
  final int index;
  final String name;
  final VoidCallback tap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
        ),
        width: Responsive.xWidth(context, percent: 0.43),
        child: Card(
          elevation: selectedIndex == index ? 1 : 0,
          color: selectedIndex == index ? null : AppColors.SmatCrowNeuBlue100,
          child: Center(
            child: Text(
              name,
              style: Styles.smatCrowMediumCaption(AppColors.SmatCrowNeuBlue900)
                  .copyWith(fontSize: SpacingConstants.font14),
            ),
          ),
        ),
      ),
    );
  }
}
