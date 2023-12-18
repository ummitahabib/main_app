import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmManagerGetStartedCard extends StatelessWidget {
  const FarmManagerGetStartedCard({
    super.key,
    this.active = true,
  });

  final bool active;

  @override
  Widget build(BuildContext context) {
    if (active) {
      return const SizedBox.shrink();
    }
    return AppContainer(
      child: Row(
        mainAxisSize: kIsWeb ? MainAxisSize.min : MainAxisSize.max,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              const SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  value: 0.3,
                  color: AppColors.SmatCrowGreen600,
                  backgroundColor: AppColors.SmatCrowNeuBlue100,
                ),
              ),
              Text(
                "10%",
                style: Styles.smatCrowMediumParagraph(
                  color: AppColors.SmatCrowGreen600,
                ).copyWith(fontSize: SpacingConstants.font16),
              )
            ],
          ),
          customSizedBoxWidth(SpacingConstants.size20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BoldHeaderText(
                text: Responsive.isDesktop(context)
                    ? "Welcome to AirSmat! Let's get you started"
                    : "Welcome to AirSmat!\nLet's get you started",
              ),
              const SizedBox(height: SpacingConstants.font10),
              Text(
                "We'll help you get set up right",
                style: Styles.smatCrowCaptionRegular(
                  color: AppColors.SmatCrowNeuBlue500,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
