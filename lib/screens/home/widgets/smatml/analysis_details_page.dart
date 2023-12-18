import 'dart:io';

import 'package:async/async.dart';
import 'package:beamer/beamer.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smat_crow/network/crow/ml_operations.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/custom_dragging_handle.dart';
import 'package:smat_crow/screens/home/widgets/smatml/solutions_item.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../../../network/crow/models/farm_probe_response.dart';
import '../../../../network/crow/models/plant_description_details.dart';
import '../../../shared/fatal_error_page.dart';
import 'more_images_item.dart';
import 'more_info_item.dart';

class AnalysisDetailsPage extends StatefulWidget {
  final String imagePath;

  const AnalysisDetailsPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _AnalysisDetailsPageState createState() => _AnalysisDetailsPageState();
}

class _AnalysisDetailsPageState extends State<AnalysisDetailsPage> {
  late Widget _details;
  late PlantDescriptionDetail diseaseData;
  final AsyncMemoizer detectAsync = AsyncMemoizer();
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  List<Widget> solutionsItems = [];
  List<Widget> moreInfoItems = [];
  List<Widget> externalVideoItem = [];
  List<Widget> externalImageItem = [];
  late String loadHeader;

  @override
  void initState() {
    super.initState();
    _details = getImageAnalysis();
    loadHeader = 'Please Wait - -';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.black,
            ),
            if (kIsWeb)
              Image.network(
                widget.imagePath,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              )
            else
              Image.file(
                File(widget.imagePath),
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            Positioned(
              left: 25,
              top: 20,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: AppColors.landingOrangeButton,
                onPressed: () {
                  if (kIsWeb) {
                    context.beamToReplacementNamed(ConfigRoute.mainPage);
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Icon(Icons.arrow_back),
              ),
            ),
            DraggableScrollableSheet(
              initialChildSize: 0.30,
              minChildSize: 0.3,
              snap: true,
              builder: (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    elevation: 12.0,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                    ),
                    margin: EdgeInsets.zero,
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

  Widget getImageAnalysis() {
    getImageDiseases(widget.imagePath);
    return EnhancedFutureBuilder(
      future: getImageDiseases(widget.imagePath),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(20),
            child: Text("No Analysis Available"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                getImageDiseases(widget.imagePath);
              });
            },
            child: const Text("RETRY"),
          )
        ],
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showResponse() {
    return Container(
      width: _screenWidth,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          const CustomDraggingHandle(),
          const SizedBox(height: 16),
          BottomSheetHeaderText(text: loadHeader),
          const Divider(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 0,
                  color: AppColors.dashCardGrey.withOpacity(0.1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
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
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              (diseaseData.name) ?? 'Unknown',
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              (diseaseData.leafName) ?? 'Unknown',
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              (diseaseData.healthyLeaf == null) ? 'Yes' : 'No',
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              (diseaseData.typeOfDisease) ?? 'Unknown',
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  color: AppColors.fieldAgentText,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Description',
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              color: AppColors.fieldAgentText,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          (diseaseData.description) ?? 'Unknown',
                          style: GoogleFonts.quicksand(
                            textStyle: const TextStyle(
                              color: AppColors.fieldAgentText,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
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
                      textStyle:
                          const TextStyle(color: AppColors.fieldAgentText, fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    return Align(alignment: Alignment.topCenter, child: solutionsItems[index]);
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
                      textStyle:
                          const TextStyle(color: AppColors.fieldAgentText, fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    return Align(alignment: Alignment.topCenter, child: moreInfoItems[index]);
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
                      textStyle:
                          const TextStyle(color: AppColors.fieldAgentText, fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    return Align(alignment: Alignment.topCenter, child: externalImageItem[index]);
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
                      textStyle:
                          const TextStyle(color: AppColors.fieldAgentText, fontSize: 16.0, fontWeight: FontWeight.bold),
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
                    return Align(alignment: Alignment.topCenter, child: externalVideoItem[index]);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Skeletonizer(
        child: Container(
          height: 150,
          width: _screenWidth,
          decoration: BoxDecoration(
            color: Colors.grey[350],
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future getImageDiseases(String imagePath) async {
    List<Widget> solutionItem = [];
    List<Widget> moreInfoItem = [];
    List<Widget> externalVideoItem = [];
    List<Widget> externalImageItem = [];

    // return _detectAsync.runOnce(() async {
    final data = await predictPlantLeaf(imagePath);
    if (data.isNotEmpty) {
      final FarmProbeResponse response = data[0];
      final plantDescriptionDetail = response.plantDescriptionDetails;

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

      setState(() {
        loadHeader = 'Analysis Details';
        diseaseData = plantDescriptionDetail[0];
        solutionsItems = solutionItem;
        moreInfoItems = moreInfoItem;
        externalImageItem = externalImageItem;
        externalVideoItem = externalVideoItem;
      });
      return data;
    } else {
      await showDialog(
        context: context,
        builder: (context) => const Dialog(
          child: FatalErrorPage(errorMessage: "Unable to process plant image", image: "", redirectRoute: ""),
        ),
      );
      throw Exception("Unable to process plant image");
    }
    //  });
  }
}
