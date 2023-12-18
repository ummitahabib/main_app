import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/features/widgets/radio_button.dart';
import 'package:smat_crow/features/widgets/upload.dart';
import 'package:smat_crow/features/widgets/upload_file.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../utils2/colors.dart';
import '../../utils2/decoration.dart';
import '../../utils2/spacing_constants.dart';
import 'check_box.dart';
import 'custom_drop_down.dart';
import 'custom_switch_button.dart';
import 'message_field.dart';

class Display extends StatelessWidget {
  const Display({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      body: Padding(
        padding: const EdgeInsets.all(SpacingConstants.size20),
        child: Column(
          children: [
            Row(
              children: [
                Upload(
                  label1: uploadLabel1,
                  label2: uploadLabel2,
                  label3: uploadLabel3,
                  IconColor: AppColors.SmatCrowPrimary500,
                  progressIndicator: DecorationBox.customProgressIndicator(),
                  style: Styles.smatCrowHeadingRegular7(color: AppColors.SmatCrowNeuBlue500),
                ),
                Upload(
                  label1: uploadLabel1,
                  label2: uploadLabel2,
                  label3: uploadLabel4,
                  IconColor: AppColors.SmatCrowPrimary500,
                  style: Styles.smatCrowUnderline(),
                ),
                const UploadFile(
                  label1: uploadFileLabel1,
                  label2: uploadFileLabel2,
                ),
              ],
            ),
            Row(
              children: [
                CustomRadioButton(
                  onChanged: (bool) {},
                ),
                const SizedBox(width: SpacingConstants.size8),
                CustomCheckbox(
                  onChanged: (bool) {},
                ),
                const SizedBox(width: SpacingConstants.size8),
                CustomSwitchButton(
                  onChanged: (bool) {},
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: SpacingConstants.size270,
                  child: CustomTextField(
                    type: TextFieldType.Default,
                    hintText: defaultHint,
                    onChanged: (value) {
                      // Handle default text field value
                    },
                    text: defaultText,
                  ),
                ),
                const SizedBox(width: SpacingConstants.size8),
                SizedBox(
                  width: SpacingConstants.size270,
                  child: CustomTextField(
                    type: TextFieldType.Password,
                    hintText: passwordHint,
                    isRequired: true,
                    onChanged: (value) {
                      // Handle password text field value
                    },
                    text: passwordText,
                  ),
                ),
                const SizedBox(width: SpacingConstants.size8),
                SizedBox(
                  width: SpacingConstants.size270,
                  child: CustomTextField(
                    type: TextFieldType.Email,
                    hintText: emailHint,
                    isRequired: true,
                    onChanged: (value) {
                      // Handle email text field value
                    },
                    text: emailText,
                  ),
                ),
                const SizedBox(width: SpacingConstants.size8),
                SizedBox(
                  width: SpacingConstants.size270,
                  height: SpacingConstants.size48,
                  child: CustomDropdownField<String?>(
                    items: optionList,
                    value: null,
                    hintText: dropDownHint,
                    labelText: dropDownText,
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(
                  width: SpacingConstants.size270,
                  child: Expanded(
                    child: MessageField(
                      messageLabel: messageText,
                      hint: messageHint,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                CustomButton(
                  text: buttonText,
                  onPressed: () {},
                  color: AppColors.SmatCrowPrimary500,
                  borderColor: AppColors.SmatCrowPrimary500,
                ),
                const SizedBox(width: SpacingConstants.size8),
                CustomButton(
                  text: buttonText,
                  onPressed: () {},
                  leftIcon: EvaIcons.activity,
                  color: AppColors.SmatCrowNeuOrange900,
                  borderColor: AppColors.SmatCrowNeuOrange900,
                  iconColor: AppColors.SmatCrowDefaultWhite,
                  textColor: AppColors.SmatCrowDefaultWhite,
                ),
                const SizedBox(width: SpacingConstants.size8),
                CustomButton(
                  text: buttonText,
                  onPressed: () {},
                  rightIcon: EvaIcons.arrowForward,
                  color: Colors.transparent,
                  borderColor: AppColors.SmatCrowPrimary500,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
