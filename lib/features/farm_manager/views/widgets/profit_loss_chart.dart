import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_row_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/chart_widget.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ProfitLossChart extends HookConsumerWidget {
  const ProfitLossChart({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(farmManagerProvider).getAgentUserType() == AgentTypeEnum.field) {
      return const SizedBox.shrink();
    }
    final farmDash = ref.watch(farmDashProvider);

    useEffect(
      () {
        Future(() {
          if (kIsWeb) {
            final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
            final id = beamState.pathPatternSegments;
            farmDash.pnlBreakdown(orgId: id.last);
          } else {
            farmDash.pnlBreakdown();
          }
        });
        return null;
      },
      [],
    );
    return AppContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              BoldHeaderText(
                text: pnlChartText,
                fontSize: SpacingConstants.font18,
              ),
              Spacer(),
              ColorTextRow(
                color: AppColors.SmatCrowPrimary500,
                text: profitText,
              ),
              Xmargin(SpacingConstants.font10),
              ColorTextRow(
                color: AppColors.SmatCrowNeuOrange800,
                text: lossText,
              )
            ],
          ),
          const Ymargin(SpacingConstants.size20),
          SizedBox(
            height: 300,
            child: AspectRatio(
              aspectRatio: 3,
              child: SfCartesianChart(
                title: ChartTitle(
                  alignment: ChartAlignment.near,
                  textStyle: Styles.smatCrowMediumSubParagraph(color: AppColors.SmatCrowNeuBlue900)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                plotAreaBorderWidth: 0,
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <ColumnSeries>[
                  ColumnSeries<ChartModel, String>(
                    dataSource: farmDash.pnlBreakdownList.map((e) => ChartModel(e.month, e.income.toInt())).toList(),
                    color: AppColors.SmatCrowPrimary500,
                    borderColor: AppColors.SmatCrowPrimary500,
                    xValueMapper: (datum, index) => datum.xAxis,
                    yValueMapper: (datum, index) => datum.yAxis,
                    enableTooltip: true,
                    width: 0.2,
                  ),
                  ColumnSeries<ChartModel, String>(
                    dataSource: farmDash.pnlBreakdownList.map((e) => ChartModel(e.month, e.expense.toInt())).toList(),
                    color: AppColors.SmatCrowNeuOrange800,
                    borderColor: AppColors.SmatCrowNeuOrange800,
                    xValueMapper: (datum, index) => datum.xAxis,
                    yValueMapper: (datum, index) => datum.yAxis,
                    enableTooltip: true,
                    width: 0.2,
                  )
                ],
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(labelFormat: '{value}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
