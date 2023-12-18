import 'package:flutter/material.dart';
import 'package:inapp_browser/inapp_browser.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/styles.dart';

class PlantLinksItem extends StatelessWidget {
  final String message, Url;

  const PlantLinksItem({Key? key, required this.message, required this.Url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Text(message, style: Styles.smatCrowSubRegularUnderline(color: AppColors.SmatCrowPrimary500)),
      ),
      onTap: () {
        pandora.logAPPButtonClicksEvent('MORE_PLANT_INFO_ITEM_CLICKED');
        InappBrowser.showPopUpBrowser(
          context,
          Uri.parse(Url),
        );
      },
    );
  }
}
