import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils/colors.dart';

class TextInputContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;

  const TextInputContainer({Key? key, this.child, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      height: 45,
      width: size.width * 0.9,
      decoration:
          BoxDecoration(color: (color == null) ? AppColors.whiteSmoke : color, borderRadius: BorderRadius.circular(5)),
      child: child,
    );
  }
}
