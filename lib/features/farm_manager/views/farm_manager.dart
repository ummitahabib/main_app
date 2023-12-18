import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_manager_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_manager_home_view.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/responsive.dart';

class FarmManager extends HookConsumerWidget {
  const FarmManager({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        Future(() async {
          await ref.watch(sharedProvider).getProfile();

          if (ref.watch(sharedProvider).seasonList.isEmpty) {
            await ref.watch(sharedProvider).getSeasons();
          }
          if (ref.watch(farmDashProvider).dashStatList.isEmpty) {
            await ref.watch(farmDashProvider).getDashStats();
          } else {
            await ref.watch(farmDashProvider).getDashStats(false);
          }
        });
        return null;
      },
      [],
    );
    return const Responsive(
      mobile: FarmManagerMobile(),
      tablet: FarmManagerMobile(),
      desktop: FarmManagerHomeWebView(),
      desktopTablet: FarmManagerHomeWebView(),
    );
  }
}
