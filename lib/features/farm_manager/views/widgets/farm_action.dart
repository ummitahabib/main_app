import 'package:flutter/material.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmAction extends StatelessWidget {
  const FarmAction({
    super.key,
    required this.asset,
    required this.name,
    required this.callback,
  });
  final String asset;
  final String name;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.SmatCrowBlue50,
            foregroundImage: AssetImage(asset),
          ),
          const Ymargin(SpacingConstants.size10),
          Text(
            name,
            style: Styles.smatCrowCaptionRegular(color: AppColors.SmatCrowNeuBlue900),
          )
        ],
      ),
    );
  }
}
