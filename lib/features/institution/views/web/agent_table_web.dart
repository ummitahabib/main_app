import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/views/load_more_indicator.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

var _page = 1;

class AgentTableWeb extends HookConsumerWidget {
  const AgentTableWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manager = ref.watch(farmManagerProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    final controller = useScrollController();

    useEffect(
      () {
        Future(() {
          manager.getAgents(orgId: id.last);
        });
        controller.addListener(() async {
          if (controller.position.atEdge) {
            final isTop = controller.position.pixels == 0;
            if (!isTop && !manager.loadMore) {
              await manager.getMoreAgents(orgId: id.last, page: _page);
              _page++;
            }
          }
        });
        return null;
      },
      [],
    );
    return HomeWebContainer(
      title: agentsText,
      trailingIcon: const SizedBox.shrink(),
      width: Responsive.xWidth(context),
      elevation: 1,
      child: SingleChildScrollView(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Builder(
              builder: (context) {
                if (manager.loading) {
                  return WrapLoader(length: SpacingConstants.font10.toInt());
                }
                if (manager.farmAgentList.isEmpty) {
                  return const EmptyListWidget(text: noAgentText, asset: AppAssets.emptyImage);
                }
                return Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  columnWidths: const {0: FixedColumnWidth(60), 3: FixedColumnWidth(130), 4: FixedColumnWidth(100)},
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
                              text: snText,
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
                              text: nameText,
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
                              text: email,
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
                              text: phoneNumberText,
                              fontSize: SpacingConstants.font14,
                            ),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(SpacingConstants.font10),
                            child: BoldHeaderText(
                              text: timeStampText,
                              fontSize: SpacingConstants.font14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      manager.farmAgentList.length,
                      (index) => TableRow(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          border: Border(bottom: BorderSide(color: AppColors.SmatCrowNeuBlue100)),
                        ),
                        children: [
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(SpacingConstants.font10),
                              child: Text(
                                "${index + 1}",
                                style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(SpacingConstants.font10),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: SpacingConstants.double20,
                                    height: SpacingConstants.double20,
                                    decoration: const BoxDecoration(
                                      color: AppColors.SmatCrowAccentBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      manager.farmAgentList[index].userDetails!.fullName![0],
                                      style: Styles.smatCrowSmallTextRegular(color: Colors.white),
                                    ),
                                  ),
                                  const Xmargin(SpacingConstants.size5),
                                  Flexible(
                                    child: Text(
                                      manager.farmAgentList[index].userDetails!.fullName ?? "",
                                      style: Styles.smatCrowSubParagraphRegular(
                                        color: AppColors.SmatCrowNeuBlue900,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(SpacingConstants.font10),
                              child: Text(
                                manager.farmAgentList[index].userDetails!.email ?? "",
                                style: Styles.smatCrowSubParagraphRegular(
                                  color: AppColors.SmatCrowNeuBlue900,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(SpacingConstants.font10),
                              child: Text(
                                manager.farmAgentList[index].userDetails!.phone ?? "",
                                style: Styles.smatCrowSubParagraphRegular(
                                  color: AppColors.SmatCrowNeuBlue900,
                                ),
                              ),
                            ),
                          ),
                          TableCell(
                            child: Padding(
                              padding: const EdgeInsets.all(SpacingConstants.font10),
                              child: Text(
                                DateFormat('MM-dd-yy').format(
                                  manager.farmAgentList[index].userTypes!.isEmpty
                                      ? DateTime.now()
                                      : manager.farmAgentList[index].userTypes!.first.modifiedDate ?? DateTime.now(),
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
                );
              },
            ),
            if (manager.loadMore) const LoadMoreIndicator()
          ],
        ),
      ),
    );
  }
}
