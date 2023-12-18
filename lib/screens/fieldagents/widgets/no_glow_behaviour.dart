import 'package:flutter/material.dart';

class NoGlowBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails axisDirection,
  ) {
    return child;
  }
}
