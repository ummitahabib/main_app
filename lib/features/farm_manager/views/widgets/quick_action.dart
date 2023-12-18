import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/main.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/farm_action.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class QuickAction extends HookConsumerWidget {
  const QuickAction({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      width: Responsive.isMobile(context)
          ? Responsive.xWidth(context)
          : Responsive.xWidth(context, percent: SpacingConstants.size0point4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BoldHeaderText(
            text: quickActionText,
          ),
          const Ymargin(SpacingConstants.size20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FarmAction(
                asset: AppAssets.farmAsset,
                callback: () {
                  if (kIsWeb) {
                    final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;
                    Pandora().reRouteUser(context, "${ConfigRoute.farmAsset}/${path.last}", path.last);
                  } else {
                    Pandora().reRouteUser(navigatorKey.currentState!.context, ConfigRoute.farmAsset, "args");
                  }
                },
                name: farmAssetText,
              ),
              FarmAction(
                asset: AppAssets.farmLog,
                callback: () {
                  if (kIsWeb) {
                    final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;

                    Pandora().reRouteUser(context, "${ConfigRoute.farmLog}/${path.last}", path.last);
                  } else {
                    Pandora().reRouteUser(navigatorKey.currentState!.context, ConfigRoute.farmLog, "args");
                  }
                },
                name: farmLogText,
              ),
              FarmAction(
                asset: AppAssets.financeLog,
                callback: () {
                  if (kIsWeb) {
                    final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;
                    Pandora().reRouteUser(context, "${ConfigRoute.financeLog}/${path.last}", path.last);
                  } else {
                    Pandora().reRouteUser(navigatorKey.currentState!.context, ConfigRoute.financeLog, "args");
                  }
                },
                name: financeLogText,
              ),
              if (ref.watch(farmManagerProvider).getAgentUserType() != AgentTypeEnum.field)
                FarmAction(
                  asset: AppAssets.farmAgent,
                  callback: () {
                    if (kIsWeb) {
                      final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;
                      Pandora().reRouteUser(context, "${ConfigRoute.farmAgent}/${path.last}", path.last);
                    } else {
                      Pandora().reRouteUser(navigatorKey.currentState!.context, ConfigRoute.farmAgent, "args");
                    }
                  },
                  name: agentsText,
                )
              else
                Container(width: SpacingConstants.double20)
            ],
          ),
        ],
      ),
    );
  }
}
