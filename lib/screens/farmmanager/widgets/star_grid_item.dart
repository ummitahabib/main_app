import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/request_soil_mission_body.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/assets/images.dart';
import '../../../utils/styles.dart';
import 'circle_painter.dart';

class StarGridItem extends StatelessWidget {
  const StarGridItem({
    Key? key,
    required this.inProgress,
    required this.name,
    required this.missionId,
    required this.description,
    required this.isDummy,
    required this.siteId,
    required this.organizationId,
    this.getSelectedId,
  }) : super(key: key);

  final String inProgress, missionId, name, description, siteId, organizationId;

  final getSelectedId;
  final bool isDummy;

  @override
  Widget build(BuildContext context) {
    bool isTapped = false;
    final Pandora pandora = Pandora();
    return isDummy
        ? InkWell(
            onTap: () {
              pandora.logAPPButtonClicksEvent('REQUEST_STAR_ITEM_CLICKED');

              pandora.loadDialogs(
                  'Request Soil Test',
                  RequestSoilMissionBody(
                    siteId: siteId,
                    organizationId: organizationId,
                  ),
                  600,);
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Styles.dAddIconWhite(),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              pandora.logAPPButtonClicksEvent('STAR_ITEM_CLICKED');

              isTapped = true;
              getSelectedId(missionId, isTapped);
            },
            child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: ExactAssetImage(ImagesAssets.kSoilTest),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.transperant,
                              AppColors.darkColor.withOpacity(0.6),
                            ],
                            stops: const [0.7, 2.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: Row(
                              children: [
                                if (inProgress == "Completed") Text(inProgress,
                                        maxLines: 3, style: GoogleFonts.poppins(textStyle: Styles.completedStyles()),) else Text(inProgress,
                                        maxLines: 3, style: GoogleFonts.poppins(textStyle: Styles.redColorText()),),
                                if (inProgress == "Completed") CustomPaint(
                                        painter: OpenPainter(AppColors.completedColor),
                                      ) else CustomPaint(
                                        painter: OpenPainter(AppColors.redColor),
                                      ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(name,
                                maxLines: 3, style: GoogleFonts.poppins(textStyle: Styles.normalTextWhite()),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),),
          );
  }
}
