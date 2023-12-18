import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ClickableText extends StatelessWidget {
  final String text;
  final Color? color;
  final Function() press;

  const ClickableText({Key? key, required this.text, required this.color, required this.press}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(
          text,
          style: GoogleFonts.nunitoSans(
            textStyle: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
