import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/organization_more_option.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/network/crow/models/organization_by_id_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

final _pandora = Pandora();

class OrganizationListView extends StatefulHookConsumerWidget {
  const OrganizationListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrganizationListViewState();
}

class _OrganizationListViewState extends ConsumerState<OrganizationListView> {
  late OrganizationNotifier organizationNotifier;
  @override
  void didChangeDependencies() {
    organizationNotifier = ref.read(organizationProvider);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = useState(0);
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: kIsWeb ? SpacingConstants.size0 : SpacingConstants.size20),
          child: HookConsumer(
            builder: (context, ref, child) {
              final org = ref.read(organizationProvider).organizationList;
              if (ref.watch(organizationProvider).loading) {
                return const LoadingShimmer();
              }
              if (org.isEmpty) {
                return SizedBox(
                  height: Responsive.yHeight(context, percent: 0.7),
                  child: const EmptyListWidget(
                    text: noOrgFound,
                    asset: AppAssets.emptyImage,
                  ),
                );
              }
              return RefreshIndicator(
                onRefresh: () => ref.read(organizationProvider).getUserOrganizations(),
                child: ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      radius: SpacingConstants.size20,
                      foregroundImage: NetworkImage(org[index].image ?? DEFAULT_IMAGE),
                    ),
                    title: Text(
                      org[index].name ?? "",
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(AppAssets.location),
                        const SizedBox(width: SpacingConstants.size5),
                        Flexible(
                          child: Text(
                            org[index].address ?? "",
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size10),
                    trailing: IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () {
                        Pandora().logAPPButtonClicksEvent('DISPLAY_OPTION_MENU');

                        organizationNotifier.getOrganizationById(org[index].id ?? "");
                        selectedIndex.value = index;
                        organizationNotifier.visible = true;
                      },
                    ),
                    onTap: () {
                      if (Responsive.isDesktop(context)) {
                        ref.read(orgNavigationProvider).pageController.animateToPage(
                              1,
                              duration: const Duration(milliseconds: SpacingConstants.int400),
                              curve: Curves.easeIn,
                            );
                      } else {
                        ref.read(mapProvider).getCurrentPosition();
                        _pandora.reRouteUser(context, ConfigRoute.siteDetails, 'null');
                      }
                      ref.read(siteProvider).subType = SubType.site;
                      Pandora().logAPPButtonClicksEvent('NAVIGATE_TO_SITE_PAGE');
                      ref.read(siteProvider).getOrganizationSites(org[index].id ?? "");
                      ref.read(organizationProvider).organization = GetOrganizationById(
                        sites: [],
                        organizationUsers: org[index].organizationUsers,
                        id: org[index].id,
                        name: org[index].name,
                        longDescription: org[index].longDescription,
                        shortDescription: org[index].shortDescription,
                        image: org[index].image ?? DEFAULT_IMAGE,
                        address: org[index].address,
                        industry: org[index].industry,
                        user: org[index].user,
                        createdAt: org[index].createdAt ?? DateTime.now(),
                        updatedAt: org[index].updatedAt ?? DateTime.now(),
                        v: org[index].v ?? 0,
                      );
                    },
                  ),
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: org.length,
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: ref.watch(organizationProvider).visible,
          child: Container(
            color: AppColors.SmatCrowBlack400.withOpacity(0.4),
          ),
        ),
        Visibility(
          visible: ref.watch(organizationProvider).visible,
          child: const OrganizationMoreOption(),
        )
      ],
    );
  }
}
