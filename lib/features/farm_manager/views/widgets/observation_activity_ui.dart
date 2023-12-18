import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ObservationActiviyUI extends StatelessWidget {
  const ObservationActiviyUI({
    super.key,
    required this.logReason,
    required this.logMethod,
  });

  final TextEditingController logReason;
  final TextEditingController logMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          hintText: logReasonText,
          text: logReasonText,
          controller: logReason,
          validator: (arg) {
            if (isEmpty(arg)) {
              return '$logReasonText $cannotBeEmpty';
            } else {
              return null;
            }
          },
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
        const Ymargin(SpacingConstants.double20),
        CustomTextField(
          hintText: approachText,
          text: approachText,
          controller: logMethod,
          validator: (arg) {
            if (isEmpty(arg)) {
              return '$approachText $cannotBeEmpty';
            } else {
              return null;
            }
          },
          maxLines: 3,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
