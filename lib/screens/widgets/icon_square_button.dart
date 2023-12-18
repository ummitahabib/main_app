import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconSquareButton extends StatelessWidget {
  final String text;
  final Function()? press;
  final Color? backgroundColor, textColor;
  final IconData? icon;

  const IconSquareButton({Key? key, required this.text, this.press, this.backgroundColor, this.textColor, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        decoration: BoxDecoration(color: backgroundColor, borderRadius: const BorderRadius.all(Radius.circular(50))),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 13),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  icon,
                  color: textColor,
                  size: 14,
                ),
                const SizedBox(
                  width: 8,
                ),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: textColor,
                      fontSize: 13,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
