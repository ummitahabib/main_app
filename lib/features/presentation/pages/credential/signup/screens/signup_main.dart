import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as pro;
import 'package:smat_crow/features/presentation/provider/auth_provider.dart';
import 'package:smat_crow/features/presentation/provider/credentials.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SignUpMainPage extends StatefulHookConsumerWidget {
  final String? data;
  final double? height;
  final double? signupSizedBox;
  final double? signUpBottonWidth;
  final Image? image;
  final double? imageHeight;
  final double? width;

  const SignUpMainPage({
    Key? key,
    this.height,
    this.signupSizedBox,
    this.signUpBottonWidth,
    this.image,
    this.imageHeight,
    this.data,
    this.width,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpMainPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isSigningUp = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  final appHelper = ApplicationHelpers();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      body: pro.Consumer<CredentialProvider>(
        builder: (context, credentialProvider, _) {
          const credentialState = CredentialStatus.loading;
          if (credentialState == CredentialStatus.success) {
            pro.Provider.of<AuthProvider>(context, listen: false).loggedIn();
          }
          if (credentialState == CredentialStatus.failure) {}
          return Container(
            color: AppColors.SmatCrowDefaultWhite,
            padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size24),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            top: SpacingConstants.size80,
                          ),
                          alignment: Alignment.center,
                          child: widget.image,
                        ),
                        SizedBox(
                          height: widget.imageHeight ?? SpacingConstants.size40,
                        ),
                        Center(
                          child: Text(
                            userCreateAccount,
                            style: Styles.smatCrowHeadingBold4(
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: SpacingConstants.size8,
                        ),
                        Text(
                          createAccountText,
                          style: Styles.smatCrowSubParagraphRegular(
                            color: AppColors.SmatCrowNeuBlue500,
                          ),
                        ),
                        customSizedBoxHeight(SpacingConstants.size40),
                        Column(
                          children: [
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return firstnameRequired;
                                }
                                return null;
                              },
                              textEditingController: credentialProvider.firstnameController,
                              type: TextFieldType.Default,
                              hintText: firstNameHint,
                              isRequired: true,
                              text: firstNameText,
                              width: widget.width ?? SpacingConstants.size342,
                            ),
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return lastnameRequired;
                                }
                                return null;
                              },
                              textEditingController: credentialProvider.lastnameController,
                              type: TextFieldType.Default,
                              hintText: lastNameHint,
                              isRequired: true,
                              text: lastNameText,
                              width: widget.width ?? SpacingConstants.size342,
                            ),
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return emailRequired;
                                }
                                if (!ApplicationHelpers().isValidEmail(value)) {
                                  return invalidEmail;
                                }
                                return null;
                              },
                              textEditingController: credentialProvider.emailController,
                              type: TextFieldType.Email,
                              hintText: emailHint,
                              isRequired: true,
                              text: emailText,
                              width: widget.width ?? SpacingConstants.size342,
                            ),
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return passwordRequired;
                                }
                                if (!ApplicationHelpers().isValidPassword(value)) {
                                  return invalidPassword;
                                }
                                return null;
                              },
                              textEditingController: credentialProvider.passwordController,
                              type: TextFieldType.Password,
                              hintText: hintPassword,
                              isRequired: true,
                              text: passwordTextField,
                              width: widget.width ?? SpacingConstants.size342,
                            ),
                            SizedBox(
                              height: widget.signupSizedBox ?? SpacingConstants.size13,
                            ),
                            SizedBox(
                              width: widget.signUpBottonWidth ?? SpacingConstants.size342,
                              child: CustomButton(
                                isLoading: _isSigningUp,
                                text: userCreateAccount,
                                onPressed: () async {
                                  appHelper.trackButtonAndDeviceEvent(
                                    'SIGNUP_BUTTON_CLICKED',
                                  );
                                  FocusScope.of(context).unfocus();
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isSigningUp = true;
                                    });
                                    await credentialProvider.createUserAccount(context);
                                    setState(() {
                                      _isSigningUp = false;
                                    });
                                  }
                                },
                                rightIcon: _isSigningUp ? null : EvaIcons.arrowForward,
                                iconColor: AppColors.SmatCrowNeuBlue900,
                                borderColor: AppColors.SmatCrowPrimary500,
                                color: AppColors.SmatCrowPrimary500,
                                textColor: AppColors.SmatCrowNeuBlue900,
                                width: SpacingConstants.size342,
                                iconPosition: MainAxisAlignment.center,
                              ),
                            ),
                            SizedBox(
                              height: widget.signupSizedBox ?? SpacingConstants.size50,
                            ),
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
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: widget.signupSizedBox ?? SpacingConstants.size50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
