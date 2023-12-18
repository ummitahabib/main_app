import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/pages/web/create_new_site_web.dart';
import 'package:smat_crow/features/organisation/views/widgets/batch_list_page.dart';
import 'package:smat_crow/features/organisation/views/widgets/create_batch.dart';
import 'package:smat_crow/features/organisation/views/widgets/edit_site.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/organisation/views/widgets/sector_list_page.dart';
import 'package:smat_crow/features/organisation/views/widgets/sector_option_menu.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_list_page.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_option_menu.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SiteDetailsWeb extends StatefulHookConsumerWidget {
  const SiteDetailsWeb({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SiteDetailsWebState();
}

class _SiteDetailsWebState extends ConsumerState<SiteDetailsWeb> {
  late MapNotifier mapNotifier;
  late SiteNotifier siteNotifier;
  @override
  void didChangeDependencies() {
    mapNotifier = ref.watch(mapProvider);
    siteNotifier = ref.watch(siteProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final site = ref.watch(siteProvider);
    final pageController = usePageController();
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          site.subType = SubType.site;
        });

        return null;
      },
      [],
    );
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        HomeWebContainer(
          title: ref.watch(organizationProvider).organization == null
              ? ""
              : (site.subType == SubType.site)
                  ? (ref.watch(organizationProvider).organization!.name ?? "")
                  : (site.subType == SubType.sector)
                      ? site.site!.name
                      : "",
          trailingIcon: (ref.watch(siteProvider).subType == SubType.sector)
              ? SiteOptionMenu(
                  pageController: pageController,
                  site: ref.watch(siteProvider).site,
                  fromSite: true,
                )
              : null,
          addSpacing: true,
          width: Responsive.xWidth(context),
          leadingCallback: () {
            ref.read(siteProvider).showSiteOptions = false;
            if (site.subType == SubType.sector) {
              site.subType = SubType.site;
              return;
            }

            ref.read(orgNavigationProvider).pageController.animateToPage(
                  0,
                  duration: const Duration(milliseconds: SpacingConstants.int400),
                  curve: Curves.easeIn,
                );
          },
          trailingCallback: ref.watch(siteProvider).subType == SubType.sector
              ? null
              : () {
                  pageController.animateToPage(
                    1,
                    duration: const Duration(milliseconds: SpacingConstants.int400),
                    curve: Curves.easeIn,
                  );
                  ref.read(mapProvider).allowMapTap = true;
                },
          child: (ref.watch(siteProvider).subType == SubType.site)
              ? SiteListPage(controller: pageController)
              : SectorListPage(controller: pageController),
        ),
        CreateNewSiteWeb(
          pageController: pageController,
        ),
        EditSite(pageController: pageController),
        HomeWebContainer(
          title: ref.watch(sectorProvider).sector == null ? emptyString : ref.watch(sectorProvider).sector!.name,
          leadingCallback: () {
            ref.read(siteProvider).subType = SubType.sector;
            pageController.jumpToPage(0);
            ref.read(batchProvider).showBatchInfo = false;
            if (kIsWeb) {
              ref.read(orgNavigationProvider).mapPageController.jumpToPage(0);
              Future.delayed(
                const Duration(seconds: 1),
                () {
                  ref.read(mapProvider).getSectorBounds();
                },
              );
            }
          },
          width: Responsive.xWidth(context),
          trailingIcon: SectorOptionMenu(
            pageController: pageController,
            sector: ref.watch(sectorProvider).sector,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: SpacingConstants.size10,
            ),
            child: BatchListPage(controller: pageController),
          ),
        ),
        CreateBatch(pageController: pageController),
      ],
    );
  }
}
