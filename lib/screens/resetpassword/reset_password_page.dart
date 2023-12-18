import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/crow/crow_authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/header_text.dart';
import 'package:smat_crow/screens/widgets/sub_header_text.dart';
import 'package:smat_crow/screens/widgets/text_field.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/strings.dart';

import '../../utils/assets/nsvgs_assets.dart';
import '../../utils/constants.dart';
import '../../utils/styles.dart';
import '../../utils2/responsive.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final Pandora pandora = Pandora();
  late TextEditingController emailAddress;

  @override
  void initState() {
    super.initState();
    emailAddress = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    emailAddress.dispose();
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
                decoration: Styles.boxDecoStyle(),
                child: Column(
                  children: [
                    Expanded(
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
                                        color: AppColors.closeButtonGrey,
                                        size: 25,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const HeaderText(
                                        text: 'Forgot Password',
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Image.asset(
                                        'assets/nsvgs/forgot_password/forgot_password_lock.png',
                                        width: 20,
                                        height: 20,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  const SubHeaderText(
                                    text:
                                        'Enter the email address you registered with and we’ll send you a link to reset your password.',
                                    color: Colors.black,
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
                                  Text('Email', style: Styles.labelTextStyle2()),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextInputContainer(
                                    color: AppColors.resetPasswordInput,
                                    child: TextField(
                                      autocorrect: false,
                                      controller: emailAddress,
                                      // maxLines: 1,
                                      keyboardType: TextInputType.emailAddress,
                                      style: const TextStyle(
                                        color: AppColors.resetPasswordGrey,
                                        backgroundColor: AppColors.resetPasswordInput,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w400,
                                        fontFamily: 'regular',
                                      ),
                                      decoration: InputDecoration(
                                        hintText: "Enter your registered email address",
                                        border: InputBorder.none,
                                        hintStyle: Styles.hintTextStyle3(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Text('Continue', style: Styles.semiBoldTextStyleBlack()),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: SvgPicture.asset(
                                              NsvgsAssets.kLoginFab,
                                            ),
                                            iconSize: 45,
                                            onPressed: () async {
                                              if (validateEmail(emailAddress.text)) {
                                                final bool resetpass =
                                                    await Provider.of<CrowAuthentication>(context, listen: false)
                                                        .resetPassword(context, emailAddress.text.trim());
                                                if (resetpass) {
                                                  Navigator.pop(context);
                                                  await OneContext().showSnackBar(
                                                    builder: (_) => const SnackBar(
                                                      content: Text('Password Reset Success'),
                                                      backgroundColor: Colors.green,
                                                    ),
                                                  );
                                                } else {
                                                  await OneContext().showSnackBar(
                                                    builder: (_) => const SnackBar(
                                                      content: Text('Password Reset Failed'),
                                                      backgroundColor: Colors.red,
                                                    ),
                                                  );
                                                }
                                              } else {
                                                pandora.showToast(
                                                  Errors.missingEmailsError,
                                                  context,
                                                  MessageTypes.WARNING.toString().split('.').last,
                                                );
                                              }
                                            },
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                ],
                              ),
                            )
                          ],
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
                      borderRadius: BorderRadius.only(topRight: Radius.circular(30), topLeft: Radius.circular(30)),
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
                                    height: 10,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 25),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const HeaderText(
                                              text: 'Forgot Password',
                                              color: Colors.black,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Image.asset(
                                              'assets/nsvgs/forgot_password/forgot_password_lock.png',
                                              width: 20,
                                              height: 20,
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20.0,
                                        ),
                                        const SubHeaderText(
                                          text:
                                              'Enter the email address you registered with and we’ll send you a link to reset your password.',
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(horizontal: 25),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.symmetric(horizontal: 25),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Email', style: Styles.labelTextStyle2()),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextInputContainer(
                                                color: AppColors.resetPasswordInput,
                                                child: TextField(
                                                  autocorrect: false,
                                                  controller: emailAddress,
                                                  // maxLines: 1,
                                                  keyboardType: TextInputType.emailAddress,
                                                  style: const TextStyle(
                                                    color: AppColors.resetPasswordGrey,
                                                    backgroundColor: AppColors.resetPasswordInput,
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.w400,
                                                    fontFamily: 'regular',
                                                  ),
                                                  decoration: InputDecoration(
                                                    hintText: "Enter your registered email address",
                                                    border: InputBorder.none,
                                                    hintStyle: Styles.hintTextStyle3(),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 40,
                                              ),
                                              Row(
                                                children: [
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      Text('Continue', style: Styles.semiBoldTextStyleBlack()),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      IconButton(
                                                        icon: SvgPicture.asset(
                                                          NsvgsAssets.kLoginFab,
                                                        ),
                                                        iconSize: 45,
                                                        onPressed: () async {
                                                          if (validateEmail(emailAddress.text)) {
                                                            final bool resetpass =
                                                                await Provider.of<CrowAuthentication>(
                                                              context,
                                                              listen: false,
                                                            ).resetPassword(
                                                              context,
                                                              emailAddress.text.trim(),
                                                            );
                                                            if (resetpass) {
                                                              Navigator.pop(context);
                                                              await OneContext().showSnackBar(
                                                                builder: (_) => const SnackBar(
                                                                  content: Text('Password Reset Success'),
                                                                  backgroundColor: Colors.green,
                                                                ),
                                                              );
                                                            } else {
                                                              await OneContext().showSnackBar(
                                                                builder: (_) => const SnackBar(
                                                                  content: Text('Password Reset Failed'),
                                                                  backgroundColor: Colors.red,
                                                                ),
                                                              );
                                                            }
                                                          } else {
                                                            pandora.showToast(
                                                              Errors.missingEmailsError,
                                                              context,
                                                              MessageTypes.WARNING.toString().split('.').last,
                                                            );
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                              const SizedBox(
                                                height: 15,
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

  bool validateLogInCredentials(String emailAddress, String password) {
    return (password.isEmpty || emailAddress.isEmpty) ? false : true;
  }

  bool validateEmail(String emailAddress) {
    return (emailAddress.isEmpty) ? false : true;
  }
}
