import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/network/feeds/network/plants_db_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/fieldagents/widgets/popular_plants.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/styles.dart';

class PlantDatabasePage extends StatefulWidget {
  const PlantDatabasePage({Key? key}) : super(key: key);

  @override
  _PlantDatabasePageState createState() => _PlantDatabasePageState();
}

class _PlantDatabasePageState extends State<PlantDatabasePage> {
  final ScrollController _scrollController = ScrollController();
  final Pandora _pandora = Pandora();
  List plantList = [];
  List plantSearchList = [];
  @override
  void initState() {
    super.initState();
    getPopularPlants().then((value) {
      setState(() {
        plantList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.SmatCrowNeuBlue50,
        title: Text(
          'Plant Database',
          overflow: TextOverflow.fade,
          style: Styles.smatCrowMediumBody(color: AppColors.SmatCrowNeuBlue900),
        ),
        toolbarHeight: 60,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: AppColors.fieldAgentText,
          ),
          onPressed: () {
            _pandora.logAPPButtonClicksEvent('PLANT_DATABASE_PAGE_BACK_BUTTON_CLICKED');
            if (kIsWeb) {
              context.beamToReplacementNamed(ConfigRoute.mainPage);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      backgroundColor: AppColors.SmatCrowNeuBlue50,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomTextField(
                    hintText: "Search for plant",
                    text: "",
                    textInputAction: TextInputAction.search,
                    keyboardType: TextInputType.name,
                    onSubmitted: (value) {
                      setState(() {
                        plantSearchList = plantList
                            .where((element) => element['name'].toString().toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                      log(plantSearchList.toString());
                    },
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 5),
              child: BoldHeaderText(text: 'Popular Plants'),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (plantSearchList.isEmpty)
                      const PopularPlants()
                    else
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Responsive.isDesktop(context)
                              ? 4
                              : Responsive.isTablet(context)
                                  ? 3
                                  : 2,
                        ),
                        shrinkWrap: true,
                        itemCount: plantSearchList.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = plantSearchList[index];
                          if (data == null) {
                            return const SizedBox.shrink();
                          }
                          return InkWell(
                            onTap: () {
                              _pandora.logAPPButtonClicksEvent('POPULAR_PLANT_ITEM_CLICKED');

                              if (data != null) {
                                if (kIsWeb) {
                                  _pandora.reRouteUser(
                                    context,
                                    "${ConfigRoute.plantDetails}/${data['id']}",
                                    data['id'],
                                  );
                                } else {
                                  _pandora.reRouteUser(context, ConfigRoute.plantDetails, data['id']);
                                }
                              }
                            },
                            child: SizedBox(
                              width: 170,
                              height: 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: CachedNetworkImage(
                                        imageUrl: data['thumbnail_url'],
                                        width: 170,
                                        fit: BoxFit.cover,
                                        errorWidget: (context, url, error) => Image.network(DEFAULT_IMAGE),
                                        progressIndicatorBuilder: (context, url, progress) => Skeletonizer(
                                          child: Card(
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                            color: AppColors.SmatCrowNeuBlue400,
                                            elevation: 0,
                                            child: const SizedBox(
                                              width: 170,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          data == null ? '' : data['name'] ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style: Styles.smatCrowMediumBody(color: AppColors.SmatCrowNeuBlue900)
                                              .copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data == null ? '' : data['scientific_name'] ?? "",
                                          overflow: TextOverflow.ellipsis,
                                          softWrap: false,
                                          style:
                                              Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue500),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
