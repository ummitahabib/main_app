import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/views/web/agent_table_web.dart';
import 'package:smat_crow/features/institution/views/web/finance_dash_web.dart';
import 'package:smat_crow/features/institution/views/web/institution_menu.dart';
import 'package:smat_crow/features/institution/views/web/institution_site.dart';
import 'package:smat_crow/features/institution/views/web/instution_farm_asset.dart';
import 'package:smat_crow/features/institution/views/web/instution_farm_log.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/soil_info.dart';
import 'package:smat_crow/features/organisation/views/pages/site_map_options/weather_info.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_google_map.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';

import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';

class InstitutionOrgSite extends StatefulHookConsumerWidget {
  const InstitutionOrgSite({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InstitutionOrgSiteState();
}

class _InstitutionOrgSiteState extends ConsumerState<InstitutionOrgSite> {
  late SiteNotifier siteNotifier;
  @override
  void didChangeDependencies() {
    siteNotifier = ref.watch(siteProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final id = beamState.pathPatternSegments.last;
    final instPro = ref.watch(institutionProvider);
    useEffect(
      () {
        Future(() {
          siteNotifier.getOrganizationSites(id);
          ref.read(organizationProvider).getOrganizationById(id);
        });

        return null;
      },
      [],
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: HomeWebContainer(
            title: ref.watch(organizationProvider).organization == null
                ? ""
                : ref.watch(organizationProvider).organization!.name ?? "",
            leadingCallback: () {
              context.beamToNamed(ConfigRoute.institutionOrganizationPath);
            },
            width: Responsive.xWidth(context),
            trailingIcon: const SizedBox.shrink(),
            child: Container(
              decoration: const BoxDecoration(border: Border(right: BorderSide(color: AppColors.SmatCrowNeuBlue200))),
              child: instPro.showSiteMenu ? const InstitutionMenu() : const InstitutionSite(),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Builder(
            builder: (context) {
              if (instPro.selectedMenu == 1) {
                return const FinanceDashWeb();
              }
              if (instPro.selectedMenu == 0) {
                return const CustomGoogleMap();
              }
              if (instPro.selectedMenu == 2) {
                return const WeatherInfo(showCancelIcon: false);
              }
              if (instPro.selectedMenu == 3) {
                return const SoilInfo(showCancelIcon: false);
              }
              if (instPro.selectedMenu == 4) {
                return const InstutionFarmLog();
              }
              if (instPro.selectedMenu == 5) {
                return const InstutionFarmAsset();
              }
              if (instPro.selectedMenu == 6) {
                return const AgentTableWeb();
              }
              return Container();
            },
          ),
        )
      ],
    );
  }
}
