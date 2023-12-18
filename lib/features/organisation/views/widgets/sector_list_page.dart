import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/sector_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/sector_option_menu.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class SectorListPage extends StatelessWidget {
  const SectorListPage({super.key, required this.controller});
  final PageController controller;
  @override
  Widget build(BuildContext context) {
    return HookConsumer(
      builder: (context, ref, child) {
        final sector = ref.watch(sectorProvider);
        final scrollController = useScrollController();
        if (sector.loading) {
          return const LoadingShimmer(
            ishorizontal: kIsWeb,
          );
        }
        if (sector.sectorList.isEmpty) {
          return const EmptyListWidget(
            text: noSectorFound,
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
                    sector.sectorList[index].name,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Padding(
                    padding: const EdgeInsets.only(left: 50.0),
                    child: SectorOptionMenu(
                      pageController: controller,
                      sector: sector.sectorList[index],
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: SpacingConstants.size10,
                  ),
                  onTap: () {
                    // navigate to batch page
                    ref.read(sectorProvider).sector = sector.sectorList[index];
                    controller.jumpToPage(3);
                    ref.read(siteProvider).subType = SubType.batch;
                    ref
                        .read(batchProvider)
                        .getSectorBatches(sector.sectorList[index].id);
                    ref.read(siteProvider).showSiteOptions = false;
                  },
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: sector.sectorList.length,
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
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        controller.jumpToPage(4);
                        ref.read(sectorProvider).sector =
                            sector.sectorList[index];
                        ref.read(siteProvider).subType = SubType.batch;
                        ref
                            .read(batchProvider)
                            .getSectorBatches(sector.sectorList[index].id);
                        ref.read(siteProvider).showSiteOptions = false;
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
                          Text(sector.sectorList[index].name)
                        ],
                      ),
                    ),
                    separatorBuilder: (context, index) =>
                        customSizedBoxWidth(SpacingConstants.size20),
                    itemCount: sector.sectorList.length,
                  ),
                ),
              );
      },
    );
  }
}
