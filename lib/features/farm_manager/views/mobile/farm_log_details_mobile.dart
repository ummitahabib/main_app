import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_log_details.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/permission_constant.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmLogDetailsMobile extends HookConsumerWidget {
  const FarmLogDetailsMobile({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final log = ref.watch(logProvider).logResponse;
    final manager = ref.watch(farmManagerProvider);
    return Scaffold(
      appBar: customAppBar(
        context,
        title: log!.log!.type ?? "",
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(SpacingConstants.double20),
        child: FarmLogDetails(),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          customModalSheet(
            context,
            HookConsumer(
              builder: (context, ref, child) {
                final thread = useTextEditingController();
                final logResp = ref.watch(logProvider).logResponse;
                if (logResp == null) {
                  return const Center(
                    child: Column(
                      children: [
                        EmptyListWidget(
                          text: "No Thread at the moment",
                          asset: AppAssets.emptyImage,
                        )
                      ],
                    ),
                  );
                }
                return SizedBox(
                  height: Responsive.yHeight(context, percent: 0.95),
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
                                Color600Text(
                                  text: 'To manage farm logs and get team members\nfeedback on time',
                                ),
                              ],
                            ),
                            IconButton(
                              splashRadius: SpacingConstants.double20,
                              onPressed: () {
                                Navigator.pop(context);
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: logResp.additionalInfo != null
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: logResp.additionalInfo!.logsThreads!
                                        .map(
                                          (e) => Padding(
                                            padding: const EdgeInsets.only(bottom: 10.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                                const Ymargin(SpacingConstants.size5),
                                                Color600Text(
                                                  text:
                                                      "Sent: ${DateFormat.Hm().format(e.createdDate ?? DateTime.now())}",
                                                )
                                              ],
                                            ),
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
                                FocusScope.of(context).unfocus();
                                if (thread.text.trim().isNotEmpty) {
                                  await ref.read(logProvider).addLogThread(
                                        thread.text,
                                        id: logResp.log!.uuid,
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
                      ),
                      SizedBox(height: MediaQuery.of(context).viewInsets.bottom)
                    ],
                  ),
                );
              },
            ),
          );
        },
        child: CircleAvatar(
          radius: SpacingConstants.size25,
          backgroundColor: AppColors.SmatCrowPrimary500,
          child: SvgPicture.asset(AppAssets.message),
        ),
      ),
    );
  }
}
