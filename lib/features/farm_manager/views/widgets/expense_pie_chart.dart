import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_breakdown.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ExpensePieChart extends HookConsumerWidget {
  const ExpensePieChart({super.key, required this.breakdown});
  final BudgetBreakdown breakdown;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pandora = Pandora();
    final manager = ref.watch(farmManagerProvider);

    return SizedBox(
      height: SpacingConstants.size250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PieChart(
            dataMap: {
              assetText: breakdown.asset,
              logText: breakdown.log,
              balanceText: breakdown.balance.abs(),
            },
            chartType: ChartType.ring,
            chartLegendSpacing: 32,
            chartRadius: SpacingConstants.size213,
            colorList: const [
              AppColors.SmatCrowAccentPurple,
              AppColors.SmatCrowBlue500,
              AppColors.SmatCrowGreen600,
            ],
            initialAngleInDegree: 0,
            centerText: "",
            animationDuration: const Duration(milliseconds: 800),
            legendOptions: const LegendOptions(
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              showLegends: false,
            ),
            chartValuesOptions: const ChartValuesOptions(
              showChartValues: false,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                breakdown.month,
                style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue600),
              ),
              const Ymargin(SpacingConstants.size5),
              BoldHeaderText(
                text:
                    "₦${pandora.newMoneyFormat(manager.budget == null ? 0.0 : (manager.budget!.seasonBudget ?? 0.0))}",
                fontSize: SpacingConstants.font21,
                fontFamily: arialFont,
              )
            ],
          )
        ],
      ),
    );
  }
}
