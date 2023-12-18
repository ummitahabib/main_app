// ignore_for_file: use_build_context_synchronously

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_log_details.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class FarmLogDetailsWeb extends HookConsumerWidget {
  const FarmLogDetailsWeb({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logController = ref.watch(logProvider);
    final path = (context.currentBeamLocation.state as BeamState).uri.pathSegments;
    final thread = useTextEditingController();
    final orgId = useState<String?>(null);

    useEffect(
      () {
        Future(() async {
          await logController.getLogs(path.last);
          orgId.value = await Pandora().getFromSharedPreferences("orgId");
        });
        return null;
      },
      [],
    );
    final log = logController.logResponse;
    final manager = ref.watch(farmManagerProvider);
    if (logController.loading) {
      return const GridLoader();
    }
    if (log == null) {
      return const Scaffold(
        body: EmptyListWidget(text: noLogFound, asset: AppAssets.emptyImage),
      );
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: customAppBar(
        context,
        onTap: () async {
          context.beamToReplacementNamed(
            "${ConfigRoute.farmLogType}/$orgId?logTypeName=${log.log!.type}",
          );
        },
        title: log.log!.type ?? "",
        center: false,
        actions: [
          if (manager.agentOrg != null && manager.agentOrg!.permissions!.contains(FarmManagerPermissions.updateLog))
            InkWell(
              onTap: () {
                Pandora().reRouteUser(context, ConfigRoute.registerFarmLog, log.log);
              },
              child: SvgPicture.asset(AppAssets.edit),
            ),
          const Xmargin(SpacingConstants.double20)
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () {
          _scaffoldKey.currentState!.openEndDrawer();
        },
        child: CircleAvatar(
          radius: SpacingConstants.size25,
          backgroundColor: AppColors.SmatCrowPrimary500,
          child: SvgPicture.asset(AppAssets.message),
        ),
      ),
      endDrawer: Drawer(
        width: SpacingConstants.size600,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingConstants.double20,
                vertical: SpacingConstants.font10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BoldHeaderText(text: "Thread"),
                      Ymargin(SpacingConstants.size5),
                      Flexible(
                        child: Color600Text(
                          text: 'To manage farm logs and get team members feedback on time',
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    splashRadius: SpacingConstants.double20,
                    onPressed: () {
                      _scaffoldKey.currentState!.closeEndDrawer();
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: AppColors.SmatCrowNeuBlue500,
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: SizedBox(
                height: Responsive.yHeight(
                  context,
                  percent: SpacingConstants.size0point85,
                ),
                child: SingleChildScrollView(
                  child: log.additionalInfo != null
                      ? Column(
                          children: log.additionalInfo!.logsThreads!
                              .map(
                                (e) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: AppColors.SmatCrowNeuBlue100,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                            SpacingConstants.size8,
                                          ),
                                          topRight: Radius.circular(
                                            SpacingConstants.size8,
                                          ),
                                          bottomRight: Radius.circular(
                                            SpacingConstants.size8,
                                          ),
                                        ),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: SpacingConstants.font12,
                                        vertical: SpacingConstants.size6,
                                      ),
                                      child: Text(e.url ?? emptyString),
                                    ),
                                    const Ymargin(SpacingConstants.font10),
                                    Color600Text(
                                      text: "Sent: ${DateFormat.Hm().format(e.createdDate ?? DateTime.now())}",
                                    )
                                  ],
                                ),
                              )
                              .toList(),
                        )
                      : const Center(
                          child: Column(
                            children: [
                              EmptyListWidget(
                                text: "No Thread at the moment",
                                asset: AppAssets.emptyImage,
                              )
                            ],
                          ),
                        ),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: SpacingConstants.double20,
                vertical: SpacingConstants.font10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: "Send message",
                      text: "",
                      controller: thread,
                    ),
                  ),
                  const Xmargin(SpacingConstants.double20),
                  InkWell(
                    onTap: () async {
                      if (thread.text.trim().isNotEmpty) {
                        await ref.read(logProvider).addLogThread(
                              thread.text,
                              id: path.last,
                            );
                        thread.text = "";
                        thread.notifyListeners();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(SpacingConstants.font10),
                      decoration: BoxDecoration(
                        color: AppColors.SmatCrowPrimary500,
                        borderRadius: BorderRadius.circular(SpacingConstants.font10),
                      ),
                      child: ref.watch(logProvider).loadMore
                          ? const CircularProgressIndicator.adaptive()
                          : SvgPicture.asset(
                              AppAssets.invite,
                              color: AppColors.SmatCrowNeuBlue900,
                            ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(SpacingConstants.double20),
        child: FarmLogDetails(),
      ),
    );
  }
}
