import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../utils/styles.dart';

class EmptyListItem extends StatelessWidget {
  final String message;

  const EmptyListItem({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.dashBackground,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(message, style: GoogleFonts.nunitoSans(textStyle: Styles.textStyleMdw600())),
            ),
          ],
        ),
      ),
    );
  }
}
