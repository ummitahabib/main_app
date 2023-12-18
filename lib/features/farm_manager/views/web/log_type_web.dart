import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/register_asset.dart';
import 'package:smat_crow/features/institution/views/widgets/log_table.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class LogTypeWeb extends HookConsumerWidget {
  const LogTypeWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    final logController = ref.watch(logProvider);
    final manager = ref.watch(farmManagerProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    final path = beamState.queryParameters;
    useEffect(
      () {
        Future(() async {
          final siteId = await Pandora().getFromSharedPreferences("siteId");
          await logController.getOrgLogs(
            queries: {"logTypeName": path['logTypeName'], "pageSize": "30"},
            orgId: id.last,
            siteId: siteId,
          );
          if (shared.logStatusList.isEmpty) {
            await shared.getLogStatus();
          }
          if (shared.currencyList.isEmpty) {
            await shared.getCurrencies();
          }
          if (shared.flagList.isEmpty) {
            await shared.getFlags(orgId: id.last);
          }
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(
        context,
        onTap: () {
          context.beamToReplacementNamed("${ConfigRoute.farmLog}/${id.last}");
        },
        title: path['logTypeName'] ?? "",
        actions: (manager.agentOrg != null && manager.agentOrg!.permissions!.contains(FarmManagerPermissions.createLog))
            ? [
                IconButton(
                  onPressed: () {
                    logController.logResponse = null;
                    Pandora().reRouteUser(
                      context,
                      ConfigRoute.registerFarmLog,
                      emptyString,
                    );
                  },
                  splashRadius: SpacingConstants.double20,
                  icon: const Icon(
                    Icons.add,
                    color: AppColors.SmatCrowPrimary500,
                  ),
                )
              ]
            : [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Builder(
          builder: (context) {
            if (logController.loading) {
              return const WrapLoader(length: 10);
            }
            if (logController.orgLogList.isEmpty) {
              return EmptyListWidget(
                text: "No ${path['logTypeName']} $noLogATMText",
                asset: AppAssets.emptyImage,
              );
            }
            return Column(
              children: [
                LogTable(
                  text: completedText,
                  log: logController.orgLogList,
                  color: dummyAssetStatusList
                      .firstWhere(
                        (element) => element.name == completedText,
                        orElse: () => dummyAssetStatusList.last,
                      )
                      .color,
                ),
                LogTable(
                  text: ongoingText,
                  log: logController.orgLogList,
                  color: dummyAssetStatusList
                      .firstWhere(
                        (element) => element.name == ongoingText,
                        orElse: () => dummyAssetStatusList.last,
                      )
                      .color,
                ),
                LogTable(
                  text: upcomingText,
                  log: logController.orgLogList,
                  color: dummyAssetStatusList
                      .firstWhere(
                        (element) => element.name == upcomingText,
                        orElse: () => dummyAssetStatusList.last,
                      )
                      .color,
                ),
                LogTable(
                  text: missedText,
                  log: logController.orgLogList,
                  color: dummyAssetStatusList
                      .firstWhere(
                        (element) => element.name == missedText,
                        orElse: () => dummyAssetStatusList.last,
                      )
                      .color,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
