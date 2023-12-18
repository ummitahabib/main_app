// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/subscription/provider/subscriptions_provider.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/strings.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../utils/assets/launcher.dart';
import 'components/error_widget_component.dart';
import 'components/subscription_plan_card.dart';

class SubscriptionPlanListView extends StatefulHookConsumerWidget {
  const SubscriptionPlanListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SubscriptionPlanListViewState();
}

class _SubscriptionPlanListViewState extends ConsumerState<SubscriptionPlanListView> {
  final plugin = PaystackPlugin();

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: kPaystackKey);

    // Get plans when widget context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final subscription = ref.watch(subcriptionProvider);
      subscription.getPlans();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    final subscription = ref.watch(subcriptionProvider);
    return Scaffold(
      appBar: customAppBar(
        context,
        title: SubscriptionPlanString.addSubscription,
      ),
      backgroundColor: AppColors.SmatCrowNeuBlue50,
      body: subscription.isLoading
          ? const Center(child: CircularProgressIndicator.adaptive())
          : HookConsumer(
              builder: (context, ref, child) {
                final plans = ref.watch(subcriptionProvider).plans; // plans

                return plans.isEmpty
                    ? ErrorWidgetComponent(
                        message: Errors.subsPlanError,
                        buttonLabel: "Try again",
                        onTap: () {
                          subscription.getPlans();
                        },
                      )
                    : Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 8.0,
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 32),
                                  for (var plan in plans)
                                    if (plan.amount.toInt() > 0)
                                      SubscriptionPlanCard(
                                        plan: plan,
                                        onTap: (data) async {
                                          final Charge charge = Charge()
                                            ..reference = _getReference()
                                            ..amount = (plan.amount * 100).toInt()
                                            ..plan = plan.paystackPlanCode
                                            ..email = data.email;
                                          final CheckoutResponse response = await plugin.checkout(
                                            context,
                                            method: CheckoutMethod.card,
                                            logo: SizedBox(
                                              width: 70,
                                              height: 50,
                                              child: Image.asset(
                                                LauncherAssets.kIcon,
                                              ),
                                            ),
                                            charge: charge,
                                          );

                                          if (response.status) {
                                            log("checkout response $response");
                                            log('paid ${response.reference}');

                                            // check if subscription is successful reroute user

                                            Navigator.pop(context);
                                            Navigator.pop(context);
                                            await OneContext().showSnackBar(
                                              builder: (_) => SnackBar(
                                                content: Text(
                                                  '${plan.name} Subscription Successful.',
                                                ),
                                              ),
                                            );
                                            unawaited(ref.read(sharedProvider).getProfile());
                                            pandora.reRouteUser(
                                              context,
                                              ConfigRoute.subscriptionPlanView,
                                              'null',
                                            );
                                          }
                                        },
                                      ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  const TextSpan(
                                    text: 'For Farm Sense, Farm Probe & Soil Sampling , ',
                                    style: TextStyle(
                                      color: Color(0xFF374151),
                                      fontSize: 14,
                                      fontFamily: 'Basier Circle',
                                      fontWeight: FontWeight.w400,
                                      height: 0.11,
                                      letterSpacing: -0.14,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Contact sales',
                                    style: const TextStyle(
                                      color: Color(0xFFFF9D00),
                                      fontSize: 14,
                                      fontFamily: 'Basier Circle',
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()..onTap = () => Pandora().composeEmail(),
                                  ),
                                  const TextSpan(
                                    text: ' for more',
                                    style: TextStyle(
                                      color: Color(0xFF374151),
                                      fontSize: 14,
                                      fontFamily: 'Basier Circle',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
              },
            ),
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'AirSmat${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }
}
