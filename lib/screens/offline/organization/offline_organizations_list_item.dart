import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smat_crow/screens/offline/sites/offline_sites_menu.dart';
import 'package:smat_crow/screens/widgets/header_text.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/assets/nsvgs_assets.dart';
import '../../../utils/styles.dart';

class OfflineOrganizationsListItem extends StatelessWidget {
  final String text, image;
  final String id, name;
  final String? longDescription, shortDescription, address, industry, user;
  final Color background;
  final int? v;

  const OfflineOrganizationsListItem({
    Key? key,
    required this.text,
    required this.background,
    required this.image,
    required this.id,
    required this.name,
    this.longDescription,
    this.shortDescription,
    this.address,
    this.industry,
    this.user,
    this.v,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final Pandora pandora = new Pandora();
    return InkWell(
      onTap: () {
        displayModalWithChild(OfflineSitesMenu(organizationId: id), 'Your Sites', context);
      },
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
            Text(name, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
          ],
        ),
      ),
    );
  }

  Future<dynamic> displayModalWithChild(Widget child, String header, BuildContext context) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    HeaderText(
                      text: header,
                      color: Colors.black,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Styles.closeIconGrey(),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Styles.divider(),
                ),
                child,
              ],
            ),
          ),
        );
      },
    );
  }
}
