import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../../utils2/decoration.dart';

class MessageField extends StatelessWidget {
  final String messageLabel;
  final String hint;
  const MessageField({
    Key? key,
    required this.messageLabel,
    required this.hint,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(messageLabel),
        const SizedBox(
          height: SpacingConstants.size8,
        ),
        TextField(
          maxLines: SpacingConstants.int7,
          decoration: InputDecoration(
            focusedBorder: DecorationBox.customOutlineBorder3(),
            enabledBorder: DecorationBox.customOutlineBorder4(),
            hintText: hint,
          ),
        ),
      ],
    );
  }
}
