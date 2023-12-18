import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class BottomNavigationBarWidget extends HookConsumerWidget {
  final int currentTab;
  final Function(int) switchPage;

  const BottomNavigationBarWidget({
    super.key,
    required this.currentTab,
    required this.switchPage,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    if (Responsive.isDesktop(context)) {
      return const SizedBox.shrink();
    } else {
      return BottomNavigationBar(
        onTap: switchPage,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        currentIndex: currentTab,
        selectedItemColor: AppColors.landingOrangeButton,
        elevation: SpacingConstants.double0,
        selectedLabelStyle: Styles.bottomNavTextStyle(),
        unselectedLabelStyle: Styles.bottomNavTextStyle(),
        items: shared.userInfo != null && shared.userInfo!.user.role.role == UserRole.institution.name
            ? [
                BottomNavigationBarItem(
                  icon: Icon(
                    EvaIcons.home,
                    color: AppColors.unselectedItemColor,
                  ),
                  activeIcon: const Icon(
                    EvaIcons.home,
                    color: AppColors.landingOrangeButton,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    EvaIcons.compass,
                    color: AppColors.unselectedItemColor,
                  ),
                  activeIcon: const Icon(
                    EvaIcons.compass,
                    color: AppColors.landingOrangeButton,
                  ),
                  label: 'News',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(
                //     EvaIcons.navigation,
                //     color: AppColors.unselectedItemColor,
                //   ),
                //   activeIcon: const Icon(
                //     EvaIcons.navigation,
                //     color: AppColors.landingOrangeButton,
                //   ),
                //   label: 'Socials',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(
                    EvaIcons.settings,
                    color: AppColors.unselectedItemColor,
                  ),
                  activeIcon: const Icon(
                    EvaIcons.settings,
                    color: AppColors.landingOrangeButton,
                  ),
                  label: 'Manage',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    EvaIcons.person,
                    color: AppColors.unselectedItemColor,
                  ),
                  activeIcon: const Icon(
                    EvaIcons.person,
                    color: AppColors.landingOrangeButton,
                  ),
                  label: 'Profile',
                ),
              ]
            : [
                BottomNavigationBarItem(
                  icon: Icon(
                    EvaIcons.home,
                    color: AppColors.unselectedItemColor,
                  ),
                  activeIcon: const Icon(
                    EvaIcons.home,
                    color: AppColors.landingOrangeButton,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    EvaIcons.compass,
                    color: AppColors.unselectedItemColor,
                  ),
                  activeIcon: const Icon(
                    EvaIcons.compass,
                    color: AppColors.landingOrangeButton,
                  ),
                  label: 'News',
                ),
                // BottomNavigationBarItem(
                //   icon: Icon(
                //     EvaIcons.navigation,
                //     color: AppColors.unselectedItemColor,
                //   ),
                //   activeIcon: const Icon(
                //     EvaIcons.navigation,
                //     color: AppColors.landingOrangeButton,
                //   ),
                //   label: 'Socials',
                // ),
                BottomNavigationBarItem(
                  icon: Icon(
                    EvaIcons.person,
                    color: AppColors.unselectedItemColor,
                  ),
                  activeIcon: const Icon(
                    EvaIcons.person,
                    color: AppColors.landingOrangeButton,
                  ),
                  label: 'Profile',
                ),
              ],
      );
    }
  }
}
