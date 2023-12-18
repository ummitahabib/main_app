import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class OnboardingButton extends StatefulWidget {
  const OnboardingButton({
    Key? key,
    required this.buttonWidth,
    required this.buttonHeight,
  }) : super(key: key);

  final double buttonWidth;
  final double buttonHeight;

  @override
  State<OnboardingButton> createState() => _OnboardingButtonState();
}

class _OnboardingButtonState extends State<OnboardingButton> {
  @override
  Widget build(BuildContext context) {
    final appHelper = ApplicationHelpers();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomButton(
          iconPosition: MainAxisAlignment.center,
          text: createAccount,
          onPressed: () {
            appHelper.reRouteUser(context, ConfigRoute.signup, null);
          },
          color: AppColors.SmatCrowPrimary500,
          borderColor: AppColors.SmatCrowPrimary500,
          textColor: AppColors.SmatCrowNeuBlue900,
          height: widget.buttonHeight,
        ),
        customSizedBoxHeight(SpacingConstants.size16),
        CustomButton(
          iconPosition: MainAxisAlignment.center,
          text: logIn,
          onPressed: () {
            appHelper.reRouteUser(context, ConfigRoute.login, null);
          },
          color: Colors.transparent,
          borderColor: AppColors.SmatCrowPrimary500,
          textColor: AppColors.SmatCrowDefaultWhite,
          height: widget.buttonHeight,
        ),
      ],
    );
  }
}
