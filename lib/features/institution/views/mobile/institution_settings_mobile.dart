import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/features/institution/views/mobile/agent_mobile.dart';
import 'package:smat_crow/features/institution/views/mobile/manage_invite_mobile.dart';
import 'package:smat_crow/features/institution/views/mobile/notification_mobile.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class InstitutionSettingsMobile extends HookConsumerWidget {
  const InstitutionSettingsMobile({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = useState(0);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SpacingConstants.double20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  _list.length,
                  (index) => InkWell(
                    onTap: () {
                      switch (index) {
                        // if (Responsive.isTablet(context)) {
                        //   selected.value = 0;
                        //   return;
                        // }
                        // Pandora().reRouteUser(context, institutionAgents, "args");
                        // return;
                        case 0:
                          ref.read(sharedProvider).getNotificationSetting();
                          if (Responsive.isTablet(context)) {
                            selected.value = 0;
                            return;
                          }
                          Pandora().reRouteUser(context, ConfigRoute.institutionNotificationSettings, "args");
                          return;
                        default:
                          if (Responsive.isTablet(context)) {
                            selected.value = 1;
                            return;
                          }
                          Pandora().reRouteUser(context, ConfigRoute.institutionInvites, "args");
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(SpacingConstants.font12),
                      decoration: BoxDecoration(
                        color: (index == selected.value && Responsive.isTablet(context))
                            ? AppColors.SmatCrowPrimary100
                            : null,
                        borderRadius: BorderRadius.circular(SpacingConstants.font10),
                      ),
                      width: double.maxFinite,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _list[index].iconData,
                            color: AppColors.SmatCrowPrimary500,
                          ),
                          const Xmargin(SpacingConstants.font10),
                          Text(
                            _list[index].name,
                            style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue900),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (Responsive.isTablet(context))
            Expanded(
              flex: 2,
              child: SizedBox(
                height: Responsive.yHeight(context, percent: 0.9),
                child: Builder(
                  builder: (context) {
                    if (selected.value == 0) {
                      return const AgentMobile(isMobile: false);
                    }
                    if (selected.value == 1) {
                      return const NotificationMobile(isMobile: false);
                    }
                    return const ManageInviteMobile(isMobile: false);
                  },
                ),
              ),
            )
        ],
      ),
    );
  }
}

final _list = [
  // NameICon("Agent", Icons.people_outline),
  _NameICon(notificationSettingsText, Icons.notifications_none_sharp),
  _NameICon(manageInviteText, Icons.share_outlined)
];

class _NameICon {
  final String name;
  final IconData iconData;

  _NameICon(this.name, this.iconData);
}
