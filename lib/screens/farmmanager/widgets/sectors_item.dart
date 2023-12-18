import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../utils/assets/images.dart';
import '../../../utils/styles.dart';

class SectorsItem extends StatelessWidget {
  const SectorsItem({
    Key? key,
    required this.sectorName,
    required this.batchCount,
    required this.sectorId,
    required this.siteId,
    required this.isDummy,
    this.getSelectedId,
  }) : super(key: key);

  final String sectorName, sectorId, siteId;
  final int batchCount;
  final getSelectedId;
  final bool isDummy;

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    bool isTapped = false;
    return isDummy
        ? InkWell(
            child: Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Styles.addIconWhite(),
              ),
            ),
            onTap: () {
              pandora.logAPPButtonClicksEvent('CREATE_NEW_SECTOR_ITEM_CLICKED');

              pandora.reRouteUser(
                  context,
                  '/createSite-Sector',
                  CreateSiteSectorArgs(
                    'organizationId',
                    siteId,
                    false,
                  ),);
            },
          )
        : InkWell(
            onTap: () {
              pandora.logAPPButtonClicksEvent('SECTOR_ITEM_CLICKED');
              isTapped = true;
              getSelectedId(sectorId, sectorName, batchCount, isTapped);
            },
            child: Container(
                height: 150,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.blueGreyColor,
                  image: const DecorationImage(
                    image: ExactAssetImage(ImagesAssets.kSectorImage),
                    fit: BoxFit.fitHeight,
                  ),
                  borderRadius: BorderRadius.circular(8),
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
                            child: Text(sectorName,
                                maxLines: 3,
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 11,
                                ),),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),),
          );
  }
}
