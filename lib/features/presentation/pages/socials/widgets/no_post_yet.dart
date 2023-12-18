import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class NoPostYetWidget extends StatelessWidget {
  const NoPostYetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        SocialConst.noPostYet,
        style:
            Styles.smatCrowDisplayBold3(color: AppColors.SmatCrowDefaultBlack),
      ),
    );
  }
}
