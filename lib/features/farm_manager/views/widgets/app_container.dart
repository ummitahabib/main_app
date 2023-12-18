import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({super.key, required this.child, this.width, this.padding, this.color, this.height});
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.SmatCrowNeuBlue200),
        borderRadius: BorderRadius.circular(SpacingConstants.font10),
        color: color ?? Colors.transparent,
      ),
      height: height,
      width: width,
      child: child,
    );
  }
}
