import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/crow/models/farm_management/assets/generic_log_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/styles.dart';

class FarmLogsItem extends StatelessWidget {
  final Completed log;
  final FarmManagerSiteManagementArgs siteArgs;

  const FarmLogsItem({Key? key, required this.log, required this.siteArgs}) : super(key: key);

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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      log.name ?? "",
                      maxLines: 1,
                      style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflowMd()),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.inactiveTabTextColor.withOpacity(.2),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: Text(
                        log.type ?? "",
                        maxLines: 1,
                        style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Styles.outlineSun(),
                      const SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        child: Text(
                          log.farmingSeason ?? "",
                          maxLines: 1,
                          style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: (log.flags == "Monitor")
                              ? AppColors.redColor.withOpacity(.2)
                              : AppColors.inactiveTabTextColor.withOpacity(.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Text(
                            log.flags ?? "",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: (log.deleted == "Y")
                              ? AppColors.userProfileBackground.withOpacity(.2)
                              : AppColors.completedColor.withOpacity(.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Text(
                            (log.deleted == "Y") ? "Draft" : "Published",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          "Start",
                          maxLines: 1,
                          style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(EvaIcons.playCircleOutline, color: AppColors.greenColor, size: 13),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Styles.outlineCalender(),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "${log.startDate!.day}-${log.startDate!.month}-${log.startDate!.year}",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Styles.outlineClock(),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "${log.startTime!.hour} : ${log.startTime!.minute}",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          "Stop",
                          maxLines: 1,
                          style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Styles.outlineCirclePlay(),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Styles.outlineCalender(),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "${log.endDate!.day}-${log.endDate!.month}-${log.endDate!.year}",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Styles.outlineClock(),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "${log.endTime!.hour} : ${log.endTime!.minute}",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    decoration: Styles.userProfileBoxDeco(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Text(
                        "View Details",
                        maxLines: 1,
                        style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      onTap: () {
        pandora.reRouteUser(context, '/farmManagerLogsDetails', log);
      },
    );
  }
}
