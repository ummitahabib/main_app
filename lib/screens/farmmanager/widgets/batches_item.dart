import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/assets/images.dart';

class BatchesItem extends StatelessWidget {
  const BatchesItem({
    Key? key,
    required this.batchName,
    required this.batchId,
    required this.imageCount,
    required this.isDummy,
    this.getSelectedId,
  }) : super(key: key);

  final String batchName, batchId;
  final int imageCount;
  final getSelectedId;
  final bool isDummy;

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();

    bool isTapped = false;
    return isDummy
        ? InkWell(
            onTap: () {
              Fluttertoast.showToast(
                  msg: 'Please Perform this action of your web portal',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,);
            },
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
          )
        : InkWell(
            onTap: () {
              isTapped = true;
              pandora.logAPPButtonClicksEvent('BATCH_ITEM_CLICKED');
              getSelectedId(batchId, batchName, imageCount, isTapped);
            },
            child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.blueGreyColor,
                  borderRadius: BorderRadius.circular(8),
                  image: const DecorationImage(
                    image: ExactAssetImage(ImagesAssets.kBatchImages),
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
                            child: Text(batchName,
                                maxLines: 3,
                                style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 9,
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
