import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/marquee.dart';
import 'package:smat_crow/features/presentation/pages/main_dashboard/widgets/nav_bar.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/dashboard_sidemenu.dart';
import 'package:smat_crow/utils2/beamer_route_list.dart';
import 'package:smat_crow/utils2/responsive.dart';

class DashboardView extends StatefulHookConsumerWidget {
  const DashboardView({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewState();
}

class _DashboardViewState extends ConsumerState<DashboardView> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref.watch(sharedProvider).getProfile();
    });
  }

  final GlobalKey<BeamerState> _beamerKey = GlobalKey<BeamerState>();
  final delegate = BeamerDelegate(
    notFoundPage: const BeamPage(
      child: NoPageFound(),
      key: ValueKey("No-page-found"),
    ),
    locationBuilder: RoutesLocationBuilder(
      routes: Routes.routing,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final currentTab = useState(0);
    log(MediaQuery.of(context).size.width.toString());
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarWidget(
        currentTab: currentTab.value,
        switchPage: (value) {
          if (kIsWeb) {
            setState(() {
              _beamerKey.currentState?.routerDelegate.beamToNamed(ref.read(sharedProvider).getNavList()[value]);
            });

            currentTab.value = value;
          } else {
            currentTab.value = value;
          }
        },
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (Responsive.isDesktop(context))
            DashboardSideMenu(
              key: const ValueKey("side-menu"),
              beamer: _beamerKey,
            ),
          Expanded(
            key: const ValueKey("expanded"),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MarqueeWidget(),
                Expanded(
                  child: Beamer(
                    key: _beamerKey,
                    routerDelegate: delegate,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
