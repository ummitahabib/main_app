import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/feeds/models/plant_details_by_id_response.dart';
import 'package:smat_crow/screens/fieldagents/widgets/sample_chatr_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../utils/styles.dart';
import '../fieldagents_providers/planted_chart_item_provider.dart';

class PlantedChartItem extends StatefulWidget {
  const PlantedChartItem({Key? key, required this.plantData, required this.chartTitle}) : super(key: key);
  final String chartTitle;
  final PlantDetailResponse plantData;

  @override
  _PlantedChartItemState createState() => _PlantedChartItemState();
}

class _PlantedChartItemState extends State<PlantedChartItem> {
  @override
  void initState() {
    super.initState();
    Provider.of<PlantedChartItemProvider>(context, listen: false).getPlantedChartData(widget.plantData.name!);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlantedChartItemProvider>(
      builder: (context, provider, child) {
        return Container(
          child: (provider.chartData.isNotEmpty)
              ? SizedBox(
                  width: 230,
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: _buildDefaultDoughnutChart(),
                  ),
                )
              : Container(),
        );
      },
    );
  }

  SfCircularChart _buildDefaultDoughnutChart() {
    return SfCircularChart(
      title: ChartTitle(
        text: widget.chartTitle,
        textStyle: GoogleFonts.poppins(textStyle: Styles.normalTextLarge()),
        alignment: ChartAlignment.near,
      ),
      legend: const Legend(isVisible: true, position: LegendPosition.right, orientation: LegendItemOrientation.vertical),
      series: _getDefaultDoughnutSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<DoughnutSeries<ChartModelData, String>> _getDefaultDoughnutSeries() {
    return <DoughnutSeries<ChartModelData, String>>[
      DoughnutSeries<ChartModelData, String>(
        radius: '80%',
        innerRadius: '60%',
        dataSource: Provider.of<PlantedChartItemProvider>(context, listen: false).chartData,
        xValueMapper: (ChartModelData data, _) => data.x,
        yValueMapper: (ChartModelData data, _) => data.y,
        dataLabelMapper: (ChartModelData data, _) => data.text,
        dataLabelSettings: const DataLabelSettings(),
      )
    ];
  }
}
