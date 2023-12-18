import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/hive/daos/SitesEntity.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/assets/nsvgs_assets.dart';
import 'offline_sites_provider.dart';

class OfflineSitesListItem extends StatelessWidget {
  final SitesEntity sitesEntity;
  final Color background;

  const OfflineSitesListItem({
    Key? key,
    required this.sitesEntity,
    required this.background,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final Pandora pandora = new Pandora();
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13),
        child: Row(
          children: [
            SvgPicture.asset(
              NsvgsAssets.kCategory,
              color: AppColors.landingOrangeButton,
              width: 25.0,
              height: 25.0,
            ),
            const SizedBox(
              width: 15,
            ),
            Text(
              sitesEntity.name,
              overflow: TextOverflow.fade,
              style: const TextStyle(color: AppColors.dashGridTextColor, fontSize: 15.0, fontFamily: 'regular'),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> displayModalWithChild(Widget child, String header, BuildContext context) async {
    await Provider.of<OfflineSitesProvider>(context, listen: false).showModalButtonSheet(child, header, context);
  }
}
