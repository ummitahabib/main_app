import 'package:flutter/material.dart';

class HeaderText extends StatelessWidget {
  final String text;
  final Color? color;

  const HeaderText({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 23.0, fontWeight: FontWeight.w700, fontFamily: 'regular'),
    );
  }
}
