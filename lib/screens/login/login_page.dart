import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/session.dart';

import '../../utils/assets/nsvgs_assets.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/styles.dart';
import '../../utils2/responsive.dart';
import '../widgets/header_text.dart';
import '../widgets/old_text_field.dart';
import '../widgets/sub_header_text.dart';
import 'login_data.dart';

class LoginPage extends StatefulWidget {
  final LoginRouterArgs? loginRouter;

  const LoginPage({
    Key? key,
    this.loginRouter,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final Pandora pandora = Pandora();
  TextEditingController emailAddress = TextEditingController();
  TextEditingController password = TextEditingController();
  String email = '', pass = '', field_pro_offline = '';
  bool _passwordVisible = false;
  bool showLoadingIndicator = false;
  @override
  void initState() {
    final loadPref = Provider.of<LoginData>(context, listen: false).waitForPrefLoad();
    _passwordVisible = false;
    pandora.clearUserData();
    loadPref.whenComplete(() {
      if (widget.loginRouter != null) {
        Provider.of<LoginData>(context, listen: false).validateLoginRouter(widget.loginRouter!, email, pass, context);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = MediaQuery.of(context).size.height;

    return Responsive(
      mobile: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.2),
        body: Column(
          children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Flexible(
              flex: 8,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.brown,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Icon(
                                          Icons.close,
                                          color: AppColors.whiteColor,
                                          size: 25,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 25),
                                child: const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 50.0,
                                    ),
                                    HeaderText(
                                      text: 'Sign in',
                                      color: AppColors.whiteColor,
                                    ),
                                    SizedBox(
                                      height: 20.0,
                                    ),
                                    SubHeaderText(
                                      text: 'Welcome back, let’s sign you in',
                                      color: AppColors.whiteColor,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Email',
                                      style: Styles.labelTextStyle(),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextInputContainer(
                                      child: TextField(
                                        autocorrect: false,
                                        controller: emailAddress,
                                        keyboardType: TextInputType.emailAddress,
                                        style: Styles.textInputStyle(),
                                        decoration: Styles.emailDecoration(),
                                      ),
                                      // color: AppColors.brownLight,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      'Password',
                                      style: Styles.labelTextStyle(),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    TextInputContainer(
                                      child: TextField(
                                        autocorrect: false,
                                        obscureText: !_passwordVisible,
                                        controller: password,
                                        style: Styles.textInputStyle(),
                                        decoration: InputDecoration(
                                          hintText: "Password",
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _passwordVisible = !_passwordVisible;
                                              });
                                            },
                                          ),
                                          hintStyle: Styles.hintTextStyle(),
                                        ),
                                      ),
                                      // color: AppColors.brownLight,
                                    ),
                                    const SizedBox(
                                      height: 55,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            pandora.reRouteUser(
                                              context,
                                              '/resetPasswordPage',
                                              emailAddress.text,
                                            );
                                          },
                                          child: Text(
                                            'Forgot Password',
                                            style: Styles.labelTextStyle(),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Sign in',
                                              style: Styles.semiBoldTextStyleWhite(),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            if (showLoadingIndicator == false)
                                              IconButton(
                                                icon: SvgPicture.asset(
                                                  NsvgsAssets.kLoginFab,
                                                ),
                                                iconSize: 45,
                                                onPressed: () {
                                                  setState(
                                                    () => showLoadingIndicator = true,
                                                  );
                                                  if (Provider.of<LoginData>(
                                                    context,
                                                    listen: false,
                                                  ).validateLogInCredentials(
                                                    emailAddress.text,
                                                    password.text,
                                                  )) {
                                                    Provider.of<LoginData>(
                                                      context,
                                                      listen: false,
                                                    ).logInUser(
                                                      emailAddress.text,
                                                      password.text,
                                                      '/tutorial',
                                                      '',
                                                      context,
                                                    );
                                                    setState(
                                                      () => showLoadingIndicator = false,
                                                    );
                                                  } else {
                                                    setState(
                                                      () => showLoadingIndicator = true,
                                                    );
                                                    pandora.showToast(
                                                      Errors.missingFieldsError,
                                                      context,
                                                      MessageTypes.WARNING.toString().split('.').last,
                                                    );
                                                  }
                                                },
                                              )
                                            else
                                              const CircularProgressIndicator(),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          height: 150,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            pandora.reRouteUser(
                                              context,
                                              '/signUp',
                                              emailAddress.text,
                                            );
                                          },
                                          child: Text(
                                            'Create Free Account',
                                            style: Styles.labelTextStyle(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                    if (field_pro_offline == 'Y')
                                      InkWell(
                                        onTap: () {
                                          pandora.reRouteUser(
                                            context,
                                            '/offline',
                                            '',
                                          );
                                        },
                                        child: Text(
                                          'Offline Mode',
                                          style: Styles.labelTextStyle(),
                                        ),
                                      )
                                    else
                                      const SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      desktop: Material(
        color: AppColors.whiteColor,
        child: SizedBox(
          height: 80,
          width: 100,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Image.asset(
                      NsvgsAssets.kLoginImage,
                      width: size.width,
                      height: size.height,
                      fit: BoxFit.fill,
                    ),
                    SafeArea(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 25),
                            child: SvgPicture.asset(
                              NsvgsAssets.kWhiteLogo,
                              width: 45,
                              height: 45,
                            ),
                          ),
                          const Spacer(),
                          const Padding(
                            padding: EdgeInsets.only(left: 10, right: 9),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 14,
                                ),
                                AppSplashText.empower,
                                SizedBox(
                                  height: 14,
                                ),
                                AppSplashText.helpFarmers,
                                SizedBox(
                                  height: 50,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      ),
                    ),
                    height: height,
                    margin: EdgeInsets.symmetric(horizontal: height * 0.12),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: const Padding(
                                                  padding: EdgeInsets.only(top: 20),
                                                  child: Icon(
                                                    Icons.close,
                                                    color: AppColors.black,
                                                    size: 25,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50.0,
                                        ),
                                        const HeaderText(
                                          text: 'Sign in',
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        const SubHeaderText(
                                          text: 'Welcome back, let’s sign you in',
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 25,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Email',
                                          style: Styles.labelTextStyle2(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          autocorrect: false,
                                          controller: emailAddress,
                                          keyboardType: TextInputType.emailAddress,
                                          style: Styles.textInputStyle2(),
                                          decoration: InputDecoration(
                                            hintText: "Enter email address",
                                            border: Styles.textFieldBorder(),
                                            hintStyle: Styles.hintTextStyle2(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          'Password',
                                          style: Styles.labelTextStyle2(),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        TextField(
                                          autocorrect: false,
                                          obscureText: !_passwordVisible,
                                          controller: password,
                                          keyboardType: TextInputType.emailAddress,
                                          style: Styles.textInputStyle2(),
                                          decoration: InputDecoration(
                                            hintText: "Enter Password",
                                            border: Styles.textFieldBorder(),
                                            hintStyle: Styles.hintTextStyle2(),
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                _passwordVisible ? Icons.visibility : Icons.visibility_off,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  _passwordVisible = !_passwordVisible;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 55,
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                pandora.reRouteUser(
                                                  context,
                                                  '/resetPasswordPage',
                                                  emailAddress.text,
                                                );
                                              },
                                              child: Text(
                                                'Forgot Password',
                                                style: Styles.semiBoldTextStyleBlack(),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'Sign in',
                                                  style: Styles.semiBoldTextStyleBlack(),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                if (showLoadingIndicator == false)
                                                  IconButton(
                                                    icon: SvgPicture.asset(
                                                      NsvgsAssets.kLoginFab,
                                                    ),
                                                    iconSize: 45,
                                                    onPressed: () {
                                                      setState(
                                                        () => showLoadingIndicator = true,
                                                      );
                                                      if (Provider.of<LoginData>(
                                                        context,
                                                        listen: false,
                                                      ).validateLogInCredentials(
                                                        emailAddress.text,
                                                        password.text,
                                                      )) {
                                                        Provider.of<LoginData>(
                                                          context,
                                                          listen: false,
                                                        ).logInUser(
                                                          emailAddress.text,
                                                          password.text,
                                                          '/tutorial',
                                                          '',
                                                          context,
                                                        );
                                                        setState(
                                                          () => showLoadingIndicator = false,
                                                        );
                                                      } else {
                                                        setState(
                                                          () => showLoadingIndicator = true,
                                                        );
                                                        pandora.showToast(
                                                          Errors.missingFieldsError,
                                                          context,
                                                          MessageTypes.WARNING.toString().split('.').last,
                                                        );
                                                      }
                                                    },
                                                  )
                                                else
                                                  const CircularProgressIndicator(),
                                              ],
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(
                                              height: 150,
                                            ),
                                            InkWell(
                                              onTap: () {
                                                pandora.reRouteUser(
                                                  context,
                                                  '/signUp',
                                                  emailAddress.text,
                                                );
                                              },
                                              child: Text(
                                                'Create Free Account',
                                                style: Styles.semiBoldTextStyleBlack(),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                          ],
                                        ),
                                        if (field_pro_offline == 'Y')
                                          InkWell(
                                            onTap: () {
                                              pandora.reRouteUser(
                                                context,
                                                '/offline',
                                                '',
                                              );
                                            },
                                            child: Text(
                                              'Offline Mode',
                                              style: Styles.labelTextStyle(),
                                            ),
                                          )
                                        else
                                          const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
