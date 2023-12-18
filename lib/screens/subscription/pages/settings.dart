import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../../utils/styles.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();

    return Column(
      children: [
        SettingsPageCard(
          iconAsset: "assets2/images/rocket-dynamic-color.png",
          title: "Upgrade Plan",
          subtitle: "Get the best plan for your organization",
          onTap: () {
            pandora.logAPPButtonClicksEvent(
              'UPDATE_PLAN_BUTTON ${"subscriptionPlansView".replaceAll('/', '').toUpperCase()}_CLICKED',
            );
            pandora.reRouteUser(context, ConfigRoute.subscriptionPlanListView, 'null');
          },
        ),
      ],
    );
  }
}

class SettingsPageCard extends StatelessWidget {
  const SettingsPageCard({
    Key? key,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
    required this.onTap,
  }) : super(key: key);

  final String iconAsset;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 15,
        ),
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: Styles.boxDecoWhite12(),
        child: Row(
          children: [
            Image.asset(
              width: 48,
              height: 48,
              iconAsset,
              fit: BoxFit.scaleDown,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF111927),
                    fontSize: 14,
                    fontFamily: 'Basier Circle',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7380),
                    fontSize: 12,
                    fontFamily: 'Basier Circle',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
