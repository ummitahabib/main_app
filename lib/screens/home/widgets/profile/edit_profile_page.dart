import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smat_crow/network/crow/models/request/update_profile.dart';
import 'package:smat_crow/network/crow/user_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/header_text.dart';
import 'package:smat_crow/screens/widgets/text_field.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/strings.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final Pandora pandora = Pandora();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (userData != null) {
      setState(() {
        firstName.text = userData!.firstName!;
        lastName.text = userData!.lastName!;
        email.text = userData!.email!;
        phoneNumber.text = userData!.phone!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        title: const HeaderText(
          text: 'Personal Profile',
          color: Colors.black,
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace_rounded,
            color: AppColors.fieldAgentText,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                'First Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'regular',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputContainer(
                color: AppColors.resetPasswordInput,
                child: TextField(
                  autocorrect: false,
                  controller: firstName,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: AppColors.resetPasswordGrey,
                    fontSize: 15.0,
                    fontFamily: 'regular',
                    backgroundColor: AppColors.resetPasswordInput,
                  ),
                  decoration: const InputDecoration(
                    hintText: "Last Name",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 15.0, color: AppColors.resetPasswordGrey, fontFamily: 'regular'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Last Name',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'regular',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputContainer(
                color: AppColors.resetPasswordInput,
                child: TextField(
                  autocorrect: false,
                  controller: lastName,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: AppColors.resetPasswordGrey,
                    fontSize: 15.0,
                    fontFamily: 'regular',
                  ),
                  decoration: const InputDecoration(
                    hintText: "Last Name",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 15.0, color: AppColors.resetPasswordGrey, fontFamily: 'regular'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Email',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'regular',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputContainer(
                color: AppColors.resetPasswordInput,
                child: TextField(
                  autocorrect: false,
                  controller: email,
                  enabled: false,
                  //Not clickable and not editable
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: AppColors.resetPasswordGrey,
                    fontSize: 15.0,
                    fontFamily: 'regular',
                  ),
                  decoration: const InputDecoration(
                    hintText: "Email",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 15.0, color: AppColors.resetPasswordGrey, fontFamily: 'regular'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Phone Number',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'regular',
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextInputContainer(
                color: AppColors.resetPasswordInput,
                child: TextField(
                  autocorrect: false,
                  controller: phoneNumber,
                  enabled: false,
                  //Not clickable and not editable
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: AppColors.resetPasswordGrey,
                    fontSize: 15.0,
                    fontFamily: 'regular',
                  ),
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 15.0, color: AppColors.resetPasswordGrey, fontFamily: 'regular'),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      const Text(
                        'Update',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                          fontFamily: 'semibold',
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      IconButton(
                        icon: SvgPicture.asset(
                          'assets/nsvgs/welcome/login_fab.svg',
                        ),
                        iconSize: 45,
                        onPressed: () {
                          if (validatePasswords(firstName.text, lastName.text)) {
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
    );
  }

  bool validatePasswords(String newPassword, String confirmPassword) {
    return (newPassword.isEmpty || confirmPassword.isEmpty) ? false : true;
  }

  final Pandora _pandora = Pandora();

  Future<void> updateProfile() async {
    final updateProfile = await updateUserProfile(
      UpdateProfileRequest(
        firstName: firstName.text,
        lastName: lastName.text,
        email: email.text,
        phone: phoneNumber.text,
      ),
      USER_ID,
    );
    if (!updateProfile) {
      _pandora.showToast('Failed to update profile', context, MessageTypes.FAILED.toString().split('.').last);
    }
  }
}
