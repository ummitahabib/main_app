import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
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
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FinanceDashMobile extends StatefulHookConsumerWidget {
  const FinanceDashMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmOverviewMobileState();
}

class _FarmOverviewMobileState extends ConsumerState<FinanceDashMobile> {
  @override
  Widget build(BuildContext context) {
    final farmDash = ref.watch(farmDashProvider);
    final shared = ref.watch(sharedProvider);
    final asset = ref.watch(assetProvider);
    useEffect(
      () {
        Future(() {
          if (shared.seasonList.isEmpty) {
            shared.getSeasons();
          }
          asset.getOrgAssets();
        });

        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(
        context,
        center: false,
        title: financeDashText,
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
              Future.wait([
                farmDash.dashSummary(),
                farmDash.dashSummary(filter: SummaryType.sales),
                farmDash.incomeBreakdown(),
                farmDash.pnlBreakdown()
              ]);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.size20),
        child: Responsive.isTablet(context)
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
