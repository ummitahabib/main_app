import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_breakdown.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/create_budget.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/expense_pie_chart.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/monthly_breakdown.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmManagerExpBreakDown extends HookConsumerWidget {
  const FarmManagerExpBreakDown({super.key, this.showBudget = true});
  final bool showBudget;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(farmManagerProvider).getAgentUserType() == AgentTypeEnum.field) {
      return const SizedBox.shrink();
    }
    final farmDash = ref.watch(farmDashProvider);
    final manager = ref.watch(farmManagerProvider);
    useEffect(
      () {
        Future(() {
          if (kIsWeb) {
            final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
            final id = beamState.pathPatternSegments;
            farmDash.incomeBreakdown(orgId: id.last);
            manager.getBudget(orgId: id.last);
          } else {
            farmDash.incomeBreakdown();
            manager.getBudget();
          }
        });
        return null;
      },
      [],
    );

    final pandora = Pandora();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BoldHeaderText(
          text: expensesBreakdownText,
          fontSize: SpacingConstants.font18,
        ),
        const Ymargin(SpacingConstants.size20),
        AppMaterial(
          child: Padding(
            padding: const EdgeInsets.all(SpacingConstants.font14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppMaterial(
                  child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(AppAssets.budget),
                        const Xmargin(SpacingConstants.size5),
                        Text(
                          budgetText,
                          style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue600),
                        ),
                        if (manager.budget != null)
                          BoldHeaderText(
                            text: ": ₦${pandora.newMoneyFormat(manager.budget!.seasonBudget ?? 0.0)}",
                            fontFamily: arialFont,
                          )
                      ],
                    ),
                    trailing: manager.budget != null
                        ? InkWell(
                            child: const Icon(Icons.edit_outlined, color: AppColors.SmatCrowPrimary500),
                            onTap: () {
                              if (Responsive.isDesktop(context)) {
                                customDialog(context, const CreateBudget());
                              } else {
                                Pandora().reRouteUser(context, ConfigRoute.createBudget, "");
                              }
                            },
                          )
                        : TextButton.icon(
                            icon: const Icon(Icons.add, color: AppColors.SmatCrowPrimary500),
                            label: Text(
                              createBudgetText,
                              style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue600),
                            ),
                            onPressed: () {
                              if (Responsive.isDesktop(context)) {
                                customDialog(context, const CreateBudget());
                              } else {
                                Pandora().reRouteUser(context, ConfigRoute.createBudget, "");
                              }
                            },
                          ),
                  ),
                ),
                const Ymargin(SpacingConstants.size20),
                if (Responsive.isDesktop(context))
                  Row(
                    children: [
                      const Xmargin(SpacingConstants.size40),
                      ExpensePieChart(
                        breakdown: farmDash.budgetBreakdown.month.isEmpty || farmDash.breakdown.budgetBreakdown.isEmpty
                            ? farmDash.budgetBreakdown
                            : farmDash.breakdown.budgetBreakdown.firstWhere(
                                (element) => element.month == farmDash.budgetBreakdown.month,
                                orElse: () => BudgetBreakdown(month: "", asset: 0.0, log: 0.0, balance: 0.0),
                              ),
                      ),
                      const Xmargin(SpacingConstants.size20),
                      const Expanded(
                        child: MonthlyBreakdown(),
                      )
                    ],
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ExpensePieChart(
                        breakdown: farmDash.budgetBreakdown.month.isEmpty || farmDash.breakdown.budgetBreakdown.isEmpty
                            ? BudgetBreakdown(month: "", asset: 0.0, log: 0.0, balance: 0.0)
                            : farmDash.breakdown.budgetBreakdown.firstWhere(
                                (element) => element.month == farmDash.budgetBreakdown.month,
                                orElse: () => BudgetBreakdown(month: "", asset: 0.0, log: 0.0, balance: 0.0),
                              ),
                      ),
                      const Ymargin(SpacingConstants.size20),
                      const MonthlyBreakdown()
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
