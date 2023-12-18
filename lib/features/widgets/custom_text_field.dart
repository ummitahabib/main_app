import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../utils2/decoration.dart';
import '../../utils2/spacing_constants.dart';

enum TextFieldType { Default, Email, Password }

class CustomTextField extends StatefulWidget {
  final TextFieldType? type;
  final String hintText;
  final bool isRequired;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final String? Function(String?)? validator;
  final String text;
  final double? width;
  final double? height;
  final int? maxLines;
  final TextStyle? labelStyle;
  final String? initialValue;
  final VoidCallback? onTap;
  final bool? enabled;
  final TextInputType? keyboardType;
  final TextCapitalization? textCapitalization;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final TextInputAction? textInputAction;

  const CustomTextField({
    Key? key,
    this.type = TextFieldType.Default,
    required this.hintText,
    this.isRequired = false,
    this.onChanged,
    this.onSubmitted,
    required this.text,
    this.validator,
    this.width,
    this.height,
    this.maxLines,
    this.labelStyle,
    this.initialValue,
    this.onTap,
    this.keyboardType,
    this.textCapitalization,
    this.enabled,
    this.suffixIcon,
    this.prefixIcon,
    this.inputFormatters,
    this.controller,
    this.textInputAction,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  Pandora pandora = Pandora();
  String hintText = emptyString;
  bool _obscured = true;
  final textFieldFocusNode = FocusNode();
  String? _errorText;

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
      if (textFieldFocusNode.hasPrimaryFocus) return;
      textFieldFocusNode.canRequestFocus = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isValid = _errorText == null;
    Widget? suffixIcon;
    if (widget.type == TextFieldType.Password) {
      suffixIcon = SpacingConstants.iconPadding(
        child: GestureDetector(
          onTap: _toggleObscured,
          child: DecorationBox.passwordIcon(),
        ),
      );
    }
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.text.isNotEmpty)
            Text(
              widget.text,
              style: widget.labelStyle ??
                  Styles.smatCrowMediumSubParagraph(
                    color: AppColors.SmatCrowNeuBlue900,
                  ).copyWith(fontWeight: FontWeight.bold),
            ),
          if (widget.text.isNotEmpty)
            const SizedBox(
              height: SpacingConstants.size10,
            ),
          TextFormField(
            focusNode: textFieldFocusNode,
            controller: widget.controller,
            onChanged: (text) {
              if (widget.onChanged != null) {
                setState(() {
                  _errorText = null;
                });
                widget.onChanged!(text);
              }
            },
            validator: (value) {
              if (widget.validator != null) {
                final error = widget.validator!(value);
                setState(() {
                  _errorText = error;
                });
                return error;
              }
              return null;
            },
            onFieldSubmitted: widget.onSubmitted,
            initialValue: widget.initialValue,
            maxLines: widget.maxLines ?? 1,
            onTap: widget.onTap,
            obscureText: widget.type == TextFieldType.Password && _obscured,
            textInputAction: widget.textInputAction ?? TextInputAction.next,
            textCapitalization: widget.textCapitalization ?? TextCapitalization.sentences,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            inputFormatters: widget.inputFormatters ?? [],
            enabled: widget.enabled ?? true,
            decoration: InputDecoration(
              errorText: _errorText,
              hintText: isValid ? widget.hintText : null,
              hintStyle: Styles.smatCrowSubParagraphRegular(
                color: AppColors.SmatCrowNeuBlue400,
              ),
              suffixIcon: isValid ? suffixIcon : null,
              prefixIcon: widget.prefixIcon,
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              fillColor: AppColors.SmatCrowNeuBlue50,
              enabledBorder: _errorText == null ? DecorationBox.customOutlineBorder4() : InputBorder.none,
              focusedBorder: _errorText == null
                  ? DecorationBox.customOutlineBorder(
                      color: AppColors.SmatCrowPrimary500,
                      width: SpacingConstants.size1point5,
                    )
                  : InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
