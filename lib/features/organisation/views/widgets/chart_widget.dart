import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWidget extends StatefulWidget {
  const ChartWidget({
    super.key,
    required this.name,
    required this.xValue,
    required this.yValue,
    required this.dataSource,
  });

  final String name;
  final String? Function(ChartModel, int) xValue;
  final num? Function(ChartModel, int) yValue;
  final List<ChartModel> dataSource;

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  int startIndex = 0;
  int endIndex = 10;
  void divideList() {
    final int maxIndex = widget.dataSource.length - 1; // The maximum index of the list

    // Ensure endIndex does not exceed the maximum index
    endIndex = endIndex > maxIndex ? maxIndex : endIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
        vertical: SpacingConstants.size15,
      ),
      height: SpacingConstants.size222,
      child: AspectRatio(
        aspectRatio: 3,
        child: SfCartesianChart(
          title: ChartTitle(
            text: widget.name,
            alignment: ChartAlignment.near,
            textStyle: Styles.smatCrowMediumSubParagraph(color: AppColors.SmatCrowNeuBlue900)
                .copyWith(fontWeight: FontWeight.bold),
          ),
          plotAreaBorderWidth: 0.1,
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <SplineAreaSeries>[
            SplineAreaSeries<ChartModel, String>(
              dataSource: widget.dataSource,
              color: AppColors.SmatCrowPrimary500.withOpacity(.3),
              borderWidth: 4,
              borderColor: AppColors.SmatCrowPrimary500,
              xValueMapper: widget.xValue,
              yValueMapper: widget.yValue,
              enableTooltip: true,
            )
          ],
          primaryXAxis: CategoryAxis(),
          primaryYAxis: NumericAxis(labelFormat: '{value}'),
        ),
      ),
    );
  }
}

class ChartModel {
  final String xAxis;
  final int yAxis;

  ChartModel(this.xAxis, this.yAxis);
  Map<String, dynamic> toJson() => {
        "sAxis": xAxis,
        "yAxis": yAxis,
      };
}

String epochToDateString(int epoch) {
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(epoch * 1000);
  final String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
  return formattedDate;
}

String epochToDayString(int timestamp) {
  final DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  String dayName;

  switch (dateTime.weekday) {
    case DateTime.monday:
      dayName = "Monday";
      break;
    case DateTime.tuesday:
      dayName = "Tuesday";
      break;
    case DateTime.wednesday:
      dayName = "Wednesday";
      break;
    case DateTime.thursday:
      dayName = "Thursday";
      break;
    case DateTime.friday:
      dayName = "Friday";
      break;
    case DateTime.saturday:
      dayName = "Saturday";
      break;
    case DateTime.sunday:
      dayName = "Sunday";
      break;
    default:
      dayName = "Unknown";
  }

  return dayName;
}
