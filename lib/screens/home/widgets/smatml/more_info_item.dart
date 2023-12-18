import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:inapp_browser/inapp_browser.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

class MoreInfoItem extends StatelessWidget {
  final String? link, name;

  const MoreInfoItem({Key? key, required this.link, this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      onTap: () {
        pandora.logAPPButtonClicksEvent(
            'DISEASE_DETECTION_MORE_INFO_ITEM_CLCIKED');
        InappBrowser.showPopUpBrowser(
          context,
          Uri.parse(link ?? ''),
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Card(
          elevation: 0,
          color: AppColors.dashCardGrey.withOpacity(0.14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? 'Unknown',
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        color: AppColors.fieldAgentText,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  link ?? 'Unknown',
                  style: GoogleFonts.quicksand(
                    textStyle: const TextStyle(
                        color: AppColors.fieldAgentText,
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
