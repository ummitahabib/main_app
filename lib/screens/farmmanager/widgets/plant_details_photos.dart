import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';

import '../../../utils/styles.dart';

class PlantDetailsPhotos extends StatelessWidget {
  const PlantDetailsPhotos({
    Key? key,
    required this.plantData,
    required this.defaultImage,
  }) : super(key: key);

  final PlantDetailResponse plantData;
  final String defaultImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text('Photos', style: GoogleFonts.poppins(textStyle: Styles.normalTextLarge())),
        ),
        const SizedBox(
          height: 5,
        ),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(width: 12);
            },
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: plantData.openfarmData!.relationships!.pictures!.data.length,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: Image.network(
                  'https://s3.amazonaws.com/openfarm-project/production/media/pictures/attachments/${plantData.openfarmData!.relationships!.pictures!.data[index].id}.jpg',
                  height: 150,
                  width: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.network(defaultImage, fit: BoxFit.cover);
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
