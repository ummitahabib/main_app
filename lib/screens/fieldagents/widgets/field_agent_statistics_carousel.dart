import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/utils/colors.dart';

import '../fieldagents_providers/promo_carasoul_provider.dart';

class FieldAgentStatisticsCarousel extends StatefulWidget {
  final List<Widget> fieldAgentGridItem;

  const FieldAgentStatisticsCarousel({required this.fieldAgentGridItem, Key? key}) : super(key: key);

  @override
  _FieldAgentStatisticsCarouselState createState() {
    return _FieldAgentStatisticsCarouselState();
  }
}

class _FieldAgentStatisticsCarouselState extends State<FieldAgentStatisticsCarousel> {
  //int _current = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
        items: widget.fieldAgentGridItem,
        options: CarouselOptions(
            autoPlay: true,
            aspectRatio: 1.5,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 10),
            scrollPhysics: const BouncingScrollPhysics(),
            onPageChanged: (index, reason) {
              Provider.of<PromoCarouselProvider>(context).current;
            },),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: widget.fieldAgentGridItem.map((data) {
          final int index = widget.fieldAgentGridItem.indexOf(data);
          return Container(
            width: 14.0,
            height: 3.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Provider.of<PromoCarouselProvider>(context).current == index
                  ? AppColors.landingOrangeButton
                  : AppColors.shadowColor,
            ),
          );
        }).toList(),
      ),
    ],);
  }
}
