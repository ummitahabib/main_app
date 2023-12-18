import 'dart:developer';

import 'package:async/async.dart';
import 'package:beamer/beamer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';
import 'package:smat_crow/network/feeds/network/plants_db_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';
import 'package:smat_crow/screens/fieldagents/widgets/plant_details_description.dart';
import 'package:smat_crow/screens/fieldagents/widgets/plant_details_specifications.dart';
import 'package:smat_crow/screens/fieldagents/widgets/plant_information_sources.dart';
import 'package:smat_crow/screens/fieldagents/widgets/planted_chart_item.dart';
import 'package:smat_crow/screens/fieldagents/widgets/sun_chart_item.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';

import '../../../utils/assets/nsvgs_assets.dart';
import '../../../utils/strings.dart';

class PlantDetailProvider extends ChangeNotifier {
  final AsyncMemoizer asyncMemoizer = AsyncMemoizer();
  final Pandora _pandora = Pandora();

  PlantDetailResponse? plantData;

  bool get mounted => false;

  Widget plantDetailContainer(BuildContext context, widget) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: customAppBar(
          context,
          title: 'Plant Details',
          center: true,
          onTap: () {
            if (kIsWeb) {
              context.beamToReplacementNamed(ConfigRoute.plantDatabase);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        body: FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return _showLoader();
            }
            return (plantData != null)
                ? SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: plantData!.openfarmData!.attributes!.mainImagePath!,
                              width: Responsive.xWidth(context),
                              fit: BoxFit.cover,
                              progressIndicatorBuilder: (context, url, progress) =>
                                  const Center(child: CircularProgressIndicator.adaptive()),
                              errorWidget: (context, error, stackTrace) {
                                return Image.network(defaultImage, fit: BoxFit.cover);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: BoldHeaderText(
                            text: _pandora.camelCaseSentence(plantData!.name!),
                            fontSize: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: Color600Text(
                            text: _pandora.camelCaseSentence(plantData!.openfarmData!.attributes!.binomialName!),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PlantDetailsDescription(plantData: plantData!),
                        const SizedBox(
                          height: 20,
                        ),
                        PlantDetailsSpecifications(plantData: plantData!),
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 18),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                SuninessChartItem(
                                  plantData: plantData!,
                                  chartTitle: 'Sunniness',
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                PlantedChartItem(
                                  plantData: plantData!,
                                  chartTitle: 'Planting Method',
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        PlantInformationSources(plantData: plantData!),
                        const SizedBox(
                          height: 40,
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        const Text(
                          'Not Found',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontFamily: 'semibold',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            'Unfortunately, we do not have sufficient information on this plant ${widget.plantIdentifier}.\n\nPlease check that you have spelt your search correctly or use alternative crop names',
                            textAlign: TextAlign.center,
                            // style: Styles.defaultTextRegular(),
                          ),
                        ),
                        Expanded(
                          child: Center(
                            child: SvgPicture.asset(
                              NsvgsAssets.kFieldTools,
                              height: 200,
                              width: 200,
                            ),
                          ),
                        ),
                        SquareButton(
                          backgroundColor: AppColors.whiteColor,
                          press: () {
                            if (kIsWeb) {
                              context.beamToReplacementNamed(ConfigRoute.plantDatabase);
                            } else {
                              Navigator.pop(context);
                            }
                          },
                          textColor: AppColors.whiteColor,
                          text: 'Return',
                        ),
                      ],
                    ),
                  );
          },
          future: fetchPlantDetails(widget.plantIdentifier, context),
        ),
      ),
    );
  }

  Widget _showLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
          ],
        ),
      ),
    );
  }

  Future fetchPlantDetails(String plantId, BuildContext context) async {
    final data = await getPlantDetailsById(plantId);

    if (data != null) {
      log(data['openfarm_data'].toString());
      if (data['openfarm_data'] == null || data['openfarm_data'] == false) {
        plantData = null;
      } else {
        plantData = PlantDetailResponse.fromJson(data);
      }

      notifyListeners();
    }
    return data;
  }
}
