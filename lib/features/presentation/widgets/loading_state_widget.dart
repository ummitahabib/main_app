import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smat_crow/utils2/colors.dart';

import 'package:smat_crow/utils2/spacing_constants.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SpinKitCircle(
      size: SpacingConstants.size30,
      color: AppColors.SmatCrowBlack400,
    );
  }
}
