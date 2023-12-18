import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';
import 'package:smat_crow/screens/fieldagents/fieldagents_providers/sun_chart_provider.dart';

class SuninessChartItem extends StatefulWidget {
  final String chartTitle;
  final PlantDetailResponse plantData;

  const SuninessChartItem({super.key, required this.chartTitle, required this.plantData});

  @override
  _SuninessChartItemState createState() => _SuninessChartItemState();
}

class _SuninessChartItemState extends State<SuninessChartItem> {
  @override
  void initState() {
    super.initState();
    Provider.of<SunChartProvider>(context, listen: false).getSunniessData(widget.plantData.name!);
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<SunChartProvider>(context, listen: false).sunChartContainer(widget.chartTitle);
  }
}
