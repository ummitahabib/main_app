import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/model/log_details_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class LogTypeTableMobile extends HookConsumerWidget {
  const LogTypeTableMobile({
    super.key,
    required this.log,
  });
  final List<LogDetailsResponse> log;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                    horizontal: SpacingConstants.font10,
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
            ],
          ),
          ...List.generate(
            log.length,
            (index) => TableRow(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
              ),
              children: [
                TableCell(
                  child: InkWell(
                    onTap: () {
                      ref.read(logProvider).logResponse = log[index];
                      Pandora().reRouteUser(context, ConfigRoute.farmLogDetails, log[index]);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingConstants.font10,
                        vertical: SpacingConstants.font10,
                      ),
                      child: Text(
                        log[index].log!.name ?? "",
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
                      DateFormat('MM-dd-yy').format(log[index].log!.createdDate ?? DateTime.now()),
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
