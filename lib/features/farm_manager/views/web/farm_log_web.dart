import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmLogWeb extends HookConsumerWidget {
  const FarmLogWeb({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);

    final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;

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
    return Scaffold(
      appBar: customAppBar(
        context,
        title: farmLogText,
        center: false,
        onTap: () {
          context.beamToReplacementNamed(
            "${ConfigRoute.farmManagerOverview}/${path.last}",
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Builder(
          builder: (context) {
            if (shared.loading) {
              return const WrapLoader();
            }
            if (shared.logTypesList.isEmpty) {
              return const EmptyListWidget(
                text: noLogFound,
                asset: AppAssets.emptyImage,
              );
            }
            return Wrap(
              runSpacing: SpacingConstants.double20,
              spacing: SpacingConstants.double20,
              children: shared.logTypesList
                  .map(
                    (e) => AppMaterial(
                      width: !Responsive.isMobile(context)
                          ? Responsive.xWidth(
                              context,
                              percent: SpacingConstants.size0point35,
                            )
                          : null,
                      child: ListTile(
                        onTap: () {
                          shared.logType = e;
                          Pandora().reRouteUser(
                            context,
                            "${ConfigRoute.farmLogType}/${path.last}?logTypeName=${shared.logType!.types}",
                            e,
                          );
                        },
                        leading: SvgPicture.asset(AppAssets.sunshine),
                        minLeadingWidth: SpacingConstants.size10,
                        title: Text(e.types ?? emptyString),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
      ),
    );
  }
}
