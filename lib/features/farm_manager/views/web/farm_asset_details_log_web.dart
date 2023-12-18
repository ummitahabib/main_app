import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmAssetDetailLogsWeb extends HookConsumerWidget {
  const FarmAssetDetailLogsWeb({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments;
    useEffect(
      () {
        Future(() {
          if (shared.logTypesList.isEmpty) {
            shared.getLogTypes();
          }
        });
        return null;
      },
      [],
    );
    if (shared.loading) {
      return const WrapLoader(length: 12);
    }
    return Wrap(
      runSpacing: SpacingConstants.double20,
      spacing: SpacingConstants.double20,
      children: List.generate(
        shared.logTypesList.length,
        (index) => AppMaterial(
          width: !Responsive.isMobile(context)
              ? Responsive.xWidth(
                  context,
                  percent: SpacingConstants.size0point35,
                )
              : null,
          child: ListTile(
            leading: SvgPicture.asset(
              AppAssets.sunshine,
            ),
            minLeadingWidth: SpacingConstants.size10,
            title: Text(shared.logTypesList[index].types ?? emptyString),
            onTap: () {
              shared.logType = shared.logTypesList[index];
              ref.read(assetProvider).getAssetLogs(queries: {"logTypeName": shared.logType!.types, "pageSize": 30});
              // ref.read(logProvider).getOrgLogs(
              //   queries: {"logTypeName": shared.logType!.types, "pageSize": "30"},
              //   orgId: id.last,
              // );
              Pandora().reRouteUser(
                context,
                "${ConfigRoute.assetLogDetails}/${id.last}?logTypeName=${shared.logType!.types}",
                shared.logTypesList[index],
              );
            },
          ),
        ),
      ),
    );
  }
}
