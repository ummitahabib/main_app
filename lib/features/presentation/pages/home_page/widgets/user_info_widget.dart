import 'package:beamer/beamer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/get_user_profile_photo.dart';
import 'package:smat_crow/features/presentation/widgets/reusable_icon.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

// user info mobile/tablet widget

class UserInfoWidget extends StatefulHookConsumerWidget {
  const UserInfoWidget({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends ConsumerState<UserInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final shared = ref.watch(sharedProvider);
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(SpacingConstants.size10),
        ),
        color: AppColors.headerTopHalf,
      ),
      padding: const EdgeInsets.all(
        SpacingConstants.size10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const UserProfileWidget(),
              const SizedBox(
                width: SpacingConstants.double12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        greetings,
                        style: Styles.greetingText(),
                      ),
                      Text(
                        shared.userInfo == null
                            ? ""
                            : "${shared.userInfo!.user.firstName} ${shared.userInfo!.user.lastName}",
                        style: Styles.firstNameTextStyle(),
                      )
                    ],
                  ),
                  customSizedBoxWidth(SpacingConstants.size10),
                  Text(
                    shared.userInfo == null ? "" : shared.userInfo!.user.email,
                    style: Styles.emailTextStyle(),
                  ),
                ],
              ),
            ],
          ),
          customSizedBoxHeight(SpacingConstants.size20),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (kIsWeb) {
                  context.beamToNamed(
                    ConfigRoute.farmAssistantBaseUi,
                  );
                } else {
                  Navigator.of(context).pushNamed(
                    ConfigRoute.farmAssistantBaseUi,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.only(
                  right: SpacingConstants.double10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    SpacingConstants.double10,
                  ),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: DecorationBox.desktopDashboardText(),
                    ),
                    const ReusableIcon(
                      icon: EvaIcons.search,
                      size: SpacingConstants.size24,
                      color: AppColors.SmatCrowNeuBlue900,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
