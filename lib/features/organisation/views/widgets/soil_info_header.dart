import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_card_bar.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SoilInfoHeader extends HookConsumerWidget {
  const SoilInfoHeader({
    super.key,
    required this.title,
    required this.showIcon,
  });
  final String title;
  final bool showIcon;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!kIsWeb)
          Center(
            child: Container(
              height: SpacingConstants.size5,
              width: SpacingConstants.size70,
              margin: const EdgeInsets.only(top: SpacingConstants.size10),
              decoration: const BoxDecoration(color: AppColors.SmatCrowNeuBlue200),
            ),
          ),
        const SizedBox(height: kIsWeb ? SpacingConstants.size0 : SpacingConstants.size20),
        if (kIsWeb)
          CustomCardBar(
            elevation: 1,
            center: true,
            title: title,
            width: Responsive.xWidth(context),
            trailingIcon: showIcon
                ? IconButton(
                    onPressed: () {
                      ref.read(orgNavigationProvider).mapPageController.jumpToPage(0);
                    },
                    icon: const Icon(Icons.clear),
                  )
                : const SizedBox.shrink(),
          ),
        if (!kIsWeb)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size20,
              vertical: SpacingConstants.size10,
            ),
            child: DialogHeader(
              headText: title,
              callback: () {
                if (kIsWeb) {
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          ),
      ],
    );
  }
}
