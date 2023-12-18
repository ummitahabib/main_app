import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SatelliteImagery extends StatelessWidget {
  const SatelliteImagery({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DialogContainer(
      height: Responsive.yHeight(
        context,
        percent: Responsive.isTablet(context)
            ? SpacingConstants.size0point3
            : kIsWeb
                ? SpacingConstants.size0point4
                : SpacingConstants.size0point3,
      ),
      child: Column(
        children: [
          if (!kIsWeb) const ModalStick(),
          const SizedBox(
            height: kIsWeb ? SpacingConstants.size10 : SpacingConstants.size20,
          ),
          DialogHeader(
            headText: satelliteImagery,
            callback: () {
              if (kIsWeb) {
                OneContext().popDialog();
              } else {
                Navigator.pop(context);
              }
            },
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
              vertical: SpacingConstants.size10,
            ),
            showDivider: kIsWeb,
          ),
          customSizedBoxHeight(SpacingConstants.size20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
              vertical: Responsive.isTablet(context) ? SpacingConstants.size40 : 0,
            ),
            child: Column(
              children: [
                Container(
                  height: SpacingConstants.size40,
                  width: SpacingConstants.size40,
                  decoration: const BoxDecoration(
                    color: AppColors.SmatCrowNeuBlue900,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.compass,
                    color: Colors.white,
                    height: SpacingConstants.size24,
                    width: SpacingConstants.size24,
                  ),
                ),
                customSizedBoxHeight(SpacingConstants.size10),
                Text(
                  contact,
                  style: Styles.smatCrowParagraphRegular(
                    color: AppColors.SmatCrowNeuBlue800,
                  ),
                ),
                customSizedBoxHeight(SpacingConstants.size10),
                TextButton(
                  onPressed: () {
                    Pandora().composeEmail();
                  },
                  child: Text(
                    "sales@airsmat.com",
                    style: Styles.smatCrowParagraphRegular(
                      color: AppColors.SmatCrowPrimary400,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
