import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_log_details.dart';
import 'package:smat_crow/features/institution/views/widgets/farm_log_table.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class InstutionFarmLog extends HookConsumerWidget {
  const InstutionFarmLog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = usePageController();
    final shared = ref.watch(sharedProvider);
    final logController = ref.watch(logProvider);

    final logTitle = useState("");
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: controller,
      children: [
        HomeWebContainer(
          title: "${shared.logType != null ? (shared.logType!.types ?? emptyString) : ""} Log",
          trailingIcon: const SizedBox.shrink(),
          width: Responsive.xWidth(context),
          elevation: 1,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SpacingConstants.double20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FarmLogTableWeb(
                  color: AppColors.SmatCrowGreen500,
                  text: "COMPLETED",
                  title: logTitle,
                  controller: controller,
                  log: logController.orgLogList,
                ),
                FarmLogTableWeb(
                  color: AppColors.SmatCrowPrimary500,
                  text: "ONGOING",
                  title: logTitle,
                  log: logController.orgLogList,
                  controller: controller,
                ),
                FarmLogTableWeb(
                  color: AppColors.SmatCrowAccentPurple,
                  text: "UPCOMING",
                  title: logTitle,
                  log: logController.orgLogList,
                  controller: controller,
                ),
                FarmLogTableWeb(
                  color: AppColors.SmatCrowAccentBlue,
                  text: "MISSED",
                  title: logTitle,
                  log: logController.orgLogList,
                  controller: controller,
                ),
              ],
            ),
          ),
        ),
        HomeWebContainer(
          title: "${logTitle.value} LOGS",
          trailingIcon: const SizedBox.shrink(),
          width: Responsive.xWidth(context),
          elevation: 1,
          leadingCallback: () => controller.previousPage(
            duration: const Duration(milliseconds: SpacingConstants.int400),
            curve: Curves.easeIn,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SpacingConstants.double20),
            child: FarmLogTableWeb(
              color: AppColors.SmatCrowGreen500,
              text: logTitle.value.toUpperCase(),
              title: logTitle,
              log: logController.orgLogList,
              controller: controller,
            ),
          ),
        ),
        HomeWebContainer(
          title: "${shared.logType != null ? (shared.logType!.types ?? emptyString) : ""} Log",
          trailingIcon: const SizedBox.shrink(),
          width: Responsive.xWidth(context),
          elevation: 1,
          leadingCallback: () => controller.previousPage(
            duration: const Duration(milliseconds: SpacingConstants.int400),
            curve: Curves.easeIn,
          ),
          child: const SingleChildScrollView(
            padding: EdgeInsets.all(SpacingConstants.double20),
            child: FarmLogDetails(),
          ),
        ),
      ],
    );
  }
}
