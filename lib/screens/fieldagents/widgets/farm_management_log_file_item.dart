import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../utils/assets/svgs_assets.dart';

import '../../../utils/styles.dart';

class FarmManagementLogFileItem extends StatelessWidget {
  final String url;
  final intCount;
  final Pandora pandora;

  const FarmManagementLogFileItem({Key? key, required this.url, this.intCount, required this.pandora})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: SvgPicture.asset(
              SvgsAssets.kLogFiles,
              width: 70.0,
              height: 70.0,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Text("Uploaded File $intCount", maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.textGreyMd()))
        ],
      ),
      onTap: () {
        pandora.downloadFile(url, "Uploaded Log File $intCount");
      },
    );
  }
}
