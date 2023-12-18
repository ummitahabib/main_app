import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inapp_browser/inapp_browser.dart';

import '../../../utils/styles.dart';

class FarmManagementLogMediaItem extends StatelessWidget {
  final String url;
  final intCount;

  const FarmManagementLogMediaItem({Key? key, required this.url, this.intCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.network(
              url,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text("Uploaded Media $intCount", maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.textGreyMd()))
        ],
      ),
      onTap: () {
        InappBrowser.showPopUpBrowser(
          context,
          Uri.parse(url),
        );
      },
    );
  }
}
