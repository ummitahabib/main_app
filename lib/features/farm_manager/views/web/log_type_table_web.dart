import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class LogTypeTableWeb extends HookConsumerWidget {
  const LogTypeTableWeb({
    super.key,
    required this.logList,
  });
  final List<LogDetailsResponse> logList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    return AppContainer(
      padding: EdgeInsets.zero,
      child: Table(
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
                      Pandora().reRouteUser(
                        context,
                        "${ConfigRoute.farmLogDetails}/${logList[index].log!.uuid}",
                        logList[index],
                      );
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
    );
  }
}
