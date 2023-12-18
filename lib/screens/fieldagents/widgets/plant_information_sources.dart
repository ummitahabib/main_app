import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';
import 'package:smat_crow/screens/fieldagents/widgets/plant_links_item.dart';
import 'package:smat_crow/utils/constants.dart';

class PlantInformationSources extends StatelessWidget {
  final PlantDetailResponse plantData;

  const PlantInformationSources({Key? key, required this.plantData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BoldHeaderText(text: 'Sources', fontSize: 18),
          const SizedBox(
            height: 10,
          ),
          PlantLinksItem(
            message: 'Wikipedia (English)',
            Url: plantData.enWikipediaUrl ?? "",
          ),
          const SizedBox(
            height: 5,
          ),
          PlantLinksItem(
            message: 'OpenFarm - Growing guide',
            Url: '$OPEN_FARM_URL${plantData.name}',
          ),
          const SizedBox(
            height: 5,
          ),
          PlantLinksItem(
            message: 'Gardenate - Planting Reminders',
            Url: '$GARDENATE_URL${plantData.name}',
          ),
          const SizedBox(
            height: 5,
          ),
          PlantLinksItem(
            message: 'Wikihow Instructions',
            Url: '$WIKI_HOW${plantData.name}',
          ),
        ],
      ),
    );
  }
}
