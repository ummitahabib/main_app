import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/features/institution/data/controller/institution_controller.dart';
import 'package:smat_crow/features/institution/views/widgets/menu_body.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class InstitutionSite extends StatelessWidget {
  const InstitutionSite({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        final site = ref.watch(siteProvider);
        if (ref.watch(siteProvider).loading) {
          return const LoadingShimmer(ishorizontal: kIsWeb);
        }
        if (site.siteList.isEmpty) {
          return SizedBox(
            height: Responsive.isMobile(context)
                ? null
                : Responsive.yHeight(context, percent: 0.7),
            child: const EmptyListWidget(
              text: noSiteFound,
            ),
          );
        }
        return kIsWeb
            ? ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(
                  vertical: Responsive.isTablet(context)
                      ? SpacingConstants.size40
                      : SpacingConstants.size10,
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
                  onTap: () {
                    ref.read(institutionProvider).showSiteMenu = true;
                    ref.read(siteProvider).site = site.siteList[index];
                    ref.read(siteProvider).getSites(site.siteList[index].id);
                    ref.read(mapProvider).getSiteBounds();
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
                  horizontal: Responsive.isTablet(context)
                      ? SpacingConstants.size40
                      : SpacingConstants.size10,
                ),
                child: SizedBox(
                  height: SpacingConstants.size150,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        ref.read(siteProvider).site = site.siteList[index];
                        ref
                            .read(siteProvider)
                            .getSites(site.siteList[index].id);
                        ref.read(mapProvider).getSiteBounds();
                        if (Responsive.isTablet(context)) {
                          customDialog(
                            context,
                            HookBuilder(
                              builder: (context) {
                                final selectedMenu = useState(0);
                                return Padding(
                                  padding: const EdgeInsets.only(
                                    left: SpacingConstants.font10,
                                    bottom: SpacingConstants.font10,
                                  ),
                                  child: MenuBody(
                                    isMobile: false,
                                    selectedMenu: selectedMenu,
                                  ),
                                );
                              },
                            ),
                          );
                          return;
                        }
                        Pandora().reRouteUser(
                          context,
                          ConfigRoute.institutionOrganizationMenuPath,
                          "args",
                        );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: SpacingConstants.size100 +
                                SpacingConstants.size10,
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
                    separatorBuilder: (context, index) =>
                        customSizedBoxWidth(SpacingConstants.size20),
                    itemCount: site.siteList.length,
                  ),
                ),
              );
      },
    );
  }
}
