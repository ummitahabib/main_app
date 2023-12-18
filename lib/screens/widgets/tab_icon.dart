import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BottomTabIcon extends StatelessWidget {
  final String icon;

  const BottomTabIcon({Key? key, required this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: SvgPicture.asset(
        icon,
      ),
    );
  }
}
