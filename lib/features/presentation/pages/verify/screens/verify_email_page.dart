// ignore_for_file: use_build_context_synchronously

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/presentation/provider/verify_email_state.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class VerifyEmailPage extends StatelessWidget {
  final Image? image;
  final Image? imageVerify;
  final double? imageSizedBox;
  final double? sizedBoxHeight;
  final double? buttonSizeBox;
  final double? mailLogoWidth;
  final double? mailLogoHeight;

  const VerifyEmailPage({
    Key? key,
    this.image,
    this.imageVerify,
    this.imageSizedBox,
    this.sizedBoxHeight,
    this.buttonSizeBox,
    this.mailLogoWidth,
    this.mailLogoHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: SpacingConstants.size0,
        backgroundColor: AppColors.SmatCrowDefaultWhite,
        leading: IconButton(
          icon: const Icon(EvaIcons.arrowCircleLeft),
          onPressed: () {
            ApplicationHelpers().reRouteUser(context, ConfigRoute.login, emptyString);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: SpacingConstants.size80),
                alignment: Alignment.center,
                child: image,
              ),
              const SizedBox(
                height: SpacingConstants.size40,
              ),
              Text(
                verifyEmail,
                style: Styles.smatCrowHeadingBold4(
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              ),
              const SizedBox(
                height: SpacingConstants.size8,
              ),
              const Text(
                sentLink,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: sizedBoxHeight ?? SpacingConstants.size20,
              ),
              Container(
                width: mailLogoWidth ?? SpacingConstants.size250,
                height: mailLogoHeight ?? SpacingConstants.size246,
                margin: const EdgeInsets.only(top: SpacingConstants.size80),
                alignment: Alignment.center,
                child: MailLogo(),
              ),
              SizedBox(
                height: imageSizedBox ?? SpacingConstants.size94,
              ),
              CustomButton(
                width: SpacingConstants.size342,
                iconPosition: MainAxisAlignment.spaceBetween,
                text: openMail,
                onPressed: () async {
                  final result = await OpenMailApp.openMailApp();
                  (!result.didOpen && !result.canOpen)
                      ? Provider.of<VerifyUserState>(context, listen: false).showNoMailAppsDialog(context)
                      : (!result.didOpen && result.canOpen)
                          ? showDialog(
                              context: context,
                              builder: (_) {
                                return MailAppPickerDialog(
                                  mailApps: result.options,
                                );
                              },
                            )
                          : null;
                },
                borderColor: AppColors.SmatCrowPrimary500,
                color: AppColors.SmatCrowPrimary500,
              ),
              SizedBox(
                height: buttonSizeBox ?? SpacingConstants.size21,
              ),
              const SizedBox(
                height: SpacingConstants.size42,
              )
            ],
          ),
        ),
      ),
    );
  }
}
