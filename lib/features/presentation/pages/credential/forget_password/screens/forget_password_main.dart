import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/data/models/forget_password_request.dart';
import 'package:smat_crow/features/presentation/widgets/alert.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/enum.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

//forget password main page

class ForgetPasswordPage extends HookConsumerWidget {
  final Image? image;
  final double? sizedBoxHeight;
  final double? buttonSizeBoxHeight;
  final double? extraSizeBox;
  final double? textFieldWidth;
  const ForgetPasswordPage({
    Key? key,
    this.image,
    this.sizedBoxHeight,
    this.buttonSizeBoxHeight,
    this.extraSizeBox,
    this.textFieldWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();

    final authenticationNotifier = ref.watch(authenticationProvider);
    final emailAddress = useTextEditingController();
    final appHelper = ApplicationHelpers();
    final loading = useState(false);
    Future<void> forgetPasswordCheck() async {
      loading.value = true;
      final request = ForgetpasswordRequest(
        email: emailAddress.text.trim(),
      );
      final bool userExists = await authenticationNotifier.userResetPassword(
        context,
        request,
      );
      loading.value = false;
      if (userExists) {
        appHelper.reRouteUser(
          context,
          ConfigRoute.verifyEmailPage,
          emptyString,
        );
      } else {
        showErrorDialog(
          alertHeaderText: forgetPasswordFailedHeader,
          messageType: MessageTypes.FAILED.toString().split(splitString).last,
          alertBodyDescription: forgetPasswordFailedDescription,
          onPressedFirstbutton: () {
            appHelper.reRouteUser(
              context,
              ConfigRoute.userForgetPassword,
              null,
            );
          },
          onPressedSecondbutton: () {
            appHelper.reRouteUser(context, ConfigRoute.login, null);
          },
          leftbuttonText: tryAgainError,
          rightbuttonText: cancel,
        );
      }
    }

    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: SpacingConstants.size80),
                  alignment: Alignment.center,
                  child: image,
                ),
                const SizedBox(
                  height: SpacingConstants.size124,
                ),
                Text(
                  forgetPassword,
                  style: Styles.smatCrowHeadingBold4(
                    color: AppColors.SmatCrowNeuBlue900,
                  ),
                ),
                customSizedBoxHeight(
                  SpacingConstants.size8,
                ),
                Text(
                  enterEmailAddress,
                  style: Styles.smatCrowSubParagraphRegular(
                    color: AppColors.SmatCrowNeuBlue500,
                  ),
                ),
                customSizedBoxHeight(
                    buttonSizeBoxHeight ?? SpacingConstants.size40),
                CustomTextField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return emailRequired;
                    }
                    if (!ApplicationHelpers().isValidEmail(value)) {
                      return invalidEmail;
                    }
                    return null;
                  },
                  textEditingController: emailAddress,
                  text: emailField,
                  type: TextFieldType.Email,
                  hintText: forgetPasswordHint,
                  isRequired: true,
                  width: textFieldWidth ?? SpacingConstants.size342,
                ),
                SizedBox(
                  height: sizedBoxHeight ?? SpacingConstants.size32,
                ),
                CustomButton(
                  iconPosition: MainAxisAlignment.center,
                  text: continueText,
                  rightIcon: EvaIcons.arrowForward,
                  borderColor: AppColors.SmatCrowPrimary500,
                  color: AppColors.SmatCrowPrimary500,
                  width: textFieldWidth ?? SpacingConstants.size342,
                  isLoading: loading.value,
                  onPressed: () async {
                    appHelper.trackButtonAndDeviceEvent('CONTINUE_BUTTON');
                    if (formKey.currentState!.validate()) {
                      await forgetPasswordCheck();
                    }
                  },
                ),
                customSizedBoxHeight(extraSizeBox ?? SpacingConstants.size213),
                RichText(
                  text: TextSpan(
                    text: haveAccount,
                    style: Styles.smatCrowSubParagraphRegular(
                      color: AppColors.SmatCrowNeuBlue500,
                    ),
                    children: [
                      TextSpan(
                        text: logIn,
                        style: Styles.smatCrowSubRegularUnderline(
                          color: AppColors.SmatCrowPrimary500,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            appHelper.trackButtonAndDeviceEvent(
                              'LOGIN_BUTTON_CLICKED',
                            );

                            appHelper.reRouteUser(
                              context,
                              ConfigRoute.login,
                              null,
                            );
                          },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
