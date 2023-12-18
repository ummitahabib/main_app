import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/styles.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String desc;

  const TaskCardWidget({super.key, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 15,
        horizontal: 14,
      ),
      margin: const EdgeInsets.only(
        bottom: 20.0,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              textStyle: Styles.boldTextLrg(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 4.0,
            ),
            child: Text(
              desc,
              style: GoogleFonts.poppins(
                textStyle: Styles.extraText(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
