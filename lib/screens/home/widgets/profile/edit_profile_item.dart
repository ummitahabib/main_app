import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

class EditProfileItem extends StatelessWidget {
  final String text, image, route;
  final Color background;

  const EditProfileItem({
    Key? key,
    required this.text,
    required this.background,
    required this.image,
    required this.route,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      onTap: () {
        pandora.logAPPButtonClicksEvent(
            'FARM_TOOLS_ITEM_${route.replaceAll('/', '').toUpperCase()}_CLICKED');
        pandora.reRouteUser(context, route, 'null');
      },
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
            Text(
              text,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                  color: AppColors.dashGridTextColor,
                  fontSize: 15.0,
                  fontFamily: 'regular'),
            ),
          ],
        ),
      ),
    );
  }
}
