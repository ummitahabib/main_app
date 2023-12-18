import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_dashboard_controller.dart';
import 'package:smat_crow/features/institution/views/mobile/institution_dashboard_mobile.dart';
import 'package:smat_crow/features/institution/views/web/institution_dashboard_web.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/utils2/responsive.dart';

class InstitutionDashboard extends HookConsumerWidget {
  const InstitutionDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final farmDash = ref.watch(farmDashProvider);
    useEffect(
      () {
        Future(() async {
          await ref.watch(sharedProvider).getProfile();

          if (ref.watch(sharedProvider).seasonList.isEmpty) {
            await ref.watch(sharedProvider).getSeasons();
          }
          if (farmDash.dashStatList.isEmpty) {
            await farmDash.getDashStats();
          }
        });
        return null;
      },
      [],
    );
    return const Responsive(
      desktop: InstitutionDashboardWeb(),
      desktopTablet: InstitutionDashboardWeb(),
      tablet: InstitutionDashboardMobile(),
      mobile: InstitutionDashboardMobile(),
    );
  }
}
