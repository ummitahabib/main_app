import 'package:flutter/material.dart';

class SubHeaderText extends StatelessWidget {
  final String text;
  final Color? color;

  const SubHeaderText({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: color, fontSize: 15.0, fontWeight: FontWeight.w400, fontFamily: 'regular'),
    );
  }
}
