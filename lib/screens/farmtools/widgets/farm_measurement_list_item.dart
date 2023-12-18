import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/styles.dart';

class FarmMeasurementListItem extends StatelessWidget {
  final String text, image, route;
  final Color background;

  const FarmMeasurementListItem({
    Key? key,
    required this.text,
    required this.background,
    required this.image,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            SvgPicture.asset(
              image,
              color: AppColors.landingOrangeButton,
              width: 25.0,
              height: 25.0,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(text, overflow: TextOverflow.fade, style: Styles.textStyleDashGridMd()),
          ],
        ),
      ),
    );
  }
}
