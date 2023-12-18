import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../network/feeds/models/suninness_response.dart';
import '../../../network/feeds/network/plants_db_operations.dart';
import '../../../utils/styles.dart';
import '../widgets/sample_chatr_data.dart';

class SunChartProvider extends ChangeNotifier {
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  late SunninessResponse suninessData;
  List<ChartModelData> chartData = [];

  bool get mounted => false;

  Widget sunChartContainer(String chartTitle) {
    return Container(
      child: (chartData.isNotEmpty)
          ? SizedBox(
              width: 230,
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: _buildDefaultDoughnutChart(chartTitle),
              ),
            )
          : Container(),
    );
  }

  SfCircularChart _buildDefaultDoughnutChart(String chartTitle) {
    return SfCircularChart(
      title: ChartTitle(
        text: chartTitle,
        textStyle: GoogleFonts.poppins(textStyle: Styles.normalTextLarge()),
        alignment: ChartAlignment.near,
      ),
      legend: const Legend(
        isVisible: true,
        position: LegendPosition.right,
        isResponsive: true,
        orientation: LegendItemOrientation.vertical,
      ),
      series: _getDefaultDoughnutSeries(),
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  List<DoughnutSeries<ChartModelData, String>> _getDefaultDoughnutSeries() {
    return <DoughnutSeries<ChartModelData, String>>[
      DoughnutSeries<ChartModelData, String>(
        radius: '80%',
        innerRadius: '60%',
        dataSource: chartData,
        xValueMapper: (ChartModelData data, _) => data.x,
        yValueMapper: (ChartModelData data, _) => data.y,
        dataLabelMapper: (ChartModelData data, _) => data.text,
        dataLabelSettings: const DataLabelSettings(),
      )
    ];
  }

  Future getSunniessData(String plantId) async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getSunRequirements(plantId);
      if (data != null) {
        if (mounted) {
          suninessData = data;
          chartData = <ChartModelData>[
            ChartModelData(x: 'Sun', y: suninessData.sun!.toDouble(), text: '${suninessData.sun}'),
            ChartModelData(x: 'Semi Shade', y: suninessData.semiShade!.toDouble(), text: '${suninessData.semiShade}'),
            ChartModelData(x: 'Shade', y: suninessData.shade!.toDouble(), text: '${suninessData.shade}'),
          ];
        }
      } else {}
      return data;
    });
  }
}
