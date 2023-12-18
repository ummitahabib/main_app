import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/styles.dart';

class FieldAgentStatisticsGridItem extends StatelessWidget {
  final String text;
  final int count;
  final Color background;

  const FieldAgentStatisticsGridItem({
    Key? key,
    required this.text,
    required this.count,
    required this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: background,
      elevation: 0.1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      child: InkWell(
        onTap: () {
/*          pandora.logAPPButtonClicksEvent(
              'FIELD_AGENT_ITEM_${route.replaceAll('/', emptyString).toUpperCase()}_CLICKED');
          if (route == "/soilSampling") {
            pandora.reRouteUser(context, '/soilSampling',
                CreateSoilSamplesArgs(false, emptyString, emptyString, USER_ID));
          } else {
            pandora.reRouteUser(context, route, 'null');
          }*/
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      (count > 1000) ? "${count.toString()[0]}K+" : count.toString(),
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.poppins(
                        textStyle: Styles.boldLgTextStyle(),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      text,
                      overflow: TextOverflow.visible,
                      style: GoogleFonts.poppins(textStyle: Styles.bldTextStyle()),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
