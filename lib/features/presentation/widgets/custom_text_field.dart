import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

enum TextFieldType { Default, Email, Password }

class CustomTextField extends StatefulWidget {
  final TextFieldType type;
  final String hintText;
  final bool isRequired;
  final String? text;
  final double? width;
  final TextEditingController? textEditingController;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final int? maxLines;
  final Function()? onPressEnter;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.type,
    required this.hintText,
    this.isRequired = false,
    this.text,
    this.textEditingController,
    this.maxLines,
    this.width,
    this.validator,
    this.onPressEnter,
    this.prefixIcon,
    this.enabled = true,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late String hintText;
  final bool _isValid = true;
  bool _obscured = true;
  final bool _userFinishedTyping = false;
  final textFieldFocusNode = FocusNode();

  @override
  void dispose() {
    textFieldFocusNode.dispose();
    super.dispose();
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  Icon? getSuffixIcon() {
    if (_userFinishedTyping) {
      return _isValid ? DecorationBox.validIcon() : const Icon(Icons.cancel, color: AppColors.SmatCrowRed500);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        widget.width ?? maxWidth;

        Widget? suffixIcon;
        if (widget.type == TextFieldType.Password) {
          suffixIcon = SpacingConstants.iconPadding(
            child: GestureDetector(
              onTap: _toggleObscured,
              child: _obscured ? DecorationBox.passwordIconOn() : DecorationBox.passwordIconOff(),
            ),
          );
        } else if (widget.type == TextFieldType.Email) {
          suffixIcon = getSuffixIcon();
        }

        return SizedBox(
          width: widget.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.text ?? emptyString,
                style: Styles.smatCrowMediumSubParagraph(
                  color: AppColors.SmatCrowNeuBlue900,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: SpacingConstants.size8,
              ),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                validator: widget.validator,
                focusNode: textFieldFocusNode,
                controller: widget.textEditingController,
                obscureText: widget.type == TextFieldType.Password && _obscured,
                onEditingComplete: widget.onPressEnter,
                enabled: widget.enabled,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: Styles.smatCrowSubParagraphRegular(
                    color: AppColors.SmatCrowNeuBlue400,
                  ),
                  prefixIcon: widget.prefixIcon,
                  suffixIcon: suffixIcon,
                  filled: true,
                  errorBorder: DecorationBox.customOutlineBorderSideAndRadius(),
                  fillColor: AppColors.SmatCrowNeuBlue50,
                  enabledBorder: DecorationBox.customOutlineBorderSideAndRadius(),
                  focusedBorder: DecorationBox.customOutlineBorder(
                    color: AppColors.SmatCrowPrimary500,
                    width: SpacingConstants.size1point5,
                  ),
                ),
                cursorColor: AppColors.SmatCrowPrimary500,
              ),
              const SizedBox(
                height: SpacingConstants.size15,
              ),
            ],
          ),
        );
      },
    );
  }
}
