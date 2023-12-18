import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/views/pages/mobile/site_details_mobile.dart';
import 'package:smat_crow/features/organisation/views/pages/web/site_details_web.dart';
import 'package:smat_crow/utils2/responsive.dart';

class SiteDetails extends HookConsumerWidget {
  const SiteDetails({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Responsive(
      mobile: SiteDetailMobile(),
      tablet: SiteDetailMobile(),
      desktop: SiteDetailsWeb(),
      desktopTablet: SiteDetailsWeb(),
    );
  }
}
