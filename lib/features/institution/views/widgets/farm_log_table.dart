import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/colored_container.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';

import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmLogTableWeb extends HookConsumerWidget {
  const FarmLogTableWeb({
    super.key,
    required this.color,
    required this.text,
    required this.controller,
    required this.title,
    required this.log,
  });

  final Color color;
  final String text;
  final PageController controller;
  final ValueNotifier<String> title;
  final List<LogDetailsResponse> log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    final logList = log.where((element) => element.log!.status!.toLowerCase() == text.toLowerCase()).toList();
    if (ref.watch(logProvider).loading) {
      return const GridLoader();
    }
    if (logList.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (text.isNotEmpty)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColoredContainer(color: color, text: text, verticalPadding: SpacingConstants.font10),
              InkWell(
                onTap: () {
                  controller.animateToPage(
                    1,
                    duration: const Duration(milliseconds: SpacingConstants.int400),
                    curve: Curves.easeIn,
                  );
                  title.value = text;
                },
                child: Text(
                  viewAllText,
                  style: Styles.smatCrowSubRegularUnderline(color: AppColors.SmatCrowNeuBlue500),
                ),
              )
            ],
          ),
        if (text.isNotEmpty) const Ymargin(SpacingConstants.double20),
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            const TableRow(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
              ),
              children: [
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpacingConstants.double20,
                      vertical: SpacingConstants.font10,
                    ),
                    child: BoldHeaderText(
                      text: logNameText,
                      fontSize: SpacingConstants.font14,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpacingConstants.double20,
                      vertical: SpacingConstants.font10,
                    ),
                    child: BoldHeaderText(
                      text: timeStampText,
                      fontSize: SpacingConstants.font14,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpacingConstants.double20,
                      vertical: SpacingConstants.font10,
                    ),
                    child: BoldHeaderText(
                      text: costText,
                      fontSize: SpacingConstants.font14,
                    ),
                  ),
                ),
                TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpacingConstants.double20,
                      vertical: SpacingConstants.font10,
                    ),
                    child: BoldHeaderText(
                      text: logFlagText,
                      fontSize: SpacingConstants.font14,
                    ),
                  ),
                ),
              ],
            ),
            ...List.generate(
              logList.length,
              (index) => TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
                ),
                children: [
                  TableCell(
                    child: InkWell(
                      onTap: () {
                        ref.read(logProvider).logResponse = logList[index];
                        title.value = text;
                        controller.jumpToPage(2);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpacingConstants.double20,
                          vertical: SpacingConstants.font10,
                        ),
                        child: Text(
                          logList[index].log!.name ?? "",
                          style: Styles.smatCrowSubRegularUnderline(
                            color: AppColors.SmatCrowGrayLabel,
                          ),
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingConstants.double20,
                        vertical: SpacingConstants.font10,
                      ),
                      child: Text(
                        DateFormat('MM-dd-yy').format(logList[index].log!.createdDate ?? DateTime.now()),
                        style: Styles.smatCrowSubParagraphRegular(
                          color: AppColors.SmatCrowNeuBlue900,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingConstants.double20,
                        vertical: SpacingConstants.font10,
                      ),
                      child: Text(
                        ((shared.currencyList.isNotEmpty)
                                ? shared.currencyList
                                        .firstWhere(
                                          (element) => element.name == logList[index].log!.currency,
                                        )
                                        .code ??
                                    ""
                                : "") +
                            Pandora().newMoneyFormat(logList[index].log!.cost ?? 0),
                        style: Styles.smatCrowSubParagraphRegular(
                          color: AppColors.SmatCrowNeuBlue900,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingConstants.double20,
                        vertical: SpacingConstants.font10,
                      ),
                      child: Text(
                        (logList[index].log!.logFlags!.isNotEmpty && shared.flagList.isNotEmpty)
                            ? shared.flagList
                                    .firstWhere(
                                      (element) => element.uuid == logList[index].log!.logFlags!.first,
                                      orElse: () => shared.flagList.first,
                                    )
                                    .flag ??
                                ""
                            : "null",
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
        const Ymargin(SpacingConstants.size50),
      ],
    );
  }
}
