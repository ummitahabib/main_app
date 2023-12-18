import 'package:flutter/material.dart';

import '../../../utils/strings.dart';
import '../../../utils/styles.dart';

class CustomButton extends StatelessWidget {
  final Color? color;
  final Function() onTap;

  const CustomButton({super.key, this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          highlightColor: Colors.transparent,
          onTap: onTap,
          child: Center(
            child: Text(
              createTask,
              style: Styles.normalTextLargeWhite(),
            ),
          ),
        ),
      ),
    );
  }
}
