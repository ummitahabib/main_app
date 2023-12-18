import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class AppMaterial extends StatelessWidget {
  const AppMaterial({super.key, required this.child, this.width});
  final Widget child;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Material(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.5),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SpacingConstants.font10),
          side: const BorderSide(color: AppColors.SmatCrowNeuBlue200),
        ),
        child: child,
      ),
    );
  }
}
