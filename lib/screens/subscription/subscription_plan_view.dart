import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/screens/subscription/pages/history_page.dart';
import 'package:smat_crow/screens/subscription/pages/settings.dart';
import 'package:smat_crow/screens/subscription/pages/statistics_page.dart';
import 'package:smat_crow/screens/subscription/provider/subscriptions_provider.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../pandora/pandora.dart';
import '../../utils/constants.dart';
import '../../utils/strings.dart';
import '../../utils/styles.dart';
import 'components/error_widget_component.dart';

class SubscriptionPlanView extends HookConsumerWidget {
  const SubscriptionPlanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Pandora pandora = Pandora();

    final tabController = useTabController(initialLength: 3);
    final pageController = usePageController();
    final subscription = ref.watch(subcriptionProvider);
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (ref.read(sharedProvider).userInfo != null) {
            await subscription.getSubscriptions(ref.read(sharedProvider).userInfo!.user.id);
          }
        });

        return () {};
      },
      const [],
    );

    return Scaffold(
      appBar: customAppBar(
        context,
        title: SubscriptionPlanString.subscriptionTitle,
      ),
      backgroundColor: AppColors.SmatCrowNeuBlue50,
      body: subscription.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : HookConsumer(
              builder: (context, ref, child) {
                final subscriptions = ref.watch(subcriptionProvider).subscriptions; // plans

                return subscriptions.isEmpty
                    ? ErrorWidgetComponent(
                        message: SubscriptionPlanString.noSubscriptionMessage,
                        buttonLabel: SubscriptionPlanString.getPlanButtonLabel,
                        onTap: () {
                          pandora.logAPPButtonClicksEvent(
                            'SUBSCRIPTION_PLAN_BTN_${"subscriptionPlansView".replaceAll('/', '').toUpperCase()}_CLICKED',
                          );
                          pandora.reRouteUser(
                            context,
                            ConfigRoute.subscriptionPlanListView,
                            'null',
                          );
                        },
                      )
                    : Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2.0),
                              decoration: Styles.BoxDecoBorder50(),
                              height: 32,
                              child: TabBar(
                                controller: tabController,
                                labelColor: const Color(0xFF111A27),
                                unselectedLabelColor: const Color(0xFF111A27),
                                // indicatorSize: TabBarIndicatorSize.label,
                                indicator: Styles.BoxDecoBorderWhite50(),
                                onTap: (tabIndex) => pageController.jumpToPage(tabIndex),
                                tabs: Tabs.tabs,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Expanded(
                              child: PageView(
                                controller: pageController,
                                physics: const NeverScrollableScrollPhysics(),
                                onPageChanged: (page) => tabController.index = page,
                                children: [
                                  StatisticsPage(subscriptions: subscriptions),
                                  HistoryPage(subscriptions: subscriptions),
                                  const SettingsPage(),
                                ],
                              ),
                            )
                          ],
                        ),
                      );
              },
            ),
    );
  }
}
