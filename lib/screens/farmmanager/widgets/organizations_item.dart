import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/assets/images.dart';

class OrganizationsItem extends StatelessWidget {
  const OrganizationsItem({
    Key? key,
    required this.organizationName,
    required this.siteCount,
    required this.organizationId,
    required this.isDummy,
    this.getSelectedId,
  }) : super(key: key);

  final String organizationName, organizationId;
  final int siteCount;
  final getSelectedId;
  final bool isDummy;

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    bool isTapped = false;
    return isDummy
        ? InkWell(
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
            onTap: () {
              pandora.logAPPButtonClicksEvent('CREATE_ORGANIZATION_ITEM_CLICKED');
              isTapped = true;
              getSelectedId("CREATE", "Create Organization", 0, isTapped);
              /*pandora
                  .logAPPButtonClicksEvent('CREATE_NEW_ORGANIZATION_PAGE_ITEM');
              pandora.loadDialogs(
                  'Create Organization', CreateOrganizationBody(), 510);*/
            },
          )
        : InkWell(
            onTap: () {
              pandora.logAPPButtonClicksEvent('ORGANIZATION_ITEM_CLICKED');
              isTapped = true;
              getSelectedId(organizationId, organizationName, siteCount, isTapped);
            },
            child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.blueGreyColor,
                  image: const DecorationImage(
                    image: ExactAssetImage(ImagesAssets.kFarmImage),
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
                            child: Text(organizationName,
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
