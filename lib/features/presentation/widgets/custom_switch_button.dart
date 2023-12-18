import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

import 'package:smat_crow/utils2/colors.dart';

class CustomSwitchButton extends StatefulWidget {
  final bool initialValue;
  final Function(bool) onChanged;

  const CustomSwitchButton({
    Key? key,
    this.initialValue = false,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomSwitchButtonState createState() => _CustomSwitchButtonState();
}

class _CustomSwitchButtonState extends State<CustomSwitchButton> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _toggleValue() {
    setState(() {
      _value = !_value;
      widget.onChanged(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleValue,
      child: AnimatedContainer(
        duration: DecorationBox.switchDuration(),
        width: SpacingConstants.size32,
        height: SpacingConstants.size20,
        decoration: DecorationBox.switchDecoration(
          color: _value
              ? AppColors.SmatCrowGreen500
              : AppColors.SmatCrowNeuBlue200,
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: DecorationBox.switchDuration(),
              alignment: _value ? Alignment.centerRight : Alignment.centerLeft,
              child: SpacingConstants.switchPadding(
                child: SpacingConstants.switchPaddingChild(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
