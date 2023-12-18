import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/assets/images.dart';
import '../../../utils/styles.dart';

class FieldAgentSitesItem extends StatelessWidget {
  const FieldAgentSitesItem({
    Key? key,
    required this.siteName,
    required this.siteId,
    required this.organizationId,
    required this.sectorCount,
    required this.isDummy,
    this.getSelectedId,
  }) : super(key: key);

  final String siteName, siteId, organizationId;
  final int sectorCount;
  final getSelectedId;
  final bool isDummy;

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    bool isTapped = false;
    return isDummy
        ? InkWell(
            onTap: () {
              pandora.logAPPButtonClicksEvent('CREATE_NEW_SITE_ITEM_CLICKED');

              pandora.reRouteUser(
                  context,
                  '/createSite-Sector',
                  CreateSiteSectorArgs(
                    organizationId,
                    'siteId',
                    true,
                  ),);
            },
            child: Container(
              height: 200,
              width: 200,
              decoration: Styles.containerDecoGrey(),
              child: Center(
                child: Styles.dAddIconWhite(),
              ),
            ),
          )
        : InkWell(
            onTap: () {
              pandora.logAPPButtonClicksEvent('SITE_ITEM_CLICKED');

              isTapped = true;
              getSelectedId(siteId, siteName, sectorCount, isTapped);
            },
            child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: ExactAssetImage(ImagesAssets.kSitesImage),
                    fit: BoxFit.fitHeight,
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          gradient: LinearGradient(
                            colors: [
                              AppColors.transperant,
                              AppColors.darkColor.withOpacity(0.6),
                            ],
                            stops: const [0.7, 2.0],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: Text(siteName,
                                maxLines: 3, style: GoogleFonts.poppins(textStyle: Styles.normalWhiteTextStyle()),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),),
          );
  }
}
