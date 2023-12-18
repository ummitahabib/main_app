import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/web/log_type_table_web.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/load_more_indicator.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

var _page = 2;

class FullLogTableWeb extends HookConsumerWidget {
  const FullLogTableWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    final logController = ref.watch(logProvider);
    final controller = useScrollController();
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    final path = beamState.queryParameters;
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
            queries: {"logTypeName": path['logTypeName'], "logStatusName": path['logStatusName'], "pageSize": "30"},
            orgId: id.last,
            siteId: siteId,
          );
        });
        controller.addListener(() async {
          if (controller.position.atEdge) {
            final isTop = controller.position.pixels == 0;
            if (!isTop && !logController.loadMore) {
              final siteId = await Pandora().getFromSharedPreferences("siteId");
              await logController.getMoreOrgLogs(
                queries: {"logTypeName": path['logTypeName'], "logStatusName": path['logStatusName'], "page": _page},
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
      appBar: customAppBar(context, title: "${path['logStatusName'] ?? ""} Logs"),
      body: Builder(
        builder: (context) {
          if (logController.loading) {
            return const WrapLoader(length: 12);
          }
          if (logController.orgLogList.isEmpty) {
            return EmptyListWidget(
              text: "No ${path['logStatusName']} $noLogATMText",
              asset: AppAssets.emptyImage,
            );
          }
          return SingleChildScrollView(
            controller: controller,
            padding: const EdgeInsets.all(SpacingConstants.double20),
            child: Column(
              children: [
                LogTypeTableWeb(logList: logController.orgLogList),
                if (logController.loadMore) const LoadMoreIndicator()
              ],
            ),
          );
        },
      ),
    );
  }
}
