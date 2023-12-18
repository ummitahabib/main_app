import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/views/mobile/side_menu.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';

final sideNavProvider = StateNotifierProvider<SideNavNotifier, PageController>((ref) {
  return SideNavNotifier();
});

class SideNavNotifier extends StateNotifier<PageController> {
  SideNavNotifier() : super(PageController());
  set pageController(PageController controller) {
    state = controller;
  }

  String textHeader() {
    if (state.initialPage == 0) {
      return manageOrg;
    }
    if (state.initialPage == 1) {
      return organizationText;
    }
    return settingsText;
  }

  Widget trailingicon(BuildContext context) {
    if (state.initialPage == 0) {
      return const SizedBox.shrink();
    }
    if (state.initialPage == 1) {
      return IconButton(
        onPressed: () {
          inviteOrganization(context);
        },
        icon: const Icon(
          Icons.add,
          color: AppColors.SmatCrowPrimary500,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
