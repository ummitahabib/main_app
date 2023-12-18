import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/top_down_text.dart';
import 'package:smat_crow/features/institution/views/web/organization_table_web.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class InstitutionDashboardWeb extends HookConsumerWidget {
  const InstitutionDashboardWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmDash = ref.watch(farmDashProvider);
    // final path = (context.currentBeamLocation.state as BeamState).uri.path;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SpacingConstants.double20),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BoldHeaderText(text: dashboardText, fontSize: SpacingConstants.font24),
          const Ymargin(SpacingConstants.double20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Builder(
                  builder: (context) {
                    if (farmDash.loading) {
                      return GridLoader(arrangement: Responsive.isMobile(context) ? 2 : 3);
                    }
                    if (farmDash.dashStatList.isEmpty) {
                      return const Center(
                        child: EmptyListWidget(text: "No Stats at the moment", asset: AppAssets.emptyImage),
                      );
                    }
                    return Wrap(
                      runSpacing: kIsWeb ? SpacingConstants.size15 : SpacingConstants.size10,
                      spacing: kIsWeb ? SpacingConstants.size15 : SpacingConstants.size10,
                      children: [
                        ...farmDash.dashStatList.map(
                          (e) => AppContainer(
                            width: Responsive.isDesktop(context) ? 200 : Responsive.xWidth(context, percent: 0.43),
                            height: SpacingConstants.size112,
                            padding: const EdgeInsets.symmetric(
                              horizontal: SpacingConstants.double20,
                              vertical: SpacingConstants.font10,
                            ),
                            child: TopDownText(
                              top: e.statisticName,
                              down: e.statisticCount.toString(),
                              downFontSize: SpacingConstants.size28,
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              const Xmargin(SpacingConstants.double20),
              Container(
                padding: const EdgeInsets.all(SpacingConstants.double20),
                width: SpacingConstants.size217,
                decoration: BoxDecoration(
                  color: AppColors.SmatCrowNeuOrange100,
                  borderRadius: BorderRadius.circular(SpacingConstants.font10),
                  border: Border.all(color: AppColors.SmatCrowNeuOrange300),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BoldHeaderText(
                      text: discoverMore,
                      fontSize: SpacingConstants.font12,
                    ),
                    const Ymargin(SpacingConstants.font16),
                    SizedBox(
                      height: SpacingConstants.size88,
                      width: SpacingConstants.size88,
                      child: Image.asset(AppAssets.famer),
                    ),
                    const Ymargin(SpacingConstants.font16),
                    Text(
                      discoverMoreDetails,
                      style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue500),
                      maxLines: 4,
                    )
                  ],
                ),
              ),
            ],
          ),
          const Ymargin(SpacingConstants.double20),
          const BoldHeaderText(
            text: organizationText,
            fontSize: SpacingConstants.font24,
          ),
          const Ymargin(SpacingConstants.double20),
          const OrganizationTableWeb()
        ],
      ),
    );
  }
}
