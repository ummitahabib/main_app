import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';

import '../../../network/crow/models/subcription/subscription.dart';
import '../../../utils/styles.dart';

class StatisticsPage extends HookConsumerWidget {
  const StatisticsPage({Key? key, required this.subscriptions}) : super(key: key);

  final List<Subscription> subscriptions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        StatisticsCard(
          iconAsset: AppAssets.flash,
          title: subscriptions.first.plan!.name ?? "",
          value:
              "Expires on ${DateFormat.yMMMd().format(subscriptions.first.nextCharge ?? DateTime.now())}", //subscriptions.length.toString(),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            // customDialog(
            //   context,
            //   Column(
            //     mainAxisSize: MainAxisSize.min,
            //     children: [
            //       const Ymargin(40),
            //       const SizedBox(
            //         width: 211,
            //         child: Text(
            //           'Do you want to proceed with the action',
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //             color: Color(0xFF111927),
            //             fontSize: 18,
            //             fontFamily: 'Basier Circle',
            //             fontWeight: FontWeight.w600,
            //           ),
            //         ),
            //       ),
            //       const Ymargin(20),
            //       const Text(
            //         'NB: This is not reversible',
            //         style: TextStyle(
            //           color: Color(0xFF6B7380),
            //           fontSize: 12,
            //           fontFamily: 'Basier Circle',
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       const Ymargin(20),
            //       const Divider(),
            //       Row(
            //         children: [
            //           Expanded(
            //             child: CustomButton(
            //               text: "No, Cancel",
            //               onPressed: () {},
            //               textColor: AppColors.SmatCrowNeuBlue500,
            //               color: Colors.transparent,
            //             ),
            //           ),
            //           const SizedBox(height: SpacingConstants.size50, child: VerticalDivider()),
            //           Expanded(
            //             child: CustomButton(
            //               text: "Yes, Stop Plan",
            //               textColor: AppColors.SmatCrowRed500,
            //               onPressed: () {
            //                 // ref.read(subcriptionProvider).cancelSubscription(subscriptionCode, uid)
            //               },
            //               color: Colors.transparent,
            //             ),
            //           ),
            //         ],
            //       )
            //     ],
            //   ),
            // );
          },
          child: StatisticsCard(
            iconAsset: AppAssets.navigation,
            title: subscriptions.length.toString(),
            value: "Number of subcriptions",
          ),
        ),
        const SizedBox(height: 12),
        StatisticsCard(
          iconAsset: AppAssets.tag,
          title: "NGN ${Pandora().newMoneyFormat((subscriptions.first.plan!.amount ?? 0.0).toDouble())}",
          value: "Total Lifetime value", //subscriptions.length.toString(),
        ),
      ],
    );
  }
}

class DetailItem extends StatelessWidget {
  const DetailItem({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF6B7380),
              fontSize: 12,
              fontFamily: 'Basier Circle',
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Color(0xFF111927),
              fontSize: 12,
              fontFamily: 'Basier Circle',
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    Key? key,
    required this.iconAsset,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String iconAsset;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
      decoration: Styles.boxDecoWhite12(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF111927),
                  fontSize: 21,
                  fontFamily: 'Basier Circle',
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF6B7380),
                  fontSize: 12,
                  fontFamily: 'Basier Circle',
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (value.contains("Expires")) const SizedBox(height: 8),
              if (value.contains("Expires"))
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
            ],
          ),
          SvgPicture.asset(iconAsset),
        ],
      ),
    );
  }
}
