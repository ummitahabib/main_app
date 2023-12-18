import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/styles.dart';

class FarmManagementLogRemarksItem extends StatelessWidget {
  final Log remark;

  const FarmManagementLogRemarksItem({
    Key? key,
    required this.remark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Card(
        color: AppColors.farmManagerBackground,
        elevation: 0.1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Styles.outlineEditIcon(),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "Remark",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 19,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("${remark.remark}", style: Styles.textGreyMd()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Styles.outlineActivityIcon(),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "Next Steps",
                              maxLines: 1,
                              style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: 19,
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("${remark.nextAction}", style: Styles.textGreyMd()),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Styles.outlineCalender(),
                  const SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                      "${remark.createdDate!.day}-${remark.createdDate!.month}-${remark.createdDate!.year}",
                      maxLines: 1,
                      style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
