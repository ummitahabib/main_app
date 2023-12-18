import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';

import '../fieldagents_providers/sun_chart_provider.dart';

class HarvestedChartItem extends StatefulWidget {
  const HarvestedChartItem({Key? key, required this.plantData, required this.chartTitle}) : super(key: key);
  final String chartTitle;
  final PlantDetailResponse plantData;

  @override
  _HarvestedChartItemState createState() => _HarvestedChartItemState();
}

class _HarvestedChartItemState extends State<HarvestedChartItem> {
  @override
  void initState() {
    super.initState();
    Provider.of<SunChartProvider>(context, listen: false).getSunniessData(widget.plantData.name!);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Provider.of(context).buildDefaultDoughnutChart,
      ),
    );
  }
}
