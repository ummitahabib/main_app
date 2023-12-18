import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SiteLatLngLabel extends StatelessWidget {
  const SiteLatLngLabel({
    super.key,
    required this.head,
    required this.lat,
    required this.lng,
  });
  final String head;
  final String lat;
  final String lng;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          head,
          style: Styles.smatCrowSubParagraphRegular(
            color: AppColors.SmatCrowNeuBlue500,
          ),
        ),
        customSizedBoxHeight(SpacingConstants.size10),
        Text(
          "$latText. $lat\n$lngText. $lng",
          style: Styles.smatCrowMediumCaption(AppColors.SmatCrowNeuBlue900)
              .copyWith(fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
