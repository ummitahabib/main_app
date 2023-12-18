import 'package:flutter/material.dart';

import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/icons.dart';

class CustomDropdownField<T> extends StatefulWidget {
  final List<T> items;
  final T value;
  final String hintText;
  final String labelText;
  final void Function(T) onChanged;

  const CustomDropdownField({
    Key? key,
    required this.items,
    required this.value,
    required this.hintText,
    required this.labelText,
    required this.onChanged,
  }) : super(key: key);

  @override
  _CustomDropdownFieldState<T> createState() => _CustomDropdownFieldState<T>();
}

class _CustomDropdownFieldState<T> extends State<CustomDropdownField<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration:
          DecorationBox.dropDownInputDecoration(hintText: widget.hintText),
      child: DropdownButton<T>(
        value: _value,
        onChanged: (newValue) {
          setState(() {
            _value = newValue as T;
            widget.onChanged(newValue);
          });
        },
        items: [
          DropdownMenuItem<T>(
            child: Text(widget.hintText),
          ),
          ...widget.items.map<DropdownMenuItem<T>>((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(item.toString()),
            );
          }),
        ],
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(AppIcons.downIcon),
      ),
    );
  }
}
