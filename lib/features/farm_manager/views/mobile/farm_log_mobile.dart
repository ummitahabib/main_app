import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_material.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmLogMobile extends HookConsumerWidget {
  const FarmLogMobile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    final logController = ref.watch(logProvider);
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
      appBar: customAppBar(context, title: farmLogText),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Builder(
          builder: (context) {
            if (shared.loading) {
              return const Center(child: CupertinoActivityIndicator());
            }
            if (shared.logTypesList.isEmpty) {
              return const EmptyListWidget(
                text: noLogFound,
                asset: AppAssets.emptyImage,
              );
            }
            return Column(
              children: shared.logTypesList
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(
                        bottom: SpacingConstants.font16,
                      ),
                      child: InkWell(
                        onTap: () {
                          shared.logType = e;
                          logController.getOrgLogs(
                            queries: {"logTypeName": shared.logType!.types, "pageSize": "30"},
                          );
                          Pandora().reRouteUser(context, ConfigRoute.farmLogType, e);
                        },
                        child: AppMaterial(
                          child: ListTile(
                            leading: SvgPicture.asset(
                              AppAssets.sunshine,
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                            minLeadingWidth: SpacingConstants.size10,
                            title: Text(e.types ?? emptyString),
                          ),
                        ),
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
