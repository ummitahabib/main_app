import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/styles.dart';

class FarmManagementLogOwnersItem extends StatelessWidget {
  final Log owner;

  const FarmManagementLogOwnersItem({
    Key? key,
    required this.owner,
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
                          Styles.outlinePersonDone(),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "Name",
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
                        child: Text("${owner.ownerName}", style: Styles.textGreyMd()),
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
                          const Icon(EvaIcons.awardOutline, size: 13),
                          const SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Text(
                              "Role",
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
                        child: Text("${owner.ownerRole}", style: Styles.textGreyMd()),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {},
    );
  }
}
