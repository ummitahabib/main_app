import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/styles.dart';

class BoldHeaderText extends StatelessWidget {
  const BoldHeaderText({super.key, required this.text, this.fontSize, this.fontFamily, this.color});
  final String text;
  final double? fontSize;
  final String? fontFamily;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Styles.smatCrowMediumParagraph(color: color ?? AppColors.SmatCrowNeuBlue900)
          .copyWith(fontSize: fontSize ?? 16, fontWeight: FontWeight.bold, fontFamily: fontFamily),
    );
  }
}
