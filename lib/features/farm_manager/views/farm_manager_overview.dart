import 'package:flutter/widgets.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/farm_overview_mobile.dart';
import 'package:smat_crow/features/farm_manager/views/web/farm_overview_web.dart';
import 'package:smat_crow/utils2/responsive.dart';

class FarmManagerOverview extends StatelessWidget {
  const FarmManagerOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return const Responsive(
      mobile: FarmOverviewMobile(),
      tablet: FarmOverviewMobile(),
      desktop: FarmOverviewWeb(),
      desktopTablet: FarmOverviewWeb(),
    );
  }
}
