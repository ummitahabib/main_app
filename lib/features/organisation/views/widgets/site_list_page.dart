// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/site_option_menu.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SiteListPage extends StatefulHookConsumerWidget {
  const SiteListPage({super.key, required this.controller});
  final PageController controller;

  @override
  ConsumerState<SiteListPage> createState() => _SiteListPageState();
}

class _SiteListPageState extends ConsumerState<SiteListPage> {
  late SectorNotifier sectorNotifier;
  late SiteNotifier siteNotifier;
  @override
  void didChangeDependencies() {
    sectorNotifier = ref.watch(sectorProvider);
    siteNotifier = ref.watch(siteProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        final site = ref.watch(siteProvider);
        final scrollController = useScrollController();
        if (site.loading) {
          return const LoadingShimmer(
            ishorizontal: kIsWeb,
          );
        }
        if (site.siteList.isEmpty) {
          return const EmptyListWidget(
            text: noSiteFound,
          );
        }
        return kIsWeb
            ? ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  vertical: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size10,
                ),
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    radius: SpacingConstants.size20,
                    backgroundColor: AppColors.SmatCrowNeuBlue400,
                    foregroundImage: NetworkImage(DEFAULT_IMAGE),
                  ),
                  title: Text(
                    site.siteList[index].name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: SiteOptionMenu(
                      pageController: widget.controller,
                      site: site.siteList[index],
                      fromSite: true,
                    ),
                  ),
                  onTap: () async {
                    site.showSiteOptions = true;
                    ref.read(siteProvider).site = site.siteList[index];

                    unawaited(
                      ref.read(siteProvider).getSites(site.siteList[index].id),
                    );
                    // navigate to sector page
                    await ref.read(mapProvider).getSiteBounds();
                    ref.read(siteProvider).subType = SubType.sector;
                    Pandora().logAPPButtonClicksEvent('NAVIGATE_TO_SECTOR_PAGE');
                    await sectorNotifier.getSiteSectors(site.siteList[index].id);

                    return;
                  },
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: SpacingConstants.size20,
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: site.siteList.length,
              )
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size10,
                ),
                child: SizedBox(
                  height: SpacingConstants.size150,
                  child: ListView.separated(
                    shrinkWrap: true,
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () async {
                        site.showSiteOptions = true;
                        siteNotifier.site = site.siteList[index];
                        await siteNotifier.getSites(site.siteList[index].id);
                        siteNotifier.subType = SubType.sector;
                        await ref.read(mapProvider).getSiteBounds();
                        Pandora().logAPPButtonClicksEvent('NAVIGATE_TO_SECTOR_PAGE');
                        unawaited(sectorNotifier.getSiteSectors(site.siteList[index].id));

                        return;
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: SpacingConstants.size100 + SpacingConstants.size10,
                            height: SpacingConstants.size80,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(DEFAULT_IMAGE),
                              ),
                              borderRadius: BorderRadius.circular(
                                SpacingConstants.size20,
                              ),
                            ),
                          ),
                          Text(site.siteList[index].name)
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) => customSizedBoxWidth(SpacingConstants.size20),
                    itemCount: site.siteList.length,
                  ),
                ),
              );
      },
    );
  }
}
