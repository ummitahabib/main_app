import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/money_tile.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/month_list_view.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class MonthlyBreakdown extends HookConsumerWidget {
  const MonthlyBreakdown({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmDash = ref.watch(farmDashProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const MonthListView(),
        const Ymargin(SpacingConstants.size20),
        Container(
          padding: const EdgeInsets.all(SpacingConstants.font16),
          decoration: BoxDecoration(
            color: AppColors.SmatCrowNeuBlue50,
            borderRadius: BorderRadius.circular(SpacingConstants.size8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                breakdownText,
                style: Styles.smatCrowParagraphRegular(
                  color: AppColors.SmatCrowNeuBlue900,
                ),
              ),
              const Ymargin(SpacingConstants.size10),
              MoneyTile(
                title: balanceText,
                value: farmDash.budgetBreakdown.balance.abs(),
                color: AppColors.SmatCrowGreen600,
              ),
              MoneyTile(
                title: assetText,
                value: farmDash.budgetBreakdown.asset,
                color: AppColors.SmatCrowAccentPurple,
              ),
              MoneyTile(
                title: logText,
                value: farmDash.budgetBreakdown.log,
                color: AppColors.SmatCrowAccentBlue,
              )
            ],
          ),
        ),
        const Ymargin(SpacingConstants.size20),
        if (ref.watch(sharedProvider).userInfo != null &&
            ref.watch(sharedProvider).userInfo!.user.role.role != UserRole.institution.name)
          Padding(
            padding: const EdgeInsets.only(bottom: SpacingConstants.size20),
            child: InkWell(
              onTap: () {
                ref.read(logProvider).logResponse = null;
                Pandora().reRouteUser(
                  context,
                  ConfigRoute.registerFarmLog,
                  emptyString,
                );
              },
              child: Text(
                logExpenseText,
                style: Styles.smatCrowParagraphRegular500(
                  color: AppColors.SmatCrowPrimary500,
                ).copyWith(
                  fontSize: SpacingConstants.font14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
