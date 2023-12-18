// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_card_bar.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/presentation/pages/profile/edit_profile_page.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class FieldDraggableSheet extends StatefulHookConsumerWidget {
  const FieldDraggableSheet({
    super.key,
  });

  @override
  ConsumerState<FieldDraggableSheet> createState() => _DraggableSheetState();
}

class _DraggableSheetState extends ConsumerState<FieldDraggableSheet> {
  final draggableScrollableController = DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.4,
      maxChildSize: 0.8,
      controller: draggableScrollableController,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(SpacingConstants.size20),
          topRight: Radius.circular(SpacingConstants.size20),
        ),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(SpacingConstants.size20),
              topRight: Radius.circular(SpacingConstants.size20),
            ),
          ),
          child: ListView(
            controller: scrollController,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            children: [
              const ModalStick(),
              CustomCardBar(
                title: ref.watch(organizationProvider).organization == null
                    ? ""
                    : ref.watch(organizationProvider).organization!.name ?? "",
                elevation: 0,
                center: true,
                trailingIcon: const SizedBox.shrink(),
              ),
              SizedBox(height: Responsive.isTablet(context) ? SpacingConstants.size40 : SpacingConstants.size10),
              HookConsumer(
                builder: (context, ref, child) {
                  final site = ref.watch(siteProvider);
                  final scrollController = useScrollController();
                  useEffect(
                    () {
                      Future(() async {
                        final id = await Pandora().getFromSharedPreferences("orgId");
                        await ref.read(siteProvider).getOrganizationSites(id);
                        await ref.read(organizationProvider).getOrganizationById(id);
                      });
                      return null;
                    },
                    [],
                  );
                  if (site.loading) {
                    return const LoadingShimmer(ishorizontal: false);
                  }
                  if (site.siteList.isEmpty) {
                    return const EmptyListWidget(text: noSiteFound);
                  }
                  return Padding(
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
                            final id = await ref.read(sharedProvider).getOrganizationId();
                            Pandora().logAPPButtonClicksEvent('NAVIGATE_TO_FARM_OVERVIEW_PAGE');
                            unawaited(Pandora().saveToSharedPreferences("siteId", site.siteList[index].id));
                            if (Responsive.isDesktop(context)) {
                              Pandora().reRouteUser(context, "${ConfigRoute.farmManagerOverview}/$id", id);
                            } else {
                              Pandora().reRouteUser(context, ConfigRoute.farmManagerOverview, id);
                            }
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
