import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/load_more_indicator.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

var _page = 2;

class FinanceLogWeb extends HookConsumerWidget {
  const FinanceLogWeb({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState<String?>(null);
    final shared = ref.watch(sharedProvider);
    final log = ref.watch(logProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    final controller = useScrollController();
    useEffect(
      () {
        Future(() async {
          final siteId = await Pandora().getFromSharedPreferences("siteId");
          await shared.getFlags(orgId: id.last);
          if (shared.flagList.isNotEmpty) {
            selected.value = shared.flagList.first.flag;
            await log.getOrgLogs(
              queries: {"flagId": shared.flagList.first.uuid, "pageSize": "30"},
              siteId: siteId,
              orgId: id.last,
            );
          }
          if (shared.currencyList.isEmpty) {
            await shared.getCurrencies();
          }
          if (shared.seasonList.isEmpty) {
            await shared.getSeasons();
          }
        });
        controller.addListener(() async {
          if (controller.position.atEdge) {
            final isTop = controller.position.pixels == 0;
            if (!isTop && !log.loadMore) {
              final siteId = await Pandora().getFromSharedPreferences("siteId");
              await log.getMoreOrgLogs(
                queries: {"flagId": selected.value, "page": _page, "pageSize": "30"},
                siteId: siteId,
                orgId: id.last,
              );
              _page++;
            }
          }
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(
        context,
        title: financeLogText,
        onTap: () {
          context.beamToReplacementNamed(
            "${ConfigRoute.farmManagerOverview}/${id.last}",
          );
        },
      ),
      body: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.double20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...shared.flagList.map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: SpacingConstants.font10),
                      child: InkWell(
                        onTap: () async {
                          selected.value = e.flag;
                          final siteId = await Pandora().getFromSharedPreferences("siteId");
                          await log.getOrgLogs(
                            queries: {
                              "flagId": shared.flagList
                                  .firstWhere(
                                    (element) => element.flag == selected.value,
                                  )
                                  .uuid,
                              "pageSize": "30"
                            },
                            siteId: siteId,
                            orgId: id.last,
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(SpacingConstants.size5),
                            color: selected.value == e.flag
                                ? AppColors.SmatCrowNeuBlue900
                                : AppColors.SmatCrowDefaultWhite,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: SpacingConstants.font10,
                            vertical: SpacingConstants.font10,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                e.flag ?? emptyString,
                                style: Styles.smatCrowSubParagraphRegular(
                                  color: selected.value == e.flag
                                      ? AppColors.SmatCrowNeuBlue100
                                      : AppColors.SmatCrowNeuBlue900,
                                ).copyWith(fontSize: SpacingConstants.font12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Ymargin(SpacingConstants.double20),
            Builder(
              builder: (context) {
                if (log.loading) {
                  return WrapLoader(length: SpacingConstants.size10.toInt());
                }
                if (log.orgLogList.isEmpty) {
                  return const EmptyListWidget(
                    text: noFinanceLogText,
                    asset: AppAssets.emptyImage,
                  );
                }
                return AppContainer(
                  padding: EdgeInsets.zero,
                  child: Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.SmatCrowNeuBlue100,
                            ),
                          ),
                        ),
                        children: [
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SpacingConstants.font10,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: amountText,
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SpacingConstants.font10,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: timeText,
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SpacingConstants.font10,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: dateText,
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                          TableCell(
                            verticalAlignment: TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: SpacingConstants.font10,
                                vertical: SpacingConstants.font10,
                              ),
                              child: BoldHeaderText(
                                text: farmingSeasonText,
                                fontSize: SpacingConstants.font14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...List.generate(
                        log.orgLogList.length,
                        (index) => TableRow(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            border: Border(
                              bottom: BorderSide(
                                color: AppColors.SmatCrowNeuBlue100,
                              ),
                            ),
                          ),
                          children: [
                            TableCell(
                              child: InkWell(
                                onTap: () {
                                  ref.read(logProvider).logResponse = log.orgLogList[index];
                                  Pandora().reRouteUser(
                                    context,
                                    "${ConfigRoute.financeLogDetails}/${log.orgLogList[index].log!.uuid}",
                                    log.orgLogList[index],
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: SpacingConstants.font10,
                                    vertical: SpacingConstants.font10,
                                  ),
                                  child: Text(
                                    shared.currencyList.isNotEmpty
                                        ? "${shared.currencyList.firstWhere(
                                              (element) => element.name == log.orgLogList[index].log!.currency,
                                            ).symbol ?? "NGN"} ${Pandora().newMoneyFormat(log.orgLogList[index].log!.cost ?? 0.0)}"
                                        : "NGN ${Pandora().newMoneyFormat(log.orgLogList[index].log!.cost ?? 0.0)}",
                                    style: Styles.smatCrowSubParagraphRegular(
                                      color: AppColors.SmatCrowNeuBlue900,
                                    ).copyWith(fontFamily: arialFont),
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.font10,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: Text(
                                  TimeOfDay.fromDateTime(
                                    (log.orgLogList[index].log!.startTime ?? DateTime.now()).toLocal(),
                                  ).format(context),
                                  style: Styles.smatCrowSubParagraphRegular(
                                    color: AppColors.SmatCrowNeuBlue900,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.font10,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: Text(
                                  DateFormat('dd-MM-yy').format(
                                    log.orgLogList[index].log!.startDate ?? DateTime.now(),
                                  ),
                                  style: Styles.smatCrowSubParagraphRegular(
                                    color: AppColors.SmatCrowNeuBlue900,
                                  ),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: SpacingConstants.font10,
                                  vertical: SpacingConstants.font10,
                                ),
                                child: Text(
                                  "${ref.watch(sharedProvider).season!.description}",
                                  style: Styles.smatCrowSubParagraphRegular(
                                    color: AppColors.SmatCrowNeuBlue900,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
            if (log.loadMore) const LoadMoreIndicator()
          ],
        ),
      ),
    );
  }
}
