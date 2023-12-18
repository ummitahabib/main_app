import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/data/data_sources/api_data_sources.dart';
import 'package:smat_crow/features/presentation/widgets/custom_button.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/app_helper.dart';

import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ChangePasswordPage extends StatefulHookConsumerWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<ChangePasswordPage> {
  TextEditingController oldPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController confirmPass = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    /// final userProvider = ref.watch(userStateProvider);
    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      appBar: AppBar(
        backgroundColor: AppColors.SmatCrowDefaultWhite,
        title: const Text(editPassword),
        leading: GestureDetector(
          onTap: () {
            if (kIsWeb) {
              context.beamToReplacementNamed(ConfigRoute.mainPage);
            } else {
              Navigator.pop(context);
            }
          },
          child: const Icon(
            Icons.arrow_back_ios,
            size: SpacingConstants.size16,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingConstants.size20,
            vertical: SpacingConstants.size10,
          ),
          child: Column(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SpacingConstants.size50),
                  child: SvgPicture.asset("assets2/svg/Clip path group.svg"),
                ),
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomTextField(
                hintText: yourPswd,
                text: "Old Password",
                textEditingController: oldPass,
                type: TextFieldType.Password,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$lastName $cannotBeEmpty';
                  } else {
                    return null;
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomTextField(
                hintText: yourPswd,
                text: "New Password",
                textEditingController: newPass,
                type: TextFieldType.Password,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$phoneNumberText $cannotBeEmpty';
                  } else if (!ApplicationHelpers().isValidPassword(arg!)) {
                    return invalidPassword;
                  } else {
                    return null;
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomTextField(
                hintText: yourPswd,
                text: "Confirm Password",
                textEditingController: confirmPass,
                type: TextFieldType.Password,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$phoneNumberText $cannotBeEmpty';
                  } else if (arg != newPass.text) {
                    return 'Password does not match';
                  } else if (!ApplicationHelpers().isValidPassword(arg!)) {
                    return invalidPassword;
                  } else {
                    return null;
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size15),
              CustomButton(
                borderColor: AppColors.SmatCrowPrimary500,
                color: AppColors.SmatCrowPrimary500,
                text: saveChangesText,
                textColor: AppColors.SmatCrowNeuBlue900,
                isLoading: ref.watch(authenticationProvider).loading,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    ref.read(authenticationProvider).updatePassword(oldPass.text.trim(), newPass.text.trim());
                  }
                },
              ),
              customSizedBoxHeight(SpacingConstants.size10),
            ],
          ),
        ),
      ),
    );
  }
}
