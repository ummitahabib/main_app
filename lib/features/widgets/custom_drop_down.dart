import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/icons.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final List<T?> items;
  final T value;
  final String hintText;
  final String? labelText;
  final void Function(T?) onChanged;
  final BoxDecoration? decoration;
  final double? height;
  final TextStyle? hintStyle;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;

  const CustomDropdownField({
    Key? key,
    required this.items,
    required this.value,
    required this.hintText,
    this.labelText,
    required this.onChanged,
    this.decoration,
    this.height,
    this.hintStyle,
    this.valueStyle,
    this.labelStyle,
  }) : super(key: key);

  @override
  _CustomDropdownFieldState<T> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  T? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null)
          Text(
            widget.labelText!,
            style: widget.labelStyle ??
                Styles.smatCrowMediumSubParagraph(color: AppColors.SmatCrowNeuBlue900)
                    .copyWith(fontWeight: FontWeight.bold),
          ),
        if (widget.labelText != null) const SizedBox(height: SpacingConstants.font10),
        Container(
          height: widget.height ?? 44,
          decoration: widget.decoration ??
              BoxDecoration(
                color: AppColors.SmatCrowNeuBlue50,
                borderRadius: BorderRadius.circular(SpacingConstants.size8),
                border: Border.all(color: AppColors.SmatCrowNeuBlue200),
              ),
          child: DropdownButton<T?>(
            value: _value,
            hint: Text(
              widget.hintText,
              style: widget.hintStyle,
            ),
            borderRadius: BorderRadius.circular(10),
            elevation: 0,
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() {
                  _value = newValue;
                  widget.onChanged(newValue);
                });
              }
            },
            items: [
              ...widget.items.map<DropdownMenuItem<T?>>((T? item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    item.toString(),
                    style: widget.valueStyle,
                  ),
                );
              }),
            ],
            padding: const EdgeInsets.symmetric(horizontal: 10),
            isExpanded: true,
            underline: const SizedBox(),
            icon: const Icon(AppIcons.downIcon),
          ),
        ),
      ],
    );
  }
}
