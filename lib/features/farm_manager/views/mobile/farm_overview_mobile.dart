import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bill_details.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/expenses_breakdown.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/other_actions.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/overview_farm_asset_card.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/profit_loss_chart.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/quick_action.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/icons.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmOverviewMobile extends StatefulHookConsumerWidget {
  const FarmOverviewMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmOverviewMobileState();
}

class _FarmOverviewMobileState extends ConsumerState<FarmOverviewMobile> {
  @override
  Widget build(BuildContext context) {
    final farmDash = ref.watch(farmDashProvider);
    final shared = ref.watch(sharedProvider);
    final asset = ref.watch(assetProvider);
    final manager = ref.watch(farmManagerProvider);
    useEffect(
      () {
        manager.getAgentUserType();
        Future(() {
          if (shared.seasonList.isEmpty) {
            shared.getSeasons();
          }
          asset.getOrgAssets();

          if (manager.agentOrg != null &&
              (manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsHistoricalFinance) ||
                  manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsFinance))) {
            Future.wait([
              manager.getBudget(),
              farmDash.dashSummary(),
              farmDash.dashSummary(filter: SummaryType.sales),
              farmDash.incomeBreakdown(),
              farmDash.pnlBreakdown(),
            ]);
          }
        });

        return () {};
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(
        context,
        center: false,
        title: farmOverviewText,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => shared.seasonList
                .map(
                  (e) => PopupMenuItem(
                    value: e.description,
                    child: Text(e.description ?? ""),
                  ),
                )
                .toList(),
            onSelected: (value) {
              shared.season = shared.seasonList.firstWhere((element) => element.description == value);
              if (manager.agentOrg != null &&
                  (manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsHistoricalFinance) ||
                      manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsFinance))) {
                Future.wait([
                  manager.getBudget(),
                  farmDash.dashSummary(),
                  farmDash.dashSummary(filter: SummaryType.sales),
                  farmDash.incomeBreakdown(),
                  farmDash.pnlBreakdown()
                ]);
              }
            },
            child: Row(
              children: [
                Text(
                  shared.season != null ? (shared.season!.description ?? emptyString) : "Select Season",
                  style: Styles.smatCrowSubParagraphRegular(
                    color: AppColors.SmatCrowNeuBlue900,
                  ),
                ),
                const Xmargin(SpacingConstants.font10),
                const Icon(AppIcons.downIcon),
                const Xmargin(SpacingConstants.font10),
              ],
            ),
          ),
        ],
      ),
      body: Responsive.isTablet(context)
          ? RefreshIndicator.adaptive(
              onRefresh: () async {
                await asset.getOrgAssets();

                if (manager.agentOrg != null &&
                    (manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsHistoricalFinance) ||
                        manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsFinance))) {
                  await Future.wait([
                    manager.getBudget(),
                    farmDash.dashSummary(),
                    farmDash.dashSummary(filter: SummaryType.sales),
                    farmDash.incomeBreakdown(),
                    farmDash.pnlBreakdown()
                  ]);
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(SpacingConstants.size20),
                children: [
                  const QuickAction(),
                  const Ymargin(SpacingConstants.size20),
                  const OverviewFarmAssetCard(),
                  const Ymargin(SpacingConstants.size20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            BillDetails(
                              months: (farmDash.salesSummaryData.paid + farmDash.salesSummaryData.upcoming)
                                  .map((e) => e.month)
                                  .toSet()
                                  .toList(),
                              heading: moneyInText,
                              filter: SummaryType.sales,
                              summary: farmDash.salesSummaryData,
                            ),
                            const Ymargin(SpacingConstants.size20),
                            const FarmManagerExpBreakDown(),
                          ],
                        ),
                      ),
                      const Xmargin(SpacingConstants.double20),
                      Expanded(
                        child: Column(
                          children: [
                            BillDetails(
                              months: (farmDash.purchaseSummaryData.paid + farmDash.purchaseSummaryData.upcoming)
                                  .map((e) => e.month)
                                  .toSet()
                                  .toList(),
                              heading: moneyOutText,
                              filter: SummaryType.purchases,
                              summary: farmDash.purchaseSummaryData,
                            ),
                            const Ymargin(SpacingConstants.size20),
                            const ProfitLossChart(),
                            const Ymargin(SpacingConstants.size20),
                            const FarmManagerOtherActions()
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          : RefreshIndicator.adaptive(
              onRefresh: () async {
                await asset.getOrgAssets();

                if (manager.agentOrg != null &&
                    (manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsHistoricalFinance) ||
                        manager.agentOrg!.permissions!.contains(FarmManagerPermissions.containsFinance))) {
                  await Future.wait([
                    manager.getBudget(),
                    farmDash.dashSummary(),
                    farmDash.dashSummary(filter: SummaryType.sales),
                    farmDash.incomeBreakdown(),
                    farmDash.pnlBreakdown()
                  ]);
                }
              },
              child: ListView(
                padding: const EdgeInsets.all(SpacingConstants.size20),
                children: [
                  const QuickAction(),
                  const Ymargin(SpacingConstants.size20),
                  const OverviewFarmAssetCard(),
                  BillDetails(
                    months: (farmDash.salesSummaryData.paid + farmDash.salesSummaryData.upcoming)
                        .map((e) => e.month)
                        .toSet()
                        .toList(),
                    heading: moneyInText,
                    filter: SummaryType.sales,
                    summary: farmDash.salesSummaryData,
                  ),
                  const Ymargin(SpacingConstants.size20),
                  BillDetails(
                    months: (farmDash.purchaseSummaryData.paid + farmDash.purchaseSummaryData.upcoming)
                        .map((e) => e.month)
                        .toSet()
                        .toList(),
                    heading: moneyOutText,
                    filter: SummaryType.purchases,
                    summary: farmDash.purchaseSummaryData,
                  ),
                  const Ymargin(SpacingConstants.size20),
                  const FarmManagerExpBreakDown(),
                  const Ymargin(SpacingConstants.size20),
                  const ProfitLossChart(),
                  const Ymargin(SpacingConstants.size20),
                  const FarmManagerOtherActions()
                ],
              ),
            ),
    );
  }
}
