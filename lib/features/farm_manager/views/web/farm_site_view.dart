// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_google_map.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FarmSiteView extends HookConsumerWidget {
  const FarmSiteView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final path = (context.currentBeamLocation.state as BeamState).uri.queryParameters;

    useEffect(
      () {
        if (path.isNotEmpty) {
          Future(() {
            if (ref.read(sharedProvider).userInfo == null) {
              ref.read(sharedProvider).getProfile();
            }
            ref.read(siteProvider).getOrganizationSites(path["orgId"] ?? "");
            ref.read(organizationProvider).getOrganizationById(path["orgId"] ?? "");
            // if (ref.read(farmManagerProvider).agentOrg == null) {
            //   Pandora().reRouteUser(context, farmManager, "");
            // }
          });
        }

        return null;
      },
      [],
    );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: HomeWebContainer(
            title: ref.watch(organizationProvider).organization == null
                ? ""
                : ref.watch(organizationProvider).organization!.name ?? "",
            trailingIcon: const SizedBox.shrink(),
            addSpacing: true,
            width: Responsive.xWidth(context),
            leadingCallback: () {
              context.beamToReplacementNamed(ConfigRoute.farmManager);
            },
            child: HookConsumer(
              builder: (context, ref, child) {
                final site = ref.watch(siteProvider);
                final scrollController = useScrollController();
                if (site.loading) {
                  return const LoadingShimmer(ishorizontal: kIsWeb);
                }
                if (site.siteList.isEmpty) {
                  return const EmptyListWidget(
                    text: noSiteFound,
                    asset: AppAssets.emptyImage,
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
                          onTap: () async {
                            ref.read(siteProvider).site = site.siteList[index];
                            final id = await ref.read(sharedProvider).getOrganizationId();
                            Pandora().logAPPButtonClicksEvent(
                              'NAVIGATE_TO_FARM_OVERVIEW_PAGE',
                            );
                            Pandora().reRouteUser(
                              context,
                              "${ConfigRoute.farmManagerOverview}/$id",
                              id,
                            );
                            unawaited(
                              Pandora().saveToSharedPreferences(
                                "siteId",
                                site.siteList[index].id,
                              ),
                            );
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
                                ref.read(siteProvider).site = site.siteList[index];
                                await ref.read(siteProvider).getSites(site.siteList[index].id);
                                final id = await ref.read(sharedProvider).getOrganizationId();
                                Pandora().logAPPButtonClicksEvent(
                                  'NAVIGATE_TO_FARM_OVERVIEW_PAGE',
                                );
                                Pandora().reRouteUser(
                                  context,
                                  "${ConfigRoute.farmManagerOverview}/$id",
                                  id,
                                );
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
                            separatorBuilder: (context, index) => customSizedBoxWidth(
                              SpacingConstants.size20,
                            ),
                            itemCount: site.siteList.length,
                          ),
                        ),
                      );
              },
            ),
          ),
        ),
        const Expanded(flex: 2, child: CustomGoogleMap())
      ],
    );
  }
}
