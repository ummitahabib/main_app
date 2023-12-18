import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/get_user_profile_photo.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../screens/desktop/home_desktop.dart';

class UserInfoDesk extends StatefulHookConsumerWidget {
  const UserInfoDesk({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInfoDeskState();
}

class _UserInfoDeskState extends ConsumerState<UserInfoDesk> {
  @override
  Widget build(BuildContext context) {
    final shared = ref.watch(sharedProvider);
    return Container(
      color: AppColors.SmatCrowPrimary50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: SpacingConstants.size70,
      child: Row(
        children: [
          Expanded(
            child: Material(
              child: InkWell(
                onTap: () {
                  scaffoldKey.currentState!.openEndDrawer();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: DecorationBox.smatCrowBoxDecoration(
                          color: AppColors.SmatCrowDefaultWhite,
                        ),
                        child: DecorationBox.desktopDashboardText(),
                      ),
                    ),
                    customSizedBoxWidth(12),
                    Container(
                      decoration: DecorationBox.smatCrowBoxDecoration(
                        color: AppColors.SmatCrowPrimary400,
                      ),
                      height: SpacingConstants.size44,
                      width: SpacingConstants.size44,
                      child: const Icon(
                        EvaIcons.search,
                        size: SpacingConstants.size24,
                        color: AppColors.SmatCrowNeuBlue900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          customSizedBoxWidth(
            SpacingConstants.size35,
          ),
          const UserProfileWidget(),
          customSizedBoxWidth(SpacingConstants.size8),
          Text(
            shared.userInfo == null ? "" : "${shared.userInfo!.user.firstName} ${shared.userInfo!.user.lastName}",
            style: Styles.firstNameTextStyle(),
          ),
          customSizedBoxWidth(SpacingConstants.size8),
          const Icon(
            EvaIcons.arrowDown,
            size: SpacingConstants.size16,
            color: AppColors.SmatCrowNeuBlue400,
          ),
        ],
      ),
    );
  }
}
