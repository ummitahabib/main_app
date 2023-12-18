import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/styles.dart';

class TrendingText extends StatelessWidget {
  const TrendingText({
    super.key,
    required this.text,
    required this.percent,
  });

  final String text;
  final String percent;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: text,
            style: Styles.smatCrowMediumSubParagraph(),
          ),
          TextSpan(
            text: percent,
            style: Styles.smatCrowMediumSubParagraph(color: AppColors.SmatCrowGreen300),
          ),
        ],
      ),
      textAlign: TextAlign.center,
    );
  }
}
