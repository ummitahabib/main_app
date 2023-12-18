import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/web/log_type_table_web.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/load_more_indicator.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

var _page = 2;

class AssetLogDetailsWeb extends HookConsumerWidget {
  const AssetLogDetailsWeb({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState("");
    final shared = ref.watch(sharedProvider);
    final logController = ref.watch(logProvider);

    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    final path = beamState.queryParameters;
    final controller = useScrollController();
    useEffect(
      () {
        Future(() async {
          if (shared.logStatusList.isEmpty) {
            await shared.getLogStatus();
          }
          if (shared.currencyList.isEmpty) {
            await shared.getCurrencies();
          }
          if (shared.flagList.isEmpty) {
            await shared.getFlags(orgId: id.last);
          }
          final siteId = await Pandora().getFromSharedPreferences("siteId");
          await logController.getOrgLogs(
            queries: {"logTypeName": path['logTypeName'], "pageSize": "30"},
            orgId: id.last,
            siteId: siteId,
          );
          if (logController.orgLogList.isNotEmpty) {
            selected.value = logController.orgLogList.first.log!.status ?? "";
          }
        });
        controller.addListener(() async {
          if (controller.position.atEdge) {
            final isTop = controller.position.pixels == 0;
            if (!isTop && !logController.loadMore) {
              final siteId = await Pandora().getFromSharedPreferences("siteId");
              await logController.getMoreOrgLogs(
                queries: {"logTypeName": path['logTypeName'], 'page': _page},
                orgId: id.last,
                siteId: siteId,
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
      appBar: customAppBar(context, title: logDetailsText, center: false),
      body: SingleChildScrollView(
        controller: controller,
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                BoldHeaderText(
                  text: "${path['logTypeName'] ?? ""} Log",
                  fontSize: SpacingConstants.font24,
                ),
                const Spacer(),
                CustomButton(
                  text: addLogText,
                  onPressed: () {
                    Pandora().reRouteUser(
                      context,
                      ConfigRoute.registerFarmLog,
                      "args",
                    );
                  },
                  leftIcon: Icons.add,
                  width: SpacingConstants.size140,
                  height: SpacingConstants.size40,
                )
              ],
            ),
            const Ymargin(SpacingConstants.double20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...shared.logStatusList.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(right: SpacingConstants.font10),
                    child: InkWell(
                      onTap: () async {
                        selected.value = e.status ?? "";
                        final siteId = await Pandora().getFromSharedPreferences("siteId");
                        await logController.getOrgLogs(
                          queries: {
                            "logTypeName": path['logTypeName'],
                            "logStatusName": selected.value,
                            "pageSize": "30"
                          },
                          orgId: id.last,
                          siteId: siteId,
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SpacingConstants.size5),
                          color:
                              selected.value == e.status ? AppColors.SmatCrowNeuBlue900 : AppColors.SmatCrowNeuBlue100,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpacingConstants.font10,
                          vertical: SpacingConstants.font10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              e.status ?? emptyString,
                              style: Styles.smatCrowSubParagraphRegular(
                                color: selected.value == e.status
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
            const Ymargin(SpacingConstants.double20),
            Builder(
              builder: (context) {
                if (logController.loading) {
                  return const WrapLoader();
                }
                if (logController.orgLogList.isEmpty) {
                  return const AppContainer(
                    width: double.maxFinite,
                    color: AppColors.SmatCrowGrayScaleLabel,
                    child: Text(noLogFound),
                  );
                }
                return LogTypeTableWeb(logList: logController.orgLogList);
              },
            ),
            if (logController.loadMore) const LoadMoreIndicator()
          ],
        ),
      ),
    );
  }
}
