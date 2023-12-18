// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/app_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class NotificationMobile extends HookConsumerWidget {
  const NotificationMobile({
    super.key,
    this.isMobile = true,
  });

  final bool isMobile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    return Scaffold(
      appBar: isMobile ? customAppBar(context, title: notificationSettingsText) : null,
      body: Builder(
        builder: (context) {
          if (shared.loading) {
            return const GridLoader(arrangement: 1);
          }
          if (shared.notification == null) {
            return const EmptyListWidget(text: notificationSettingsWarning, asset: AppAssets.emptyImage);
          }
          return SingleChildScrollView(
            padding: const EdgeInsets.all(SpacingConstants.double20),
            child: Column(
              children: [
                AppContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SpacingConstants.size10,
                    vertical: SpacingConstants.double20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: SpacingConstants.size10),
                        child: BoldHeaderText(text: assetNotificationText),
                      ),
                      const Ymargin(SpacingConstants.size10),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertAssetThreadMessage ?? false,
                            onChanged: (value) {
                              shared.notification!.alertAssetThreadMessage = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              assetThreadNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertPublishedAsset ?? false,
                            onChanged: (value) {
                              shared.notification!.alertPublishedAsset = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              publishedAssetNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertUpdatedAsset ?? false,
                            onChanged: (value) {
                              shared.notification!.alertUpdatedAsset = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              updatedAssetNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertDraftAsset ?? false,
                            onChanged: (value) {
                              shared.notification!.alertDraftAsset = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              draftAssetNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Ymargin(SpacingConstants.double20),
                AppContainer(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: SpacingConstants.size10),
                        child: BoldHeaderText(text: logNotification),
                      ),
                      const Ymargin(SpacingConstants.double20),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertLogThreadMessage ?? false,
                            onChanged: (value) {
                              shared.notification!.alertLogThreadMessage = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              logThreadNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertPublishedLog ?? false,
                            onChanged: (value) {
                              shared.notification!.alertPublishedLog = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              publishedLogNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertUpdatedLog ?? false,
                            onChanged: (value) {
                              shared.notification!.alertUpdatedLog = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              updatedLogNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertDraftLog ?? false,
                            onChanged: (value) {
                              shared.notification!.alertDraftLog = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              draftLogNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Ymargin(SpacingConstants.double20),
                AppContainer(
                  padding: const EdgeInsets.all(SpacingConstants.double20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: SpacingConstants.size10),
                        child: BoldHeaderText(text: otherNotification),
                      ),
                      const Ymargin(SpacingConstants.double20),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.alertSeasonChange ?? false,
                            onChanged: (value) {
                              shared.notification!.alertSeasonChange = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              seasonChangeNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.emailNotifications ?? false,
                            onChanged: (value) {
                              shared.notification!.emailNotifications = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              emailNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.smsNotifications ?? false,
                            onChanged: (value) {
                              shared.notification!.smsNotifications = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              smsNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                      Row(
                        children: [
                          Switch.adaptive(
                            value: shared.notification!.whatsAppNotifications ?? false,
                            onChanged: (value) {
                              shared.notification!.whatsAppNotifications = value;
                              shared.notifyListeners();
                            },
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Flexible(
                            child: Text(
                              whatsappNotification,
                              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                const Ymargin(SpacingConstants.double20),
                CustomButton(
                  text: saveChanges,
                  loading: shared.loader,
                  onPressed: () {
                    ref.read(sharedProvider).updateNotificationSetting(shared.notification!.toJson());
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
