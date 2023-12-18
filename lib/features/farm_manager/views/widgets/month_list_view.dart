import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class MonthListView extends HookConsumerWidget {
  const MonthListView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentMonth = useState(0);
    final dash = ref.watch(farmDashProvider);
    return SizedBox(
      height: SpacingConstants.size28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            currentMonth.value = index;
            dash.budgetBreakdown = dash.breakdown.budgetBreakdown[index];
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: SpacingConstants.size4,
              horizontal: SpacingConstants.size8,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SpacingConstants.size5),
              color: currentMonth.value == index ? AppColors.SmatCrowNeuBlue700 : null,
            ),
            child: Text(
              dash.breakdown.budgetBreakdown[index].month,
              style: Styles.smatCrowSubParagraphRegular(
                color: currentMonth.value == index ? Colors.white : AppColors.SmatCrowNeuBlue600,
              ),
            ),
          ),
        ),
        separatorBuilder: (context, index) => const SizedBox(width: SpacingConstants.size5),
        itemCount: dash.breakdown.budgetBreakdown.length,
      ),
    );
  }
}
