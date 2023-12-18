import 'package:flutter/material.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/styles.dart';

class PlantDetailsDescription extends StatelessWidget {
  const PlantDetailsDescription({
    Key? key,
    required this.plantData,
  }) : super(key: key);

  final PlantDetailResponse plantData;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            'About',
            style: Styles.smatCrowMediumSubParagraph(color: AppColors.SmatCrowNeuBlue900)
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            plantData.openfarmData!.attributes!.description!,
            style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue500),
          ),
        )
      ],
    );
  }
}
