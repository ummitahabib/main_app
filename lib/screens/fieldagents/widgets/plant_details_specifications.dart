import 'package:flutter/material.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../../utils/strings.dart';

class PlantDetailsSpecifications extends StatelessWidget {
  const PlantDetailsSpecifications({
    Key? key,
    required this.plantData,
  }) : super(key: key);

  final PlantDetailResponse plantData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: AppColors.SmatCrowNeuBlue50),
      padding: const EdgeInsets.all(18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlantSubDetails(
                  asset: "assets2/images/0019.png",
                  title: 'Average Life Span',
                  subtitle: (plantData.medianLifespan != null) ? (plantData.medianLifespan! / 7).ceil().toString() : '',
                  unit: (plantData.medianLifespan != null) ? weeks : unknown,
                ),
                const SizedBox(height: 20),
                PlantSubDetails(
                  asset: "assets2/images/31.png",
                  title: 'Estimated First Harvest',
                  subtitle: (plantData.medianDaysToFirstHarvest != null)
                      ? (plantData.medianDaysToFirstHarvest! / 7).ceil().toString()
                      : '',
                  unit: (plantData.medianLifespan != null) ? weeks : unknown,
                ),
                const SizedBox(height: 20),
                PlantSubDetails(
                  asset: "assets2/images/0018.png",
                  title: 'Estimated Last Harvest',
                  subtitle: (plantData.medianDaysToLastHarvest != null)
                      ? (plantData.medianDaysToLastHarvest! / 7).ceil().toString()
                      : '',
                  unit: (plantData.medianDaysToLastHarvest != null) ? weeks : unknown,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlantSubDetails(
                  asset: "assets2/images/0018.png",
                  title: 'Row Spacing',
                  subtitle: (plantData.openfarmData!.attributes!.rowSpacing != null)
                      ? plantData.openfarmData!.attributes!.rowSpacing.toString()
                      : '',
                  unit: (plantData.openfarmData!.attributes!.rowSpacing != null) ? 'cm' : unknown,
                ),
                const SizedBox(height: 20),
                PlantSubDetails(
                  asset: "assets2/images/0025.png",
                  title: "Height",
                  subtitle: (plantData.openfarmData!.attributes!.height != null)
                      ? plantData.openfarmData!.attributes!.height.toString()
                      : '',
                  unit: (plantData.openfarmData!.attributes!.height != null) ? 'cm' : unknown,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class PlantSubDetails extends StatelessWidget {
  const PlantSubDetails({
    super.key,
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.unit,
  });
  final String asset;
  final String title;
  final String subtitle;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          asset,
          width: 27,
          height: 27,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: Styles.smatCrowCaptionRegular(color: AppColors.SmatCrowNeuBlue500),
            ),
            const SizedBox(height: 5),
            Text(
              "$subtitle $unit",
              style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900)
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
