import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/top_down_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmManagerStats extends HookConsumerWidget {
  const FarmManagerStats({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmDash = ref.watch(farmDashProvider);
    useEffect(
      () {
        Future(() async {
          if (farmDash.dashStatList.isEmpty) {
            await farmDash.getDashStats();
          }
        });
        return null;
      },
      [],
    );
    return Builder(
      builder: (context) {
        if (farmDash.loading) {
          return GridLoader(arrangement: Responsive.isMobile(context) ? 2 : 3);
        }
        if (farmDash.dashStatList.isEmpty) {
          return const Center(
            child: EmptyListWidget(text: "No Stats at the moment"),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const BoldHeaderText(text: statisticsText),
            customSizedBoxHeight(SpacingConstants.size20),
            Wrap(
              runSpacing: SpacingConstants.size10,
              spacing: SpacingConstants.size10,
              children: [
                ...farmDash.dashStatList.map(
                  (e) => GestureDetector(
                    onTap: () {
                      if (e.statisticName == "Total Pending Institution Invitations") {
                        Pandora().reRouteUser(context, ConfigRoute.pendingInvites, "args");
                      }
                    },
                    child: AppContainer(
                      width: Responsive.isDesktop(context)
                          ? Responsive.xWidth(context, percent: 0.22)
                          : Responsive.xWidth(context, percent: 0.43),
                      child: TopDownText(
                        top: e.statisticName,
                        down: e.statisticCount.toString(),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
