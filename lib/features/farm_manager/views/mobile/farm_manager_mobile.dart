import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/farm_manager_stats.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/get_started.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/organization_list_with_search.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmManagerMobile extends StatefulHookConsumerWidget {
  const FarmManagerMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmManagerMobileState();
}

class _FarmManagerMobileState extends ConsumerState<FarmManagerMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            if (kIsWeb) {
              context.beamToReplacementNamed(ConfigRoute.mainPage);
            } else {
              Navigator.pop(context);
            }
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            color: AppColors.SmatCrowNeuBlue900,
            size: 30,
          ),
          splashRadius: 20,
        ),
        title: const Text(farmManagerText),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const FarmManagerGetStartedCard(),
            customSizedBoxHeight(SpacingConstants.size20),
            const FarmManagerStats(),
            customSizedBoxHeight(SpacingConstants.size30),
            CustomButton(
              leftIcon: Icons.add,
              text: selectOrgText,
              onPressed: () {
                customDialogAndModal(
                  context,
                  const OrganizationListWithSearch(),
                );
              },
              color: AppColors.SmatCrowPrimary500,
              height: SpacingConstants.size47,
            )
          ],
        ),
      ),
    );
  }
}
