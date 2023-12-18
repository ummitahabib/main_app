import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/farm_manager_stats.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/get_started.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/organization_list_with_search.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmManagerHomeWebView extends HookConsumerWidget {
  const FarmManagerHomeWebView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(
        top: SpacingConstants.size20,
        left: SpacingConstants.size40,
        right: SpacingConstants.size40,
      ),
      child: HomeWebContainer(
        title: farmManagerText,
        leadingCallback: () {
          context.beamBack();
        },
        elevation: 0,
        width: Responsive.xWidth(context),
        addSpacing: true,
        trailingIcon: CustomButton(
          leftIcon: Icons.add,
          text: selectOrgText,
          width: SpacingConstants.size185,
          onPressed: () {
            customDialogAndModal(
              context,
              const OrganizationListWithSearch(),
            );
          },
          color: AppColors.SmatCrowPrimary500,
          height: SpacingConstants.size44,
        ),
        child: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ymargin(SpacingConstants.font21),
              Align(alignment: Alignment.topLeft, child: FarmManagerGetStartedCard()),
              Ymargin(SpacingConstants.size30),
              FarmManagerStats(),
            ],
          ),
        ),
      ),
    );
  }
}
