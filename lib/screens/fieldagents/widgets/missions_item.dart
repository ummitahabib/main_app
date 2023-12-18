import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/circle_painter.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/strings.dart';
import '../../../utils/styles.dart';

class MissionsItem extends StatelessWidget {
  final String missionTitle;
  final DateTime assignedDate;
  final requestedDate;
  final String missionStatus, siteId, missionId;

  const MissionsItem({
    Key? key,
    required this.missionTitle,
    required this.assignedDate,
    required this.missionStatus,
    this.requestedDate,
    required this.siteId,
    required this.missionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      child: Card(
        color: AppColors.whiteColor,
        elevation: 0.1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(missionTitle, style: GoogleFonts.poppins(textStyle: Styles.mxTextStyle())),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          DateFormat(dateFormat).format(assignedDate),
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColors.fieldAgentText,
                              fontSize: 13.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        children: [
                          Text(
                            missionStatus,
                            style: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: (missionStatus == completed) ? AppColors.completedColor : AppColors.redColor,
                                fontSize: 10.0,
                              ),
                            ),
                          ),
                          if (missionStatus == completed)
                            CustomPaint(
                              painter: OpenPainter(AppColors.completedColor),
                            )
                          else
                            CustomPaint(
                              painter: OpenPainter(AppColors.redColor),
                            ),
                          const SizedBox(
                            width: 15,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        pandora.logAPPButtonClicksEvent('FIELD_AGENT_START_MISSION_CLICKED');

        pandora.reRouteUser(context, '/soilSampling', CreateSoilSamplesArgs(true, siteId, missionId, USER_ID));
      },
    );
  }
}
