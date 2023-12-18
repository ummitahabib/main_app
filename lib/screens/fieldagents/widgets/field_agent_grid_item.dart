import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/styles.dart';

class FieldAgentGridItem extends StatelessWidget {
  final String text, image, route;
  final Color background;

  const FieldAgentGridItem({
    Key? key,
    required this.text,
    required this.background,
    required this.image,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return Card(
      color: background,
      elevation: 0.1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
          pandora.logAPPButtonClicksEvent(
              'FIELD_AGENT_ITEM_${route.replaceAll('/', '').toUpperCase()}_CLICKED');
          if (route == "/soilSampling") {
            pandora.reRouteUser(context, '/soilSampling',
                CreateSoilSamplesArgs(false, '', '', USER_ID));
          } else {
            pandora.reRouteUser(context, route, 'null');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset(
                    image,
                    color: AppColors.fieldAgentText,
                    width: 25.0,
                    height: 25.0,
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text,
                      overflow: TextOverflow.fade,
                      style:
                          GoogleFonts.poppins(textStyle: Styles.bldTextStyle()))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
