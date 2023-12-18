import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/data/controller/side_navigation_provider.dart';
import 'package:smat_crow/features/institution/views/institution_dashboard.dart';
import 'package:smat_crow/features/institution/views/institution_organization.dart';
import 'package:smat_crow/features/institution/views/institution_settings.dart';
import 'package:smat_crow/features/institution/views/mobile/side_menu.dart';

class InstDashboardViewMobile extends StatefulHookConsumerWidget {
  const InstDashboardViewMobile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DashboardViewMobileState();
}

class _DashboardViewMobileState extends ConsumerState<InstDashboardViewMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ref.watch(sideNavProvider.notifier).textHeader()),
        actions: [ref.watch(sideNavProvider.notifier).trailingicon(context)],
      ),
      drawer: const SideMenuMobile(),
      body: PageView(
        controller: ref.watch(sideNavProvider),
        physics: const NeverScrollableScrollPhysics(),
        children: const [InstitutionDashboard(), InstitutionOrganization(), InstitutionSettings()],
      ),
    );
  }
}
