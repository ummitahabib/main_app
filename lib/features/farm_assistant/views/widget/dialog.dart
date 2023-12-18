import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_assistant/views/widget/custom_send_button.dart';
import 'package:smat_crow/main.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../../presentation/widgets/custom_text_field.dart';

Future<dynamic> previewTextDialog({
  required TextEditingController controller,
  required Function() onTapSend,
}) {
  return showDialog(
    barrierDismissible: false,
    context: kIsWeb ? myGlobalKey.currentContext! : navigatorKey.currentContext!,
    builder: (context) {
      return PreviewTextDialog(
        controller: controller,
        onTapSend: onTapSend,
      );
    },
  );
}

class PreviewTextDialog extends StatelessWidget {
  const PreviewTextDialog({
    required this.controller,
    required this.onTapSend,
    super.key,
  });

  final TextEditingController controller;
  final Function() onTapSend;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: SpacingConstants.size400,
          height: SpacingConstants.size400,
          margin: const EdgeInsets.symmetric(horizontal: SpacingConstants.size10),
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingConstants.size12,
            vertical: SpacingConstants.size10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(SpacingConstants.size15),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Text(
                confirmText,
                style: Styles.smatCrowCaptionRegular(
                  color: AppColors.SmatCrowNeuBlue900,
                ).copyWith(
                  height: SpacingConstants.double1Point9,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      text: "",
                      textEditingController: controller,
                      hintText: "",
                      type: TextFieldType.Default,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: SpacingConstants.size24),
                child: CustomSendButton(
                  buttonSize: const Size(SpacingConstants.size200, SpacingConstants.size50),
                  buttonText: "Continue",
                  onTapSend: () {
                    Navigator.pop(context);
                    onTapSend();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
