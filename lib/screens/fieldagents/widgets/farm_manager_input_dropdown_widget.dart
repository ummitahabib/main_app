import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../../../pandora/pandora.dart';
import '../../../utils/styles.dart';

class FarmManagerInputDropdownWidget extends StatelessWidget {
  final Widget dialogWidget;
  final String dialogTitle;
  final String? inputTitle;
  final void Function(String?)? inputValue;
  final TextEditingController? dialogTextController;

  const FarmManagerInputDropdownWidget({
    Key? key,
    required this.dialogWidget,
    required this.dialogTitle,
    this.dialogTextController,
    this.inputTitle,
    this.inputValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        displayModalWithChild(dialogWidget, dialogTitle, context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: dialogTextController,
          keyboardType: TextInputType.name,
          style: Styles.inputStyle(),
          decoration: InputDecoration(
            label: Text(inputTitle ?? ''),
            errorBorder: Styles.errorBorder(),
            focusedBorder: Styles.focusBorder(),
            border: Styles.border(),
          ),
          validator: (arg) {
            if (isEmpty(arg)) {
              return '$inputTitle cannot be empty';
            } else {
              return null;
            }
          },
          onSaved: inputValue,
        ),
      ),
    );
  }
}
