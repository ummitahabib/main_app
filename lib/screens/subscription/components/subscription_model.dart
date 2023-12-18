import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_container.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SubscriptionModal {
  static Future showSubscriptionModal(BuildContext context) {
    return customDialogAndModal(
      context,
      DialogContainer(
        height: Responsive.yHeight(
          context,
          percent: Responsive.isTablet(context)
              ? SpacingConstants.size0point4
              : Responsive.isDesktop(context)
                  ? SpacingConstants.size0point6
                  : SpacingConstants.size0point55,
        ),
        child: Padding(
          padding: const EdgeInsets.all(SpacingConstants.size20),
          child: Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Padding(
                padding: Responsive.isDesktop(context)
                    ? const EdgeInsets.symmetric(
                        horizontal: SpacingConstants.size50,
                      )
                    : Responsive.isTablet(context)
                        ? const EdgeInsets.symmetric(
                            horizontal: SpacingConstants.size70,
                            vertical: SpacingConstants.size30,
                          )
                        : const EdgeInsets.all(SpacingConstants.size20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    customSizedBoxHeight(SpacingConstants.size20),
                    SizedBox(
                      height: SpacingConstants.size100,
                      width: SpacingConstants.size100,
                      child: Image.asset(AppAssets.idea),
                    ),
                    customSizedBoxHeight(SpacingConstants.size20),
                    Text(
                      oneTimeAccess,
                      style: Styles.smatCrowParagrahBold(
                        color: AppColors.SmatCrowNeuBlue900,
                      ).copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: SpacingConstants.size16,
                      ),
                    ),
                    customSizedBoxHeight(SpacingConstants.size10),
                    Text(
                      paidFeatureLongMsg,
                      style: Styles.smatCrowParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    customSizedBoxHeight(SpacingConstants.size30),
                    CustomButton(
                      text: payNow,
                      onPressed: () {
                        Pandora().reRouteUser(context, ConfigRoute.subscriptionPlanView, "args");
                      },
                      color: AppColors.SmatCrowPrimary500,
                      fontSize: SpacingConstants.size16,
                      width: Responsive.xWidth(context),
                      height: SpacingConstants.size47,
                    ),
                    customSizedBoxHeight(SpacingConstants.size20),
                    TextButton(
                      onPressed: () {
                        Pandora().reRouteUser(context, ConfigRoute.subscriptionPlanView, "args");
                      },
                      child: Text(
                        viewSubPlan,
                        style: Styles.smatCrowParagraphRegular(
                          color: AppColors.SmatCrowPrimary500,
                        ).copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: SpacingConstants.size12,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () async {
                    if (kIsWeb) {
                      OneContext().popDialog();
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  splashRadius: SpacingConstants.size20,
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.SmatCrowNeuBlue400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
