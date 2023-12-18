import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/styles.dart';

class TextInputContainer extends StatelessWidget {
  final Widget child;

  const TextInputContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      width: size.width * 0.9,
      decoration: Styles.boxDecoWithBgGrey(),
      child: child,
    );
  }
}
