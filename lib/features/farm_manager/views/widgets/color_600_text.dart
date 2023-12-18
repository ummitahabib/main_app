import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/styles.dart';

class Color600Text extends StatelessWidget {
  const Color600Text({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue600),
    );
  }
}
