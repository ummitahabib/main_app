import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SquareButton extends StatelessWidget {
  final String text;
  final Function()? press;
  final Color? backgroundColor, textColor;

  const SquareButton({Key? key, required this.text, this.press, this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: press,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        width: size.width * 0.9,
        decoration: const BoxDecoration(
          // color: backgroundColor,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFE66700),
              Color(0xFFFB9F00),
            ],
          ),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
