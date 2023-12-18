import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bill_details.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/expenses_breakdown.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/profit_loss_chart.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/icons.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FinanceDashWeb extends HookConsumerWidget {
  const FinanceDashWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmDash = ref.watch(farmDashProvider);
    final shared = ref.watch(sharedProvider);
    final asset = ref.watch(assetProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    useEffect(
      () {
        Future(() {
          if (shared.seasonList.isEmpty) {
            shared.getSeasons();
          }
          asset.getOrgAssets(orgId: id.last);
        });

        return null;
      },
      [],
    );
    return HomeWebContainer(
      title: financeDashText,
      elevation: 1,
      trailingIcon: SizedBox(
        height: SpacingConstants.size30,
        width: SpacingConstants.size160,
        child: PopupMenuButton(
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
              farmDash.dashSummary(orgId: id.last),
              farmDash.dashSummary(filter: SummaryType.sales, orgId: id.last),
              farmDash.incomeBreakdown(orgId: id.last),
              farmDash.pnlBreakdown(orgId: id.last)
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
      ),
      width: Responsive.xWidth(context),
      addSpacing: true,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: SpacingConstants.size40,
          right: SpacingConstants.size40,
          top: SpacingConstants.size20,
        ),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BillDetails(
                    months: (farmDash.salesSummaryData.paid + farmDash.salesSummaryData.upcoming)
                        .map((e) => e.month)
                        .toSet()
                        .toList(),
                    heading: moneyInText,
                    summary: farmDash.salesSummaryData,
                    filter: SummaryType.sales,
                  ),
                ),
                const Xmargin(SpacingConstants.size20),
                Expanded(
                  child: BillDetails(
                    months: (farmDash.purchaseSummaryData.paid + farmDash.purchaseSummaryData.upcoming)
                        .map((e) => e.month)
                        .toSet()
                        .toList(),
                    summary: farmDash.purchaseSummaryData,
                    heading: moneyOutText,
                    filter: SummaryType.purchases,
                  ),
                ),
              ],
            ),
            const Ymargin(SpacingConstants.size20),
            const FarmManagerExpBreakDown(showBudget: false),
            const Ymargin(SpacingConstants.size20),
            const ProfitLossChart(),
            const Ymargin(SpacingConstants.size20),
          ],
        ),
      ),
    );
  }
}
