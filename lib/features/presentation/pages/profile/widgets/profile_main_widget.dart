import 'package:beamer/beamer.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/presentation/pages/profile/edit_profile_page.dart';
import 'package:smat_crow/features/presentation/pages/profile/widgets/edit_profile_show_model.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ProfileMainWidget extends StatefulHookConsumerWidget {
  final double? width;
  final double? height;
  const ProfileMainWidget({
    Key? key,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileMainWidgetState();
}

class _ProfileMainWidgetState extends ConsumerState<ProfileMainWidget> {
  ApplicationHelpers appHelper = ApplicationHelpers();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final shared = ref.watch(sharedProvider);
      if (shared.userInfo == null) {
        shared.getProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: const SizedBox.shrink(),
      ),
      backgroundColor: AppColors.SmatCrowNeuBlue50,
      body: HookConsumer(
        builder: (context, ref, child) {
          final shared = ref.watch(sharedProvider);
          if (shared.loading) {
            return const Center(
              child: SizedBox(
                width: SpacingConstants.size50,
                height: SpacingConstants.size50,
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          }

          if (shared.userInfo == null) {
            return const Center(child: Text("No User Information found"));
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: widget.width ?? 342,
                    height: widget.height ?? 312,
                    decoration: BoxDecoration(
                      color: AppColors.SmatCrowDefaultWhite,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 34),
                          child: SizedBox(
                            width: 274,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: SpacingConstants.size15,
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      border: Border.all(
                                        color: AppColors.SmatCrowPrimary500,
                                        width: 1.875,
                                      ),
                                    ),
                                    width: 70,
                                    height: 70,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: profileWidget(imageUrl: DEFAULT_IMAGE),
                                    ),
                                  ),
                                ),
                                customSizedBoxHeight(SpacingConstants.size15),
                                Text(
                                  "${shared.userInfo!.user.firstName} ${shared.userInfo!.user.lastName}",
                                  style: const TextStyle(
                                    color: AppColors.SmatCrowDefaultBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                customSizedBoxHeight(SpacingConstants.size10),
                                Text(
                                  shared.userInfo!.user.email,
                                  style: const TextStyle(
                                    color: AppColors.SmatCrowDefaultBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                customSizedBoxHeight(SpacingConstants.size10),
                                Text(
                                  shared.userInfo!.user.role.role == UserRole.user.name
                                      ? "Organization"
                                      : shared.userInfo!.user.role.role,
                                  style: const TextStyle(
                                    color: AppColors.SmatCrowDefaultBlack,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                customSizedBoxHeight(SpacingConstants.size28),
                                GestureDetector(
                                  onTap: () {
                                    customDialogAndModal(
                                      context,
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: SpacingConstants.size24,
                                              right: SpacingConstants.size24,
                                              top: SpacingConstants.size48,
                                              bottom: SpacingConstants.size24,
                                            ),
                                            child: Column(
                                              children: [
                                                ProfileOptionsWidget(
                                                  onTap: () {
                                                    ApplicationHelpers().trackButtonAndDeviceEvent(
                                                      'NAVIGATE_TO_EDIT_PROFILE',
                                                    );

                                                    ApplicationHelpers().reRouteUser(
                                                      context,
                                                      ConfigRoute.editProfilePage,
                                                      emptyString,
                                                    );
                                                  },
                                                ),
                                                ProfileOptionsWidget(
                                                  onTap: () {
                                                    ApplicationHelpers().trackButtonAndDeviceEvent(
                                                      'NAVIGATE_TO_EDIT_PASSWORD',
                                                    );

                                                    ApplicationHelpers().reRouteUser(
                                                      context,
                                                      ConfigRoute.changePasswordPage,
                                                      emptyString,
                                                    );
                                                  },
                                                  text: 'Edit Password',
                                                  icon: const Icon(
                                                    EvaIcons.lockOutline,
                                                    color: AppColors.SmatCrowPrimary500,
                                                    size: SpacingConstants.size24,
                                                  ),
                                                ),
                                                ProfileOptionsWidget(
                                                  onTap: () {
                                                    Pandora()
                                                        .reRouteUser(context, ConfigRoute.subscriptionPlanView, "args");
                                                  },
                                                  text: 'Manage Subscriptions',
                                                  icon: const Icon(
                                                    EvaIcons.paperPlaneOutline,
                                                    color: AppColors.SmatCrowPrimary500,
                                                    size: SpacingConstants.size24,
                                                  ),
                                                ),
                                                customSizedBoxHeight(SpacingConstants.size20),
                                                CustomButton(
                                                  text: 'Log out',
                                                  onPressed: () {
                                                    if (kIsWeb) {
                                                      context.beamToReplacementNamed(ConfigRoute.login);
                                                    } else {
                                                      Navigator.pushNamedAndRemoveUntil(
                                                        context,
                                                        ConfigRoute.login,
                                                        (route) => false,
                                                      );
                                                    }
                                                    ref.read(sharedProvider).userInfo = null;
                                                  },
                                                  color: AppColors.SmatCrowRed50,
                                                  textColor: AppColors.SmatCrowRed500,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 299,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: AppColors.transperant,
                                      border: Border.all(
                                        color: AppColors.SmatCrowPrimary500,
                                      ),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Center(
                                      child: Text('Edit Profile'),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
