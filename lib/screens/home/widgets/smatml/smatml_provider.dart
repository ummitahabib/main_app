// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/crow/ml_operations.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/custom_dragging_handle.dart';
import 'package:smat_crow/screens/home/widgets/smatml/solutions_item.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../../network/crow/models/farm_probe_response.dart';
import '../../../../network/crow/models/plant_description_details.dart';
import '../../../../utils/styles.dart';
import '../../../shared/fatal_error_page.dart';
import 'more_images_item.dart';
import 'more_info_item.dart';

class SmatmlProvider extends ChangeNotifier {
  final String imagePath;
  SmatmlProvider(this.imagePath);
  late Widget _details;
  late PlantDescriptionDetail diseaseData;
  final AsyncMemoizer _detectAsync = AsyncMemoizer();
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  List<Widget> solutionsItems = [];
  List<Widget> moreInfoItems = [];
  List<Widget> externalVideoItem = [];
  List<Widget> externalImageItem = [];
  late String loadHeader;

  Widget safeArea(BuildContext context, widget) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            Image.file(
              File(widget.imagePath),
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            Positioned(
              left: 25,
              top: 10,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.landingOrangeButton,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.30,
              minChildSize: 0.15,
              snap: true,
              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    elevation: 12.0,
                    shape: Styles.defaultRoundedRect24(),
                    margin: const EdgeInsets.all(0),
                    child: _details,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget getImageAnalysis(String imagePath, BuildContext context) {
    // Pass both required arguments to getImageDiseases
    getImageDiseases(imagePath, context);
    return EnhancedFutureBuilder(
      future: getImageDiseases(imagePath, context), // Pass both arguments here as well
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No Analysis Available"),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showResponse() {
    return Container(
      width: _screenWidth,
      decoration: Styles.defaultBoxDeco24(),
      child: Column(
        children: [
          const SizedBox(height: 36),
          const CustomDraggingHandle(),
          const SizedBox(height: 16),
          BottomSheetHeaderText(text: loadHeader),
          const SizedBox(height: 31),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: AppColors.dashCardGrey.withOpacity(0.1),
                  shape: Styles.defaultRoundedRect9(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Name',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.bTextStyle(),
                              ),
                            ),
                            Text(
                              (diseaseData.name) ?? 'Unknown',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.mTextStyle(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Leaf Name',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.bTextStyle(),
                              ),
                            ),
                            Text(
                              (diseaseData.leafName) ?? 'Unknown',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.mTextStyle(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Healthy Leaf',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.bTextStyle(),
                              ),
                            ),
                            Text(
                              (diseaseData.healthyLeaf ?? true) ? 'Yes' : 'No',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.mTextStyle(),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Disease Name',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.bTextStyle(),
                              ),
                            ),
                            Text(
                              (diseaseData.typeOfDisease) ?? 'Unknown',
                              style: GoogleFonts.quicksand(
                                textStyle: Styles.mTextStyle(),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  elevation: 0,
                  color: AppColors.dashCardGrey.withOpacity(0.1),
                  shape: Styles.defaultRoundedRect9(),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.quicksand(
                            textStyle: Styles.bTextStyle(),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          (diseaseData.description) ?? 'Unknown',
                          style: GoogleFonts.quicksand(
                            textStyle: Styles.mTextStyle(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    'Solutions',
                    style: GoogleFonts.quicksand(
                      textStyle: Styles.bTextStyle(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: solutionsItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: solutionsItems[index],
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    'More Information',
                    style: GoogleFonts.quicksand(
                      textStyle: Styles.bTextStyle(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: moreInfoItems.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: moreInfoItems[index],
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    'Related Images',
                    style: GoogleFonts.quicksand(
                      textStyle: Styles.bTextStyle(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: externalImageItem.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: externalImageItem[index],
                    );
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: Text(
                    'Videos',
                    style: GoogleFonts.quicksand(
                      textStyle: Styles.bTextStyle(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: externalVideoItem.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: externalVideoItem[index],
                    );
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _showLoader() {
    return SizedBox(
      width: _screenWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Container(
                height: 150,
                width: _screenWidth,
                decoration: Styles.containerDecoGrey(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImageDiseases(String imagePath, BuildContext context) async {
    List<Widget> solutionItem = [];
    List<Widget> moreInfoItem = [];
    List<Widget> externalVideoItem = [];
    List<Widget> externalImageItem = [];

    return _detectAsync.runOnce(() async {
      final data = await predictPlantLeaf(imagePath);
      if (data.isNotEmpty) {
        final FarmProbeResponse response = data[0];
        List<PlantDescriptionDetail> plantDescriptionDetail = response.plantDescriptionDetails;

        diseaseData = plantDescriptionDetail[0];

        for (final solution in diseaseData.solutions!) {
          solutionItem.add(
            SolutionsItem(
              name: solution.name,
              solution: solution.solution,
              steps: solution.steps!,
            ),
          );
        }

        for (final link in diseaseData.externalLinks!) {
          moreInfoItem.add(
            MoreInfoItem(
              name: link.name,
              link: link.link,
            ),
          );
        }

        for (final link in diseaseData.externalVideo!) {
          externalVideoItem.add(
            MoreInfoItem(
              name: link.name,
              link: link.video,
            ),
          );
        }

        for (final image in diseaseData.image!) {
          externalImageItem.add(
            MoreImagesItem(
              name: image.name,
              link: image.image,
            ),
          );
        }

        loadHeader = 'Analysis Details';
        diseaseData = plantDescriptionDetail[0];
        solutionsItems = solutionItem;
        moreInfoItems = moreInfoItem;
        externalImageItem = externalImageItem;
        externalVideoItem = externalVideoItem;
        notifyListeners();
        return data;
      } else {
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const FatalErrorPage(
              errorMessage: "Unable to process plant image",
              image: "",
              redirectRoute: "",
            ),
          ),
          (route) => false,
        );
      }
    });
  }
}
