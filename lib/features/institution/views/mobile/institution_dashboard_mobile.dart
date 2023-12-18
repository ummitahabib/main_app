import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/top_down_text.dart';
import 'package:smat_crow/features/institution/data/controller/side_navigation_provider.dart';
import 'package:smat_crow/features/institution/views/mobile/organization_table_mobile.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class InstitutionDashboardMobile extends HookConsumerWidget {
  const InstitutionDashboardMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmDash = ref.watch(farmDashProvider);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SpacingConstants.double20),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            runSpacing: kIsWeb ? SpacingConstants.size15 : SpacingConstants.size10,
            spacing: kIsWeb ? SpacingConstants.size15 : SpacingConstants.size10,
            children: [
              ...farmDash.dashStatList.map(
                (e) => AppContainer(
                  width: kIsWeb ? Responsive.xWidth(context, percent: 0.15) : Responsive.xWidth(context, percent: 0.43),
                  padding: const EdgeInsets.all(
                    SpacingConstants.double20,
                  ),
                  child: TopDownText(
                    top: e.statisticName,
                    down: e.statisticCount.toString(),
                    downFontSize: SpacingConstants.font18,
                  ),
                ),
              )
            ],
          ),
          const Ymargin(SpacingConstants.double20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BoldHeaderText(
                text: organizationText,
                fontSize: SpacingConstants.font18,
              ),
              InkWell(
                onTap: () {
                  ref.read(sideNavProvider).jumpToPage(1);
                  ref.read(sideNavProvider.notifier).pageController = PageController(initialPage: 1);
                },
                child: Text(
                  viewAllText,
                  style: Styles.smatCrowSubRegularUnderline(color: AppColors.SmatCrowNeuBlue500),
                ),
              )
            ],
          ),
          const Ymargin(SpacingConstants.double20),
          const OrganizationTableMobile()
        ],
      ),
    );
  }
}
