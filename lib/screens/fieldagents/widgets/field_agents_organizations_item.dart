import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/styles.dart';

class FieldAgentsOrganizationsItem extends StatelessWidget {
  final String organizationName;
  final DateTime createdDate;
  final String organizationId;

  const FieldAgentsOrganizationsItem(
      {Key? key, required this.organizationName, required this.createdDate, required this.organizationId,})
      : super(key: key);

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
                        Text(organizationName, style: GoogleFonts.poppins(textStyle: Styles.mxTextStyle())),
                        Text(organizationId, style: GoogleFonts.poppins(textStyle: Styles.minTextStyleBold())),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(DateFormat('yyyy-MM-dd').format(createdDate),
                            style: GoogleFonts.poppins(textStyle: Styles.sTextStyleNormalB()),),
                      ],
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

        pandora.reRouteUser(
            context, '/farmManagerOrganizationDetails', FieldAgentOrganizationArgs(organizationId, organizationName),);
      },
    );
  }
}
