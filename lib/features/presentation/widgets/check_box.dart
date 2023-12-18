// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CustomCheckbox extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;

  const CustomCheckbox({
    Key? key,
    this.value = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _setValue(bool newValue) {
    setState(() {
      _value = newValue;
      widget.onChanged(newValue);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _setValue(!_value),
      child: AnimatedContainer(
        duration: DecorationBox.switchDuration(),
        width: SpacingConstants.size16,
        height: SpacingConstants.size16,
        decoration: DecorationBox.checkBoxDecoration(
          color: _value ? AppColors.SmatCrowBlue500 : Colors.transparent,
          borderColor: _value == false ? AppColors.SmatCrowNeuBlue200 : AppColors.SmatCrowBlue500,
        ),
        child: _value ? DecorationBox.checkBoxIcon() : null,
      ),
    );
  }
}
