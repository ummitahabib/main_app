import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_card_bar.dart';
import 'package:smat_crow/features/organisation/views/widgets/sector_list_page.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_list_page.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_option_menu.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SiteMainPage extends HookConsumerWidget {
  const SiteMainPage({
    super.key,
    required this.pageController,
  });
  final PageController pageController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final org = ref.watch(organizationProvider).organization;
    final site = ref.watch(siteProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCardBar(
            title: org == null
                ? ""
                : (site.subType == SubType.site)
                    ? (ref.read(organizationProvider).organization!.name ?? "")
                    : (site.subType == SubType.sector)
                        ? site.site!.name
                        : "",
            elevation: 0,
            leadingCallback: () {
              if (site.subType == SubType.sector) {
                site.subType = SubType.site;
                return;
              }
              ref.read(siteProvider).showSiteOptions = false;
              Navigator.pop(context);
            },
            trailingIcon: (ref.read(siteProvider).subType == SubType.sector)
                ? SiteOptionMenu(
                    pageController: pageController,
                    site: ref.read(siteProvider).site,
                    fromSite: true,
                  )
                : null,
            trailingCallback: ref.read(siteProvider).subType == SubType.sector
                ? null
                : () {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeIn,
                    );
                  },
            center: true,
          ),
          SizedBox(height: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size10),
          if (ref.read(siteProvider).subType == SubType.site)
            SiteListPage(controller: pageController)
          else
            SectorListPage(controller: pageController)
        ],
      ),
    );
  }
}
