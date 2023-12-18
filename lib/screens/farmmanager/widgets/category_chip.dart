import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final IconData iconData;
  final String title;
  final Function() press;
  final Color background;

  const CategoryChip(this.iconData, this.title, this.press, this.background, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Chip(
        label: Row(
          children: <Widget>[
            Icon(iconData, size: 16),
            const SizedBox(width: 8),
            Text(title)
          ],
        ),
        backgroundColor: background,
      ),
    );
  }
}
