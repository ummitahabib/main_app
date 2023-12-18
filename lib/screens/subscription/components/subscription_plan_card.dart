import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/institution/views/web/institution_menu.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/network/crow/models/subcription/create_subscriber.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/subscription/provider/subscriptions_provider.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';

import '../../../network/crow/models/subcription/subscription_plan.dart';
import '../../../utils/styles.dart';

class SubscriptionPlanCard extends StatelessWidget {
  const SubscriptionPlanCard({
    Key? key,
    required this.plan,
    required this.onTap,
  }) : super(key: key);

  final SubscriptionPlan plan;
  final ValueChanged<CreateSubscriberRequest> onTap;

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: InkWell(
        onTap: () {
          customDialogAndModal(
            context,
            HookConsumer(
              builder: (context, ref, child) {
                final sub = ref.watch(subcriptionProvider);
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20).copyWith(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const ModalStick(),
                      const Ymargin(20),
                      Container(
                        width: 79,
                        height: 79,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1000),
                          color: list
                              .firstWhere((element) => element.name.contains(plan.name), orElse: () => list.last)
                              .color
                              .withOpacity(0.1),
                        ),
                        alignment: Alignment.center,
                        child: Image.asset(
                          width: 56,
                          height: 56,
                          list.firstWhere((element) => element.name.contains(plan.name), orElse: () => list.last).asset,
                        ),
                      ),
                      const Ymargin(20),
                      Text(
                        plan.name,
                        style: const TextStyle(
                          color: Color(0xFF111927),
                          fontSize: 21,
                          fontFamily: 'Basier Circle',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "₦‎${pandora.newMoneyFormat(plan.amount)}/month\n",
                        style: const TextStyle(
                          color: Color(0xFFFF9D00),
                          fontSize: 16,
                          fontFamily: 'Arials',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Ymargin(20),
                      Text(
                        list.map((e) => e.name).contains(plan.name)
                            ? list.firstWhere((element) => element.name.contains(plan.name)).details
                            : plan.description,
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 14,
                          fontFamily: 'Basier Circle',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Ymargin(10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                        decoration: ShapeDecoration(
                          color: AppColors.SmatCrowNeuBlue50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'This monthly subscription plan gives you access to the following;\n',
                              style: TextStyle(
                                color: Color(0xFF374151),
                                fontSize: 12,
                                fontFamily: 'Basier Circle',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            ...plan.permissions.map(
                              (e) => Row(
                                children: [
                                  const Icon(
                                    Icons.circle,
                                    color: Color(0xFF374151),
                                    size: 5,
                                  ),
                                  const Xmargin(5),
                                  Text(
                                    e.title,
                                    style: const TextStyle(
                                      color: Color(0xFF374151),
                                      fontSize: 12,
                                      fontFamily: 'Basier Circle',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const Ymargin(10),
                      CustomButton(
                        text: "Buy Now",
                        onPressed: () {
                          if (ref.read(sharedProvider).userInfo == null) {
                            return;
                          }
                          final user = ref.read(sharedProvider).userInfo!.user;
                          final request = CreateSubscriberRequest(
                            userId: user.id,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            email: user.email,
                          );
                          ref.read(subcriptionProvider).createSubscriber(request).then((value) {
                            if (value) {
                              if (Responsive.isDesktop(context)) {
                                OneContext().popDialog();
                              } else {
                                Navigator.pop(context);
                              }
                              Future.delayed(
                                const Duration(seconds: 1),
                                () => onTap(request),
                              );
                            }
                          });
                        },
                        loading: sub.loading,
                      )
                    ],
                  ),
                );
              },
            ),
          );
        },
        child: Stack(
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(20),
              decoration: Styles.boxDecoWithShadowGrey(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE4F7E4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      'ESSENTIAL',
                      style: TextStyle(
                        color: Color(0xFF028200),
                        fontSize: 10,
                        fontFamily: 'Basier Circle',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Ymargin(10),
                  Text(
                    plan.name,
                    style: const TextStyle(
                      color: Color(0xFF111927),
                      fontSize: 18,
                      fontFamily: 'Basier Circle',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "₦‎${pandora.newMoneyFormat(plan.amount)}/month\n",
                          style: const TextStyle(
                            color: Color(0xFF6B7380),
                            fontSize: 14,
                            fontFamily: 'Arial',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        TextSpan(
                          text: plan.description,
                          style: const TextStyle(
                            color: Color(0xFF6B7380),
                            fontSize: 14,
                            fontFamily: 'Basier Circle',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 120,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    list.firstWhere((element) => element.name.contains(plan.name), orElse: () => list.last).asset,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

final list = [
  NameImage(
    'Farm Manager',
    'assets2/images/0020.png',
    const Color(0xffEDD788),
    'Farm Manager is a tool to help farmers and Agri business stakeholders keep track of everything going on in their farm. This feature allows one to keep inventory and keep track of assets and materials used on their farms. This is a paid for feature.',
  ),
  NameImage(
    'Field Measurement',
    'assets2/images/0021.png',
    const Color(0xffBAE734),
    'This tool allows you to measure your farmland accurately and export the generated map. It is a paid for feature.',
  ),
  NameImage(
    'Field Agent',
    'assets2/images/farmer-5266581-4403855.png',
    const Color(0xffEB8870),
    'Field Agents are people you assign to your organization to help you manage your farm. You can add 2 Field Agents for free after which you are required to pay for additional Field Agents.',
  ),
  NameImage(
    'Organization',
    'assets2/images/0016.png',
    const Color(0xffF4402A),
    'This tool allows you to create and onboard your Farm (organization) in AnyFarm. You can create 2 farms (organizations) for free, after which you will need to pay to create more organizations.',
  ),
];
