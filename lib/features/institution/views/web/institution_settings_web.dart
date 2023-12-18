import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/views/web/manage_invite_web.dart';
import 'package:smat_crow/features/institution/views/web/notification_settings_web.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class InstitutionSettingsWeb extends HookConsumerWidget {
  const InstitutionSettingsWeb({
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
                const BoldHeaderText(
                  text: "Settings",
                  fontSize: SpacingConstants.font24,
                ),
                const Ymargin(SpacingConstants.double20),
                ...List.generate(
                  _list.length,
                  (index) => InkWell(
                    onTap: () {
                      selected.value = index;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(SpacingConstants.font12),
                      decoration: BoxDecoration(
                        color: selected.value == index ? AppColors.SmatCrowPrimary100 : Colors.white,
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
          const Xmargin(SpacingConstants.size20),
          Builder(
            builder: (context) {
              // if (selected.value == 0) {
              //   return const AgentTableWeb();
              // }
              if (selected.value == 0) {
                return const NotificationSettingsWeb();
              }
              return const ManageInviteWeb();
            },
          )
        ],
      ),
    );
  }
}

final _list = [
  NameICon("Notification Settings", Icons.notifications_none_sharp),
  NameICon("Manage Invite", Icons.share_outlined)
];

class NameICon {
  final String name;
  final IconData iconData;

  NameICon(this.name, this.iconData);
}
