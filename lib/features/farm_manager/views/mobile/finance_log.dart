import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/head_down.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FinanceLogMobile extends HookConsumerWidget {
  const FinanceLogMobile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState<String?>(null);
    final shared = ref.watch(sharedProvider);
    final log = ref.watch(logProvider);
    final manager = ref.watch(farmManagerProvider);
    useEffect(
      () {
        Future(() {
          if (shared.flagList.isNotEmpty) {
            selected.value = shared.flagList.first.flag;
            log.getOrgLogs(queries: {"flagId": shared.flagList.first.uuid, "pageSize": "30"});
          } else {
            shared.getFlags();
          }
          if (shared.currencyList.isEmpty) {
            shared.getCurrencies();
          }
        });

        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(context, title: financeLogText),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.double20),
        child: Column(
          children: [
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...shared.flagList.map(
                    (e) => InkWell(
                      onTap: () {
                        selected.value = e.flag;
                        log.getOrgLogs(
                          queries: {
                            "flagId": shared.flagList
                                .firstWhere(
                                  (element) => element.flag == selected.value,
                                )
                                .uuid,
                            "pageSize": "30"
                          },
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SpacingConstants.size5),
                          color:
                              selected.value == e.flag ? AppColors.SmatCrowNeuBlue900 : AppColors.SmatCrowDefaultWhite,
                        ),
                        margin: const EdgeInsets.only(
                          right: SpacingConstants.font10,
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
                  )
                ],
              ),
            ),
            const Ymargin(SpacingConstants.double20),
            Builder(
              builder: (context) {
                if (log.loading) {
                  return const GridLoader(arrangement: 1);
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
                    columnWidths: const {0: FixedColumnWidth(150)},
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
                                  customDialogAndModal(
                                    context,
                                    SingleChildScrollView(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: SpacingConstants.double20,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const ModalStick(),
                                          const Ymargin(
                                            SpacingConstants.font10,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              BoldHeaderText(
                                                text: "${selected.value} $detailsText",
                                                fontSize: SpacingConstants.font24,
                                              ),
                                              if (manager.agentOrg != null &&
                                                  manager.agentOrg!.permissions!.contains(
                                                    FarmManagerPermissions.updateLog,
                                                  ))
                                                InkWell(
                                                  onTap: () {
                                                    log.logResponse = log.orgLogList[index];
                                                    Pandora().reRouteUser(
                                                      context,
                                                      ConfigRoute.registerFarmLog,
                                                      log.orgLogList[index],
                                                    );
                                                  },
                                                  child: SvgPicture.asset(
                                                    AppAssets.edit,
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const Ymargin(
                                            SpacingConstants.double20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              HeadDownWidget(
                                                head: amountText,
                                                down: shared.currencyList.isNotEmpty
                                                    ? "${shared.currencyList.firstWhere(
                                                          (element) =>
                                                              element.name == log.orgLogList[index].log!.currency,
                                                        ).code!} ${Pandora().newMoneyFormat(log.orgLogList[index].log!.cost ?? 0.0)}"
                                                    : "NGN ${Pandora().newMoneyFormat(log.orgLogList[index].log!.cost ?? 0.0)}",
                                              ),
                                              HeadDownWidget(
                                                head: dateText,
                                                down: DateFormat('dd-MM-yy').format(
                                                  log.orgLogList[index].log!.startDate ?? DateTime.now(),
                                                ),
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                          const Ymargin(
                                            SpacingConstants.double20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              HeadDownWidget(
                                                head: farmingSeasonText,
                                                down: "${ref.watch(sharedProvider).season!.description}",
                                              ),
                                              HeadDownWidget(
                                                head: timeText,
                                                down: TimeOfDay.fromDateTime(
                                                  log.orgLogList[index].log!.startTime!.toLocal(),
                                                ).format(context),
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                          const Ymargin(
                                            SpacingConstants.double20,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              HeadDownWidget(
                                                head: approvedText,
                                                down: log.orgLogList[index].log!.readyForApproval == "Y"
                                                    ? trueText
                                                    : falseText,
                                              ),
                                              HeadDownWidget(
                                                head: tagText,
                                                down: (log.orgLogList[index].log!.logFlags!.isNotEmpty &&
                                                        ref
                                                            .watch(
                                                              sharedProvider,
                                                            )
                                                            .flagList
                                                            .isNotEmpty)
                                                    ? ref
                                                        .watch(sharedProvider)
                                                        .flagList
                                                        .firstWhere(
                                                          (element) =>
                                                              element.uuid ==
                                                              log.orgLogList[index].log!.logFlags!.first,
                                                          orElse: () => ref
                                                              .watch(
                                                                sharedProvider,
                                                              )
                                                              .flagList
                                                              .first,
                                                        )
                                                        .flag
                                                    : null,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                              ),
                                            ],
                                          ),
                                          const Ymargin(
                                            SpacingConstants.double20,
                                          ),
                                          HeadDownWidget(
                                            head: noteText,
                                            down: log.orgLogList[index].log!.notes,
                                          ),
                                          const Ymargin(
                                            SpacingConstants.double20,
                                          ),
                                          if (log.orgLogList[index].log!.readyForApproval != "Y" &&
                                              log.orgLogList[index].log!.publishedBy == null)
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: CustomButton(
                                                    text: rejectText,
                                                    loading: ref.watch(logProvider).loading,
                                                    leftIcon: Icons.delete_outline_outlined,
                                                    color: AppColors.SmatCrowRed500,
                                                    textColor: Colors.white,
                                                    iconColor: Colors.white,
                                                    onPressed: () {
                                                      ref
                                                          .read(logProvider)
                                                          .publishLog(log.orgLogList[index].log!.uuid!)
                                                          .then((value) {
                                                        if (value) {
                                                          if (Responsive.isTablet(context)) {
                                                            OneContext().popDialog();
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                                const Xmargin(
                                                  SpacingConstants.double20,
                                                ),
                                                Expanded(
                                                  child: CustomButton(
                                                    text: approvedText,
                                                    loading: ref.watch(logProvider).loading,
                                                    leftIcon: Icons.check,
                                                    onPressed: () {
                                                      ref
                                                          .read(logProvider)
                                                          .publishLog(log.orgLogList[index].log!.uuid!)
                                                          .then((value) {
                                                        if (value) {
                                                          if (Responsive.isTablet(context)) {
                                                            OneContext().popDialog();
                                                            return;
                                                          }
                                                          Navigator.pop(context);
                                                        }
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const Ymargin(
                                            SpacingConstants.double20,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Responsive.isTablet(context),
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
                                            ).code!} ${Pandora().newMoneyFormat(log.orgLogList[index].log!.cost ?? 0.0)}"
                                        : "NGN ${Pandora().newMoneyFormat(log.orgLogList[index].log!.cost ?? 0.0)}",
                                    style: Styles.smatCrowSubParagraphRegular(
                                      color: AppColors.SmatCrowNeuBlue900,
                                    ),
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
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
