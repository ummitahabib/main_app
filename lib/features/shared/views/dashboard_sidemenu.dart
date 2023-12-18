// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/institution/views/mobile/side_menu.dart';
import 'package:smat_crow/features/organisation/views/widgets/siderbar_navigation.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class DashboardSideMenu extends StatefulHookConsumerWidget {
  final GlobalKey<BeamerState> beamer;

  const DashboardSideMenu({
    super.key,
    required this.beamer,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardSideMenuState();
}

class _DashboardSideMenuState extends ConsumerState<DashboardSideMenu> {
  @override
  Widget build(BuildContext context) {
    final path = (context.currentBeamLocation.state as BeamState).uri.path;
    final shared = ref.watch(sharedProvider);
    shared.getSelectedSideMenuItem(path);

    return HookConsumer(
      builder: (context, ref, child) {
        return Container(
          width: SpacingConstants.size270,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.SmatCrowNeuBlue100),
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    customSizedBoxHeight(SpacingConstants.size40),
                    Center(
                      child: shared.selected == ConfigRoute.manageOrgRoute
                          ? Image.asset(AppAssets.halfLogo)
                          : Image.asset(AppAssets.fullLogo),
                    ),
                    customSizedBoxHeight(SpacingConstants.size40),
                    Padding(
                      padding: EdgeInsets.only(
                        left: shared.selected == ConfigRoute.manageOrgRoute ? 0 : SpacingConstants.double20,
                      ),
                      child: SidebarNavigator(
                        items: shared.getSideMenuItem(),
                        currentIndex: shared.selected,
                        onChange: (value) {
                          setState(() {
                            widget.beamer.currentState?.routerDelegate.beamToNamed(shared.getNavList()[value]);
                          });
                        },
                      ),
                    ),
                    if (shared.selected != ConfigRoute.manageOrgRoute) const Spacer(),
                    if (shared.selected != ConfigRoute.manageOrgRoute)
                      Container(
                        width: SpacingConstants.size213,
                        padding: const EdgeInsets.symmetric(
                          horizontal: SpacingConstants.size32,
                          vertical: SpacingConstants.size20,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SpacingConstants.size8),
                        ),
                        child: Column(
                          children: [
                            Text(
                              expandHorizon,
                              style: Styles.smatCrowParagrahBold(
                                color: AppColors.SmatCrowNeuBlue700,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            customSizedBoxHeight(SpacingConstants.size10),
                            CustomButton(
                              text: getStartedNow,
                              height: SpacingConstants.size34,
                              width: SpacingConstants.size150,
                              fontSize: SpacingConstants.size12,
                              onPressed: () {},
                              color: AppColors.SmatCrowPrimary500,
                            )
                          ],
                        ),
                      )
                  ],
                ),
              ),
              if (shared.selected == ConfigRoute.manageOrgRoute)
                Expanded(
                  flex: 2,
                  child: Container(
                    color: AppColors.SmatCrowNeuOrange900,
                    padding: const EdgeInsets.all(SpacingConstants.size15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          manageOrg,
                          style: Styles.smatCrowParagrahBold(color: Colors.white).copyWith(
                            fontSize: SpacingConstants.font16,
                          ),
                        ),
                        const Ymargin(SpacingConstants.font36),
                        CustomButton(
                          text: newOrgText,
                          height: SpacingConstants.font36,
                          onPressed: () {
                            inviteOrganization(context);
                          },
                          leftIcon: Icons.add,
                          iconColor: Colors.white,
                          color: Colors.transparent,
                          borderColor: Colors.white,
                          fontSize: SpacingConstants.font10,
                          textColor: Colors.white,
                        ),
                        const Ymargin(SpacingConstants.size40),
                        const Color600Text(text: menuText),
                        const Ymargin(SpacingConstants.size20),
                        TextButton(
                          onPressed: () {
                            context.beamToNamed(
                              ConfigRoute.institutionDashboardPath,
                            );
                            shared.notifyListeners();
                          },
                          child: Text(
                            dashboardText,
                            style: path.contains(
                              ConfigRoute.institutionDashboardPath,
                            )
                                ? Styles.smatCrowMediumSubParagraph(
                                    color: Colors.white,
                                  )
                                : Styles.smatCrowSubParagraphRegular(
                                    color: Colors.white70,
                                  ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.beamToNamed(
                              ConfigRoute.institutionOrganizationPath,
                            );
                            shared.notifyListeners();
                          },
                          child: Text(
                            organizationText,
                            style: path.contains(
                              ConfigRoute.institutionOrganizationPath,
                            )
                                ? Styles.smatCrowMediumSubParagraph(
                                    color: Colors.white,
                                  )
                                : Styles.smatCrowSubParagraphRegular(
                                    color: Colors.white70,
                                  ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            inviteOrganization(context);
                          },
                          child: Text(
                            sendinviteText,
                            style: Styles.smatCrowSubParagraphRegular(
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.beamToNamed(
                              ConfigRoute.institutionSettingsPath,
                            );
                            shared.notifyListeners();
                          },
                          child: Text(
                            settingsText,
                            style: path.contains(
                              ConfigRoute.institutionSettingsPath,
                            )
                                ? Styles.smatCrowMediumSubParagraph(
                                    color: Colors.white,
                                  )
                                : Styles.smatCrowSubParagraphRegular(
                                    color: Colors.white70,
                                  ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
