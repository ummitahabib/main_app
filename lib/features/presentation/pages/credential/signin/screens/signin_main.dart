// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:provider/provider.dart' as pro;
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/data/models/signin_request.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/presentation/provider/credentials.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/signin_route_config.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

// signin main page

class SignInMainPage extends StatefulHookConsumerWidget {
  final double? fieldWidth;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? sizeHeight;
  final double? imageWidget;
  final Image? image;
  final double? logoSizeBox;
  final double? textSizeBox;
  final double? buttonSizeBox;
  final LoginRouteConfig? loginRouterConfig;
  final double? width;

  const SignInMainPage({
    Key? key,
    this.fieldWidth,
    this.buttonWidth,
    this.buttonHeight,
    this.sizeHeight,
    this.imageWidget,
    this.image,
    this.logoSizeBox,
    this.textSizeBox,
    this.buttonSizeBox,
    this.loginRouterConfig,
    this.width,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInMainPageState();
}

class _SignInMainPageState extends ConsumerState<SignInMainPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final appHelper = ApplicationHelpers();
  final formKey = GlobalKey<FormState>();
  final UserEntity? currentUser = const UserEntity();

  bool _isSigningIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    appHelper.getFromSharedPreferences("email").then((value) {
      setState(() {
        _emailController.text = value;
      });
    });
    appHelper.getFromSharedPreferences("password").then((value) {
      setState(() {
        _passwordController.text = value;
      });
    });
  }

  Future<void> _hybridSignIn() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    await appHelper.saveToSharedPreferences("email", email);
    await appHelper.saveToSharedPreferences("password", password);
    setState(() {
      _isSigningIn = true;
    });

    final request = SigninRequest(
      email: email,
      password: password,
    );

    try {
      final authenticationNotifier = ref.read(authenticationProvider);
      await authenticationNotifier.signinUser(request);
      setState(() {
        _isSigningIn = false;
      });
      if (authenticationNotifier.authResponse != null) {
        if (ref.read(sharedProvider).userInfo != null && !ref.read(sharedProvider).userInfo!.user.isVerified) {
          appHelper.reRouteUser(
            context,
            ConfigRoute.verifyEmailPage,
            authenticationNotifier.authResponse!.token,
          );
          return;
        }
        ref.read(sharedProvider).selected = ConfigRoute.mainPage;
        appHelper.reRouteUser(
          context,
          ConfigRoute.mainPage,
          authenticationNotifier.authResponse!.token,
        );
      }
    } catch (e) {
      setState(() {
        _isSigningIn = false;
      });
      appHelper.trackAPIEvent(
        'SIGNIN',
        'SIGNIN',
        'API_SIGNIN_ERROR',
        e.toString(),
      );
      snackBarMsg(e.toString());
    }
  }

  Future<bool> _signInViaFirebase(String email, String password) async {
    setState(() {
      _isSigningIn = true;
    });
    try {
      final result = await pro.Provider.of<CredentialProvider>(context, listen: false).signInUser(
        email: email,
        password: password,
      );

      setState(() {
        _isSigningIn = false;
      });
      if (result != null) {
        await Pandora().saveToSharedPreferences(Const.uid, result.user!.uid);
        return true;
      }
      return false;
    } catch (e) {
      setState(() {
        _isSigningIn = false;
      });
      appHelper.trackAPIEvent(
        'SIGNIN',
        'SIGNIN',
        'FIREBASE_SIGNIN_ERROR',
        e.toString(),
      );
      log(e.toString());
      snackBarMsg(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size10),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(
                  top: SpacingConstants.size80,
                ),
                alignment: Alignment.center,
                child: widget.image,
              ),
              SizedBox(height: widget.logoSizeBox),
              Text(
                signIn,
                style: Styles.smatCrowMediumHeading4(
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              ),
              const SizedBox(height: SpacingConstants.size8),
              Text(
                welcome,
                style: Styles.smatCrowSubParagraphRegular(
                  color: AppColors.SmatCrowNeuBlue500,
                ),
              ),
              const SizedBox(height: SpacingConstants.size48),
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
                textEditingController: _emailController,
                type: TextFieldType.Email,
                hintText: enterEmail,
                text: emailTextField,
                isRequired: true,
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
                textEditingController: _passwordController,
                type: TextFieldType.Password,
                hintText: hintPassword,
                text: passwordTextField,
                isRequired: true,
                width: widget.width ?? SpacingConstants.size342,
              ),
              const SizedBox(height: SpacingConstants.size24),
              GestureDetector(
                onTap: () {
                  appHelper.trackButtonAndDeviceEvent(
                    'FORGET_PASSWORD_BUTTON_CLICKED',
                  );
                  appHelper.reRouteUser(
                    context,
                    ConfigRoute.userForgetPassword,
                    "email",
                  );
                },
                child: Text(
                  forget,
                  style: Styles.smatCrowUnderline2(),
                ),
              ),
              const SizedBox(
                height: SpacingConstants.size24,
              ),
              CustomButton(
                isLoading: _isSigningIn,
                text: signIn,
                onPressed: () async {
                  FocusScope.of(context).unfocus();
                  if (formKey.currentState!.validate()) {
                    setState(() {
                      _isSigningIn = true;
                    });
                    await _hybridSignIn();
                  }
                },
                rightIcon: _isSigningIn ? null : EvaIcons.arrowForward,
                width: widget.buttonWidth,
                height: widget.buttonHeight,
                color: AppColors.SmatCrowPrimary500,
                borderColor: AppColors.SmatCrowPrimary500,
                iconPosition: MainAxisAlignment.center,
                textColor: AppColors.SmatCrowNeuBlue900,
              ),
              SizedBox(height: widget.buttonSizeBox),
              RichText(
                text: TextSpan(
                  text: userDontHaveAccountText,
                  style: Styles.smatCrowSubParagraphRegular(
                    color: AppColors.SmatCrowNeuBlue500,
                  ),
                  children: [
                    TextSpan(
                      text: userCreateAccount,
                      style: Styles.smatCrowSubRegularUnderline(
                        color: AppColors.SmatCrowPrimary500,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          appHelper.trackButtonAndDeviceEvent(
                            'SIGNUP_BUTTON_CLCIKED',
                          );

                          appHelper.reRouteUser(
                            context,
                            ConfigRoute.signup,
                            emptyString,
                          );
                        },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpacingConstants.size24),
            ],
          ),
        ),
      ),
    );
  }
}
