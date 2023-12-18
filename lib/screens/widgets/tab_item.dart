import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/styles.dart';

class BottomTabText extends StatelessWidget {
  final String text;

  const BottomTabText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: GoogleFonts.nunitoSans(textStyle: Styles.textStyleMdw600()));
  }
}
