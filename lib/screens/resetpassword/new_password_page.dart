import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/header_text.dart';
import 'package:smat_crow/screens/widgets/sub_header_text.dart';
import 'package:smat_crow/screens/widgets/text_field.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/strings.dart';

import '../../utils/assets/nsvgs_assets.dart';
import '../../utils/styles.dart';
import '../signup/new_account_data.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({
    Key? key,
  }) : super(key: key);

  @override
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final Pandora pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    final TextEditingController newPassword = TextEditingController();
    final TextEditingController confirmPassword = TextEditingController();

    return Scaffold(
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
                      margin: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Padding(
                                  padding: EdgeInsets.all(27.29),
                                  child: Icon(
                                    Icons.close,
                                    color: AppColors.closeButtonGrey,
                                    size: 11.41,
                                  ),
                                ),
                              )
                            ],
                          ),
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const HeaderText(
                                      text: 'Set New Password',
                                      color: Colors.black,
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Image.asset(
                                      NsvgsAssets.kResetPassKey,
                                      width: 20,
                                      height: 20,
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                const SubHeaderText(
                                  text: 'Create a new and secure password for your account',
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Text('New Password', style: Styles.labelTextStyle2()),
                          const SizedBox(
                            height: 10,
                          ),
                          TextInputContainer(
                            color: AppColors.resetPasswordInput,
                            child: TextField(
                              autocorrect: false,
                              controller: newPassword,
                              obscureText: true,
                              keyboardType: TextInputType.emailAddress,
                              style: Styles.textInputStyle2(),
                              decoration: InputDecoration(
                                hintText: "Enter Password",
                                border: InputBorder.none,
                                hintStyle: Styles.hintTextStyle2(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text('Confirm Password', style: Styles.labelTextStyle2()),
                          const SizedBox(
                            height: 10,
                          ),
                          TextInputContainer(
                            color: AppColors.resetPasswordInput,
                            child: TextField(
                              autocorrect: false,
                              controller: confirmPassword,
                              obscureText: true,
                              keyboardType: TextInputType.emailAddress,
                              style: Styles.inputStyle(),
                              decoration: InputDecoration(
                                hintText: "Confirm Password",
                                border: InputBorder.none,
                                hintStyle: Styles.inputStyle(),
                              ),
                            ),
                          ),
                          const Spacer(),
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
                                    icon: SvgPicture.asset(NsvgsAssets.kLoginFab),
                                    iconSize: 45,
                                    onPressed: () {
                                      if (Provider.of<NewAccountProvider>(context, listen: false)
                                          .validatePasswords(newPassword.text, confirmPassword.text)) {
                                        if (Provider.of<NewAccountProvider>(context, listen: false)
                                            .verifyPasswords(newPassword.text, confirmPassword.text)) {
                                          //String phoneNumber = '08123418017';
                                          // pandora.reRouteUser(context, '/otpPage',
                                          //     OtpArguments(phoneNumber, '/newPasswordPage'));
                                        } else {
                                          pandora.showToast(
                                            Errors.passwordNotMatch,
                                            context,
                                            MessageTypes.WARNING.toString().split('.').last,
                                          );
                                        }
                                      } else {
                                        pandora.showToast(
                                          Errors.missingFieldsError,
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
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
