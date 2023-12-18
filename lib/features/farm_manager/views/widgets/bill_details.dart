import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/data/model/dash_summary.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/top_down_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/tap_card.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class BillDetails extends HookConsumerWidget {
  const BillDetails({
    super.key,
    required this.months,
    required this.heading,
    required this.filter,
    required this.summary,
  });

  final List<String> months;
  final String heading;
  final SummaryType filter;
  final DashSummary summary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(farmManagerProvider).getAgentUserType() == AgentTypeEnum.field) {
      return const SizedBox.shrink();
    }

    final selectedIndex = useState<int>(0);
    final farmDash = ref.watch(farmDashProvider);

    useEffect(
      () {
        Future(() {
          if (kIsWeb) {
            final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
            final id = beamState.pathPatternSegments;
            farmDash.dashSummary(filter: filter, orgId: id.last);
          } else {
            farmDash.dashSummary(filter: filter);
          }
        });
        return null;
      },
      [],
    );

    var paidAmount = 0.0;
    var upcomingAmount = 0.0;
    var upcomingTypeList = <DashType>[];
    var paidTypeList = <DashType>[];
    void calculateAmount(String month) {
      if (summary.upcoming.isNotEmpty && month != "month") {
        upcomingAmount = summary.upcoming
            .firstWhere(
              (element) => month == element.month,
            )
            .types
            .map<double>((e) => e.sum)
            .fold<double>(0, (previousValue, element) => previousValue + element);
        upcomingTypeList = summary.upcoming
            .firstWhere(
              (element) => month == element.month,
            )
            .types;
      }
      if (summary.paid.isNotEmpty && month != "month") {
        paidAmount = summary.paid
            .firstWhere(
              (element) => month == element.month,
            )
            .types
            .map<double>((e) => e.sum)
            .fold<double>(0, (previousValue, element) => previousValue + element);
        paidTypeList = summary.paid
            .firstWhere(
              (element) => month == element.month,
            )
            .types;
      }
    }

    if (filter == SummaryType.purchases) {
      calculateAmount(farmDash.currentPurchaseMonth);
    } else {
      calculateAmount(farmDash.currentSalesMonth);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              heading,
              style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
            ),
            const Xmargin(SpacingConstants.size5),
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.SmatCrowNeuBlue900,
              size: 16,
            )
          ],
        ),
        const Ymargin(SpacingConstants.font10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            BoldHeaderText(
              text: "₦${Pandora().newMoneyFormat(upcomingAmount + paidAmount)}",
              fontSize: SpacingConstants.font21,
              fontFamily: arialFont,
              color: AppColors.SmatCrowNeuBlue800,
            ),
            PopupMenuButton<String>(
              itemBuilder: (context) => months
                  .map(
                    (e) => PopupMenuItem(
                      value: e,
                      child: Text(e),
                    ),
                  )
                  .toList(),
              onSelected: (value) {
                if (filter == SummaryType.purchases) {
                  farmDash.currentPurchaseMonth = value;
                } else {
                  farmDash.currentSalesMonth = value;
                }
              },
              initialValue:
                  filter == SummaryType.purchases ? farmDash.currentPurchaseMonth : farmDash.currentSalesMonth,
              position: PopupMenuPosition.under,
              child: Row(
                children: [
                  Text(
                    filter == SummaryType.purchases ? farmDash.currentPurchaseMonth : farmDash.currentSalesMonth,
                    style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                  ),
                  const Xmargin(SpacingConstants.size5),
                  const Icon(Icons.keyboard_arrow_down)
                ],
              ),
            )
          ],
        ),
        const Ymargin(SpacingConstants.size10),
        AppMaterial(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: SpacingConstants.font14,
                  left: SpacingConstants.font14,
                  right: SpacingConstants.font14,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TopDownText(
                          top: upcomingText,
                          fontFamily: arialFont,
                          downFontSize: SpacingConstants.font16,
                          down: "₦${Pandora().newMoneyFormat(upcomingAmount)}",
                        ),
                        TopDownText(
                          top: paidText,
                          down: "₦${Pandora().newMoneyFormat(paidAmount)}",
                          crossAxisAlignment: CrossAxisAlignment.end,
                          fontFamily: arialFont,
                          downFontSize: SpacingConstants.font16,
                        ),
                      ],
                    ),
                    const Ymargin(SpacingConstants.size20),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(SpacingConstants.font10),
                      child: LinearProgressIndicator(
                        value: paidAmount != 0
                            ? upcomingAmount / (upcomingAmount + paidAmount)
                            : upcomingAmount / (upcomingAmount + 1),
                        backgroundColor: AppColors.SmatCrowNeuOrange400,
                        color: AppColors.SmatCrowNeuBlue100,
                        minHeight: SpacingConstants.font32,
                      ),
                    ),
                    const Ymargin(SpacingConstants.size20),
                    Container(
                      height: SpacingConstants.size32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(SpacingConstants.size8),
                        color: AppColors.SmatCrowNeuBlue100,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TapCard(
                              selectedIndex: selectedIndex.value,
                              tap: () {
                                selectedIndex.value = 0;
                              },
                              name: upcomingText,
                              index: 0,
                            ),
                          ),
                          Expanded(
                            child: TapCard(
                              selectedIndex: selectedIndex.value,
                              tap: () {
                                selectedIndex.value = 1;
                              },
                              name: paidText,
                              index: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (selectedIndex.value == 0)
                ...List.generate(
                  upcomingTypeList.length,
                  (index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.font14),
                        leading: BoldHeaderText(text: upcomingTypeList[index].type),
                        trailing: BoldHeaderText(
                          text: "₦${Pandora().newMoneyFormat(upcomingTypeList[index].sum)}",
                          fontFamily: arialFont,
                        ),
                        dense: true,
                      ),
                      if (index != upcomingTypeList.length - 1) const Divider() else const SizedBox.shrink(),
                    ],
                  ),
                ),
              if (selectedIndex.value == 1)
                ...List.generate(
                  paidTypeList.length,
                  (index) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.font14),
                        leading: BoldHeaderText(text: paidTypeList[index].type),
                        trailing: BoldHeaderText(
                          text: "₦${Pandora().newMoneyFormat(paidTypeList[index].sum)}",
                          fontFamily: arialFont,
                        ),
                        dense: true,
                      ),
                      if (index != paidTypeList.length - 1) const Divider() else const SizedBox.shrink(),
                    ],
                  ),
                ),
              const Ymargin(SpacingConstants.size20),
            ],
          ),
        ),
      ],
    );
  }
}
