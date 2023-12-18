import 'package:beamer/beamer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/app_helper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

// reset password  main  page
class ResetPassword extends StatefulWidget {
  final Image? image;
  final double? textFieldWidth;

  const ResetPassword({Key? key, this.image, this.textFieldWidth}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  String? token;
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      final path = (context.currentBeamLocation.state as BeamState).pathPatternSegments;
      setState(() {
        token = path.last;
      });
    } else {}
  }

  final newPass = TextEditingController();
  final confirmPass = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: SpacingConstants.size80),
                alignment: Alignment.center,
                child: widget.image,
              ),
              const SizedBox(
                height: SpacingConstants.size124,
              ),
              Text(
                resetPassword,
                style: Styles.smatCrowHeadingBold4(
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              ),
              const SizedBox(
                height: SpacingConstants.size8,
              ),
              const Text(changePasswordText),
              const SizedBox(
                height: SpacingConstants.size62,
              ),
              CustomTextField(
                text: newPassword,
                type: TextFieldType.Password,
                hintText: userPasswordText,
                isRequired: true,
                textEditingController: newPass,
                width: SpacingConstants.size342,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return passwordRequired;
                  }
                  if (!ApplicationHelpers().isValidPassword(value)) {
                    return invalidPassword;
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: SpacingConstants.size24,
              ),
              CustomTextField(
                text: confirmNewPassword,
                type: TextFieldType.Password,
                hintText: userPasswordText,
                textEditingController: confirmPass,
                isRequired: true,
                width: SpacingConstants.size342,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return passwordRequired;
                  }
                  if (!ApplicationHelpers().isValidPassword(value)) {
                    return invalidPassword;
                  }
                  if (value != newPass.text) {
                    return 'Password does not match';
                  }

                  return null;
                },
              ),
              const SizedBox(
                height: SpacingConstants.size40,
              ),
              HookConsumer(
                builder: (context, ref, child) {
                  final auth = ref.watch(authenticationProvider);
                  return CustomButton(
                    iconPosition: MainAxisAlignment.center,
                    width: widget.textFieldWidth ?? SpacingConstants.size342,
                    color: AppColors.SmatCrowPrimary500,
                    borderColor: AppColors.SmatCrowPrimary500,
                    isLoading: auth.loading,
                    text: resetPassword,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (token != null) {
                          ref.read(authenticationProvider).resetPassword(token!, newPass.text.trim()).then((value) {
                            if (value) {
                              Pandora().reRouteUser(context, ConfigRoute.login, "args");
                            }
                          });
                        }
                      }
                    },
                    rightIcon: EvaIcons.arrowForward,
                    textColor: AppColors.SmatCrowNeuBlue900,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
