//import 'dart:io' show Platform;

import 'dart:io' as plt;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:inapp_browser/inapp_browser.dart';
import 'package:intl_phone_number_field/intl_phone_number_field.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/signup/verify_account_page.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/strings.dart';

import '../../network/crow/crow_authentication.dart';
import '../../utils/assets/nsvgs_assets.dart';
import '../../utils/colors.dart';
import '../../utils/styles.dart';
import '../../utils2/responsive.dart';
import '../widgets/header_text.dart';
import '../widgets/sub_header_text.dart';

class NewAccountProvider extends ChangeNotifier {
  final Pandora pandora = Pandora();
  TextEditingController phone = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool termsAndConditions = false;

  Pandora get _pandora => pandora;

  bool validateInfo(
    String firstName,
    String lastName,
    String email,
    String phone,
  ) {
    bool isValid = false;
    // if (plt.Platform.isWindows) {
    if (plt.Platform.isAndroid) {
      if (firstName.trim().isEmpty || lastName.trim().isEmpty || email.trim().isEmpty || phone.trim().isEmpty) {
        isValid = false;
      } else {
        isValid = true;
      }
    } else if (plt.Platform.isIOS) {
      //else if  (Platform.isAndroid){
      if (firstName.trim().isEmpty || lastName.trim().isEmpty || email.trim().isEmpty) {
        isValid = false;
      } else {
        isValid = true;
      }
    }
    //  }

    return isValid;
  }

  void acceptTermsAndConditionsChanged(bool newValue) => termsAndConditions = newValue;
  @override
  notifyListeners();

  bool validatePasswords(String newPassword, String confirmPassword) {
    return (newPassword.isEmpty || confirmPassword.isEmpty) ? false : true;
  }

  bool verifyPasswords(String newPassword, String confirmPassword) {
    return (newPassword == confirmPassword) ? true : false;
  }

  Future<void> createNewUser(
    firstName,
    lastName,
    email,
    phone,
    newPassword,
    BuildContext context,
  ) async {
    await pandora.saveToSharedPreferences('email', email);
    await pandora.saveToSharedPreferences('password', newPassword);
    USER_NAME = Pandora.getEmailUserName(email);
    pandora.logAPPButtonClicksEvent('CREATE_BUTTON_CLICKED');
    debugPrint(phone);
    final bool createAccount = await Provider.of<CrowAuthentication>(context, listen: false).createNewAccount(
      context,
      firstName,
      lastName,
      email,
      phone,
      newPassword,
    );
    createAccount
        ? accountCreated(context)
        : OneContext().showSnackBar(
            builder: (_) => const SnackBar(
              content: Text('Registration Failed !'),
              backgroundColor: Colors.red,
            ),
          );
  }

  Responsive newAccount(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
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
                      child: SingleChildScrollView(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 25),
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
                                          color: AppColors.greyColor,
                                          size: 25,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'First Name',
                                      style: Styles.labelTextStyle2(),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      '  Last Name',
                                      style: Styles.labelTextStyle2(),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      autocorrect: false,
                                      controller: firstName,
                                      keyboardType: TextInputType.name,
                                      style: Styles.textInputStyle2(),
                                      decoration: InputDecoration(
                                        hintText: "Enter First Name",
                                        border: Styles.textFieldBorder(),
                                        hintStyle: Styles.hintTextStyle2(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: TextField(
                                      autocorrect: false,
                                      controller: lastName,
                                      keyboardType: TextInputType.name,
                                      style: Styles.textInputStyle2(),
                                      decoration: InputDecoration(
                                        hintText: "Enter Last Name",
                                        border: Styles.textFieldBorder(),
                                        hintStyle: Styles.hintTextStyle2(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Email',
                                style: Styles.labelTextStyle2(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                autocorrect: false,
                                controller: email,
                                keyboardType: TextInputType.emailAddress,
                                style: Styles.textInputStyle2(),
                                decoration: InputDecoration(
                                  hintText: "Enter Email Address",
                                  border: Styles.textFieldBorder(),
                                  hintStyle: Styles.hintTextStyle2(),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              //(Platform.isAndroid)
                              if (plt.Platform.isWindows)
                                Container(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(' Phone Number', style: Styles.labelTextStyle2()),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      InternationalPhoneNumberInput(
                                        controller: phone,
                                        phoneConfig: PhoneConfig(
                                          textStyle: Styles.textInputStyle2(),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: AppColors.resetPasswordInput,
                                            ),
                                          ),
                                          backgroundColor: AppColors.resetPasswordInput,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Container(),
                              Text(
                                'Password',
                                style: Styles.labelTextStyle2(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                autocorrect: false,
                                controller: newPassword,
                                obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                                style: Styles.textInputStyle2(),
                                decoration: InputDecoration(
                                  hintText: "Enter Password",
                                  border: Styles.textFieldBorder(),
                                  hintStyle: Styles.hintTextStyle2(),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Confirm Password',
                                style: Styles.textInputStyle2(),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                autocorrect: false,
                                controller: confirmPassword,
                                obscureText: true,
                                keyboardType: TextInputType.emailAddress,
                                style: Styles.textInputStyle2(),
                                decoration: InputDecoration(
                                  hintText: "Confirm Password",
                                  border: Styles.textFieldBorder(),
                                  hintStyle: Styles.hintTextStyle2(),
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Checkbox(
                                    value: termsAndConditions,
                                    side: Styles.checkBoxBorder(),
                                    onChanged: (value) => acceptTermsAndConditionsChanged(value ?? false),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () async {
                                      InappBrowser.showPopUpBrowser(
                                        context,
                                        Uri.parse(TC),
                                      );
                                    },
                                    child: const Text(
                                      'Agree with Terms & Conditions',
                                      textAlign: TextAlign.center,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 15.0,
                                        color: AppColors.darkOrange,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                children: [
                                  const Spacer(),
                                  Row(
                                    children: [
                                      Text(
                                        'Continue',
                                        style: Styles.semiBoldTextStyleBlack(),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      IconButton(
                                        icon: SvgPicture.asset(
                                          NsvgsAssets.kLoginFab,
                                        ),
                                        iconSize: 45,
                                        onPressed: () {
                                          if (validateInfo(
                                                firstName.text,
                                                lastName.text,
                                                email.text,
                                                phone.text,
                                              ) &&
                                              Provider.of<NewAccountProvider>(context, listen: false)
                                                  .termsAndConditions) {
                                            if (pandora.isValidEmail(email.text)) {
                                              if (validatePasswords(
                                                newPassword.text,
                                                confirmPassword.text,
                                              )) {
                                                if (verifyPasswords(
                                                  newPassword.text,
                                                  confirmPassword.text,
                                                )) {
                                                  createNewUser(
                                                    firstName.text,
                                                    lastName.text,
                                                    email.text,
                                                    phone.value.text,
                                                    newPassword.text,
                                                    context,
                                                  );
                                                } else {
                                                  pandora.showToast(
                                                    Errors.passwordNotMatch,
                                                    context,
                                                    MessageTypes.WARNING.toString().split('.').last,
                                                  );
                                                }
                                              } else {
                                                pandora.showToast(
                                                  Errors.passwordNotEmpty,
                                                  context,
                                                  MessageTypes.WARNING.toString().split('.').last,
                                                );
                                              }
                                            } else {
                                              pandora.showToast(
                                                Errors.invalidEmail,
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
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      desktop: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SizedBox(
          height: height,
          width: width,
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
                              margin: const EdgeInsets.symmetric(horizontal: 25),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
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
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const HeaderText(
                                              text: 'Create New Account',
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
                                          text: 'Create a new account secured with your password',
                                          color: Colors.black,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'First Name',
                                          style: Styles.labelTextStyle2(),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '  Last Name',
                                          style: Styles.labelTextStyle2(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          autocorrect: false,
                                          controller: firstName,
                                          keyboardType: TextInputType.name,
                                          style: Styles.textInputStyle2(),
                                          decoration: InputDecoration(
                                            hintText: "Enter First Name",
                                            border: Styles.textFieldBorder(),
                                            hintStyle: Styles.hintTextStyle2(),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10.0),
                                      Expanded(
                                        child: TextField(
                                          autocorrect: false,
                                          controller: lastName,
                                          keyboardType: TextInputType.name,
                                          style: Styles.textInputStyle2(),
                                          decoration: InputDecoration(
                                            hintText: "Enter Last Name",
                                            border: Styles.textFieldBorder(),
                                            hintStyle: Styles.hintTextStyle2(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Email',
                                    style: Styles.labelTextStyle2(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    autocorrect: false,
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    style: Styles.textInputStyle2(),
                                    decoration: InputDecoration(
                                      hintText: "Enter Email Address",
                                      border: Styles.textFieldBorder(),
                                      hintStyle: Styles.hintTextStyle2(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  if (plt.Platform.isAndroid)
                                    Container(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(' Phone Number', style: Styles.labelTextStyle2()),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          InternationalPhoneNumberInput(
                                            controller: phone,
                                            phoneConfig: PhoneConfig(
                                              textStyle: Styles.textInputStyle2(),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: AppColors.resetPasswordInput,
                                                ),
                                              ),
                                              backgroundColor: AppColors.resetPasswordInput,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    )
                                  else
                                    Container(),
                                  Text(
                                    'Password',
                                    style: Styles.labelTextStyle2(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    autocorrect: false,
                                    controller: newPassword,
                                    obscureText: true,
                                    keyboardType: TextInputType.emailAddress,
                                    style: Styles.textInputStyle2(),
                                    decoration: InputDecoration(
                                      hintText: "Enter Password",
                                      border: Styles.textFieldBorder(),
                                      hintStyle: Styles.hintTextStyle2(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Text(
                                    'Confirm Password',
                                    style: Styles.textInputStyle2(),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  TextField(
                                    autocorrect: false,
                                    controller: confirmPassword,
                                    obscureText: true,
                                    keyboardType: TextInputType.emailAddress,
                                    style: Styles.textInputStyle2(),
                                    decoration: InputDecoration(
                                      hintText: "Confirm Password",
                                      border: Styles.textFieldBorder(),
                                      hintStyle: Styles.hintTextStyle2(),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Checkbox(
                                        value: termsAndConditions,
                                        side: Styles.checkBoxBorder(),
                                        onChanged: (value) => acceptTermsAndConditionsChanged(value ?? false),
                                      ),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () async {
                                          InappBrowser.showPopUpBrowser(
                                            context,
                                            Uri.parse(TC),
                                          );
                                        },
                                        child: const Text(
                                          'Agree with Terms & Conditions',
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: AppColors.darkOrange,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(),
                                      Row(
                                        children: [
                                          Text(
                                            'Continue',
                                            style: Styles.semiBoldTextStyleBlack(),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          IconButton(
                                            icon: SvgPicture.asset(
                                              NsvgsAssets.kLoginFab,
                                            ),
                                            iconSize: 45,
                                            onPressed: () {
                                              if (validateInfo(
                                                    firstName.text,
                                                    lastName.text,
                                                    email.text,
                                                    phone.value.text,
                                                  ) &&
                                                  Provider.of<NewAccountProvider>(context, listen: false)
                                                      .termsAndConditions) {
                                                if (pandora.isValidEmail(email.text)) {
                                                  if (validatePasswords(
                                                    newPassword.text,
                                                    confirmPassword.text,
                                                  )) {
                                                    if (verifyPasswords(
                                                      newPassword.text,
                                                      confirmPassword.text,
                                                    )) {
                                                      createNewUser(
                                                        firstName.text,
                                                        lastName.text,
                                                        email.text,
                                                        phone.value.text,
                                                        newPassword.text,
                                                        context,
                                                      );
                                                    } else {
                                                      pandora.showToast(
                                                        Errors.passwordNotMatch,
                                                        context,
                                                        MessageTypes.WARNING.toString().split('.').last,
                                                      );
                                                    }
                                                  } else {
                                                    pandora.showToast(
                                                      Errors.passwordNotEmpty,
                                                      context,
                                                      MessageTypes.WARNING.toString().split('.').last,
                                                    );
                                                  }
                                                } else {
                                                  pandora.showToast(
                                                    Errors.invalidEmail,
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

  void accountCreated(BuildContext context) {
    const SnackBar(
      content: Text(Success.newAccount),
      backgroundColor: Colors.green,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const VerifyAccountPage(),
      ),
      (route) => false,
    );
  }

  void showNoMailAppsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Open Mail App"),
          content: const Text("No mail apps installed"),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
