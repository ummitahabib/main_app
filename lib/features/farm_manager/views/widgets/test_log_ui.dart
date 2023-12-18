import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class TestLogUI extends StatelessWidget {
  const TestLogUI({
    super.key,
    required this.logTestType,
    required this.logLab,
  });

  final TextEditingController logTestType;
  final TextEditingController logLab;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            hintText: testTypeText,
            text: testTypeText,
            controller: logTestType,
            validator: (arg) {
              if (isEmpty(arg)) {
                return '$testTypeText $cannotBeEmpty';
              } else {
                return null;
              }
            },
          ),
        ),
        const Xmargin(SpacingConstants.font10),
        Expanded(
          child: CustomTextField(
            hintText: laboratoryText,
            text: laboratoryText,
            controller: logLab,
            validator: (arg) {
              if (isEmpty(arg)) {
                return '$laboratoryText $cannotBeEmpty';
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.name,
          ),
        ),
      ],
    );
  }
}
