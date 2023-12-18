import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import '../../utils2/decoration.dart';

class CustomRadioButton extends StatefulWidget {
  final bool value;
  final Function(bool) onChanged;

  const CustomRadioButton({
    Key? key,
    this.value = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomRadioButtonState createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  bool _value = false;

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
        height: SpacingConstants.size20,
        decoration: DecorationBox.radioDecoration(
          color: _value ? Colors.transparent : AppColors.SmatCrowDefaultWhite,
          borderColor: _value == false ? AppColors.SmatCrowNeuBlue200 : AppColors.SmatCrowBlue500,
        ),
        child: _value
            ? Center(
                child: SpacingConstants.radioContainer(),
              )
            : null,
      ),
    );
  }
}
