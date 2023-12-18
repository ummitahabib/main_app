// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/views/mobile/notification_mobile.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/responsive.dart';

class NotificationSettingsWeb extends HookConsumerWidget {
  const NotificationSettingsWeb({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        Future(() {
          if (ref.read(sharedProvider).notification == null) {
            ref.read(sharedProvider).getNotificationSetting();
          }
        });
        return null;
      },
      [],
    );
    return Expanded(
      flex: 2,
      child: SizedBox(
        height: Responsive.yHeight(context, percent: 0.9),
        child: const NotificationMobile(isMobile: false),
      ),
    );
  }
}
