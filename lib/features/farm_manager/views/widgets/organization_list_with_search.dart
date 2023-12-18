// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/network/crow/models/organization_by_id_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class OrganizationListWithSearch extends HookConsumerWidget {
  const OrganizationListWithSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shared = ref.watch(sharedProvider);
    useEffect(
      () {
        Future(() => shared.getOrganizationList());
        return null;
      },
      [],
    );
    return SizedBox(
      height: Responsive.yHeight(context, percent: 0.85),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: SpacingConstants.size20,
              vertical: SpacingConstants.font10,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ModalStick(),
                if (!Responsive.isDesktop(context)) const Ymargin(SpacingConstants.size30),
                if (Responsive.isDesktop(context))
                  DialogHeader(
                    headText: selectOrgText,
                    callback: () {
                      if (Responsive.isDesktop(context)) {
                        OneContext().popDialog();
                      } else {
                        Navigator.pop(context);
                      }
                    },
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    padding: EdgeInsets.zero,
                    showDivider: false,
                  )
                else
                  const BoldHeaderText(text: selectOrgText),
                const Ymargin(SpacingConstants.size10),
                // CustomTextField(
                //   hintText: searchForOrgText,
                //   onChanged: (value) {
                //     // ref.watch(organizationProvider).organizationList = ref
                //     //     .watch(organizationProvider)
                //     //     .organizationList
                //     //     .where((element) => element.name.toLowerCase().contains(value.toLowerCase()))
                //     //     .toList();
                //   },
                //   text: "",
                //   keyboardType: TextInputType.text,
                // ),
                // const Ymargin(SpacingConstants.size10),
              ],
            ),
          ),
          SizedBox(
            height: Responsive.yHeight(context, percent: 0.6),
            child: Builder(
              builder: (context) {
                if (shared.userInfo != null && shared.userInfo!.user.role.role == UserRole.agent.name) {
                  return HookConsumer(
                    builder: (context, ref, child) {
                      final manager = ref.watch(farmManagerProvider);
                      if (manager.loading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                          child: LoadingShimmer(),
                        );
                      }
                      if (manager.agentOrgList.isEmpty) {
                        return SizedBox(
                          height: Responsive.yHeight(context, percent: 0.7),
                          child: const EmptyListWidget(
                            text: noOrgFound,
                            asset: AppAssets.emptyImage,
                          ),
                        );
                      }
                      final selectedIndex = useState<int>(-1);
                      final list = manager.agentOrgList;
                      return RefreshIndicator(
                        onRefresh: () => manager.getAgentOrg(),
                        child: ListView.separated(
                          itemBuilder: (context, index) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: SpacingConstants.size20,
                                  foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                ),
                                title: Text(
                                  list[index].user!.fullName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down),
                                contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                                onTap: () {
                                  selectedIndex.value = index;
                                },
                              ),
                              if (selectedIndex.value == index)
                                ...list[index].organizations!.map(
                                      (e) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              radius: SpacingConstants.size15,
                                              foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(horizontal: SpacingConstants.size70),
                                            title: Text(
                                              e.organizations!.organizationName ?? "",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () async {
                                              ref.read(farmManagerProvider).agentOrg = e;
                                              await Pandora().saveToSharedPreferences(
                                                  "orgId", e.organizations!.organizationId ?? "");
                                              if (kIsWeb) {
                                                OneContext().popDialog();
                                                Pandora().reRouteUser(
                                                  context,
                                                  "${ConfigRoute.farmManagerSiteView}?orgId=${e.organizations!.organizationId ?? ""}",
                                                  {"orgId": e.organizations!.organizationId ?? ""},
                                                );
                                              } else {
                                                await Navigator.pushNamed(context, ConfigRoute.farmManagerSiteView);
                                              }
                                              unawaited(
                                                ref
                                                    .read(siteProvider)
                                                    .getOrganizationSites(e.organizations!.organizationId ?? ""),
                                              );
                                              unawaited(
                                                ref
                                                    .read(organizationProvider)
                                                    .getOrganizationById(e.organizations!.organizationId ?? ""),
                                              );
                                            },
                                          ),
                                          if (e != list[index].organizations!.last) const Divider()
                                        ],
                                      ),
                                    )
                            ],
                          ),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: list.length,
                        ),
                      );
                    },
                  );
                }
                if (shared.userInfo != null && shared.userInfo!.user.role.role == UserRole.institution.name) {
                  return HookConsumer(
                    builder: (context, ref, child) {
                      final inst = ref.watch(institutionProvider);
                      if (inst.loading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                          child: LoadingShimmer(),
                        );
                      }
                      if (inst.institutionOrgList.isEmpty) {
                        return SizedBox(
                          height: Responsive.yHeight(context, percent: 0.7),
                          child: const EmptyListWidget(
                            text: noOrgFound,
                            asset: AppAssets.emptyImage,
                          ),
                        );
                      }
                      final selectedIndex = useState<int>(-1);
                      final list = inst.institutionOrgList;
                      return RefreshIndicator(
                        onRefresh: () => inst.getInstitutionOrg(),
                        child: ListView.separated(
                          itemBuilder: (context, index) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: SpacingConstants.size20,
                                  foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                ),
                                title: Text(
                                  list[index].user!.fullName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down),
                                contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                                onTap: () {
                                  selectedIndex.value = index;
                                },
                              ),
                              if (selectedIndex.value == index)
                                ...list[index].organizations!.map(
                                      (e) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              radius: SpacingConstants.size15,
                                              foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(horizontal: SpacingConstants.size70),
                                            title: Text(
                                              e.organizationName ?? "",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () async {
                                              await Pandora().saveToSharedPreferences("orgId", e.organizationId ?? "");
                                              if (kIsWeb) {
                                                OneContext().popDialog();
                                                Pandora().reRouteUser(
                                                  context,
                                                  "${ConfigRoute.farmManagerSiteView}?orgId=${e.organizationId}",
                                                  {"orgId": e.organizationId},
                                                );
                                              } else {
                                                await Navigator.pushNamed(context, ConfigRoute.farmManagerSiteView);
                                              }
                                              unawaited(
                                                ref.read(siteProvider).getOrganizationSites(e.organizationId ?? ""),
                                              );

                                              ref.read(institutionProvider).instOrganization = e;
                                              ref.read(organizationProvider).organization = GetOrganizationById(
                                                sites: [],
                                                organizationUsers: [],
                                                id: e.organizationId ?? "",
                                                name: e.organizationName ?? "",
                                                longDescription: '',
                                                shortDescription: "",
                                                image: DEFAULT_IMAGE,
                                                address: "",
                                                industry: "",
                                                user: e.organizationUserId ?? "",
                                                createdAt: e.createdDate ?? DateTime.now(),
                                                updatedAt: e.modifiedDate ?? DateTime.now(),
                                                v: 0,
                                              );
                                            },
                                          ),
                                          if (e != list[index].organizations!.last) const Divider()
                                        ],
                                      ),
                                    )
                            ],
                          ),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: list.length,
                        ),
                      );
                    },
                  );
                }
                if (shared.userInfo != null && shared.userInfo!.user.role.role == UserRole.institution.name) {
                  return HookConsumer(
                    builder: (context, ref, child) {
                      final inst = ref.watch(institutionProvider);
                      if (inst.loading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                          child: LoadingShimmer(),
                        );
                      }
                      if (inst.institutionOrgList.isEmpty) {
                        return SizedBox(
                          height: Responsive.yHeight(context, percent: 0.7),
                          child: const EmptyListWidget(
                            text: noOrgFound,
                            asset: AppAssets.emptyImage,
                          ),
                        );
                      }
                      final selectedIndex = useState<int>(-1);
                      final list = inst.institutionOrgList;
                      return RefreshIndicator(
                        onRefresh: () => inst.getInstitutionOrg(),
                        child: ListView.separated(
                          itemBuilder: (context, index) => Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: SpacingConstants.size20,
                                  foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                ),
                                title: Text(
                                  list[index].user!.fullName ?? "",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing: const Icon(Icons.keyboard_arrow_down),
                                contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                                onTap: () {
                                  selectedIndex.value = index;
                                },
                              ),
                              if (selectedIndex.value == index)
                                ...list[index].organizations!.map(
                                      (e) => Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: CircleAvatar(
                                              radius: SpacingConstants.size15,
                                              foregroundImage: NetworkImage(DEFAULT_IMAGE),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.symmetric(horizontal: SpacingConstants.size70),
                                            title: Text(
                                              e.organizationName ?? "",
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            onTap: () async {
                                              await Pandora().saveToSharedPreferences("orgId", e.organizationId ?? "");
                                              if (kIsWeb) {
                                                OneContext().popDialog();
                                                Pandora().reRouteUser(
                                                  context,
                                                  "${ConfigRoute.farmManagerSiteView}?orgId=${e.organizationId}",
                                                  {"orgId": e.organizationId},
                                                );
                                              } else {
                                                await Navigator.pushNamed(context, ConfigRoute.farmManagerSiteView);
                                              }
                                              unawaited(
                                                ref.read(siteProvider).getOrganizationSites(e.organizationId ?? ""),
                                              );

                                              ref.read(institutionProvider).instOrganization = e;
                                              ref.read(organizationProvider).organization = GetOrganizationById(
                                                sites: [],
                                                organizationUsers: [],
                                                id: e.organizationId ?? "",
                                                name: e.organizationName ?? "",
                                                longDescription: '',
                                                shortDescription: "",
                                                image: DEFAULT_IMAGE,
                                                address: "",
                                                industry: "",
                                                user: e.organizationUserId ?? "",
                                                createdAt: e.createdDate ?? DateTime.now(),
                                                updatedAt: e.modifiedDate ?? DateTime.now(),
                                                v: 0,
                                              );
                                            },
                                          ),
                                          if (e != list[index].organizations!.last) const Divider()
                                        ],
                                      ),
                                    )
                            ],
                          ),
                          separatorBuilder: (context, index) => const Divider(),
                          itemCount: list.length,
                        ),
                      );
                    },
                  );
                }
                return HookConsumer(
                  builder: (context, ref, child) {
                    final org = ref.read(organizationProvider).organizationList;
                    if (ref.watch(organizationProvider).loading) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                        child: LoadingShimmer(),
                      );
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
                          contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                          onTap: () async {
                            await Pandora().saveToSharedPreferences("orgId", org[index].id ?? "");
                            if (kIsWeb) {
                              OneContext().popDialog();
                              Pandora().reRouteUser(
                                context,
                                "${ConfigRoute.farmManagerSiteView}?orgId=${org[index].id}",
                                {"orgId": org[index].id},
                              );
                            } else {
                              await Navigator.pushNamed(context, ConfigRoute.farmManagerSiteView);
                            }

                            ref.read(organizationProvider).organization = GetOrganizationById(
                              sites: [],
                              organizationUsers: org[index].organizationUsers ?? [],
                              id: org[index].id ?? "",
                              name: org[index].name ?? "",
                              longDescription: org[index].longDescription ?? "",
                              shortDescription: org[index].shortDescription ?? "",
                              image: org[index].image ?? DEFAULT_IMAGE,
                              address: org[index].address ?? "",
                              industry: org[index].industry ?? "",
                              user: org[index].user ?? "",
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
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
