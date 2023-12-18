import 'package:flutter/material.dart';

class Ymargin extends StatelessWidget {
  const Ymargin(
    this.height, {
    super.key,
  });
  final double height;
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class Xmargin extends StatelessWidget {
  const Xmargin(
    this.width, {
    super.key,
  });
  final double width;
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}
