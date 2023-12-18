import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/map_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class BatchListPage extends HookConsumerWidget {
  const BatchListPage({super.key, required this.controller});
  final PageController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          ref.watch(mapProvider).getSectorBounds();
          ref.watch(mapProvider).showSitePolygon = true;
        });
        return null;
      },
      [],
    );
    return HookConsumer(
      builder: (context, ref, child) {
        final batch = ref.watch(batchProvider);
        final selectedIndex = useState(-1);
        if (batch.loading) {
          return const LoadingShimmer(
            ishorizontal: kIsWeb,
          );
        }
        if (batch.batchList.isEmpty) {
          return const EmptyListWidget(
            text: noBatchFound,
          );
        }
        return kIsWeb
            ? ListView.separated(
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => Container(
                  color: selectedIndex.value == index ? AppColors.SmatCrowPrimary100 : Colors.white,
                  child: ListTile(
                    selected: selectedIndex.value == index,
                    selectedTileColor: AppColors.SmatCrowPrimary100,
                    hoverColor: AppColors.SmatCrowPrimary50,
                    leading: CircleAvatar(
                      radius: SpacingConstants.size20,
                      backgroundColor: AppColors.SmatCrowNeuBlue400,
                      foregroundImage: NetworkImage(batch.batchList[index].imagePath ?? DEFAULT_IMAGE),
                    ),
                    title: Text(
                      batch.batchList[index].name ?? "",
                      overflow: TextOverflow.ellipsis,
                      style: Styles.smatCrowMediumSubParagraph(color: AppColors.SmatCrowNeuBlue900),
                    ),
                    onTap: () {
                      // navigate to batch page
                      selectedIndex.value = index;
                      ref.read(batchProvider).batch = batch.batchList[index];
                      ref.read(orgNavigationProvider).mapPageController.jumpToPage(3);
                      ref.watch(batchProvider).getBatchById(batch.batchList[index].id!);

                      return;
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size20),
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: batch.batchList.length,
              )
            : GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: Responsive.isTablet(context) ? SpacingConstants.int4 : SpacingConstants.int2,
                  mainAxisSpacing: SpacingConstants.size5,
                  crossAxisSpacing: SpacingConstants.size5,
                  childAspectRatio: 1.7,
                ),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) => InkWell(
                  onTap: () {
                    controller.jumpToPage(6);
                    ref.read(batchProvider).batch = batch.batchList[index];
                    ref.watch(batchProvider).getBatchById(batch.batchList[index].id!);
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: SpacingConstants.size112,
                        height: SpacingConstants.size80,
                        decoration: BoxDecoration(
                          image:
                              DecorationImage(image: NetworkImage(batch.batchList[index].imagePath ?? DEFAULT_IMAGE)),
                          borderRadius: BorderRadius.circular(SpacingConstants.size20),
                        ),
                      ),
                      Text(batch.batchList[index].name ?? "")
                    ],
                  ),
                ),
                itemCount: batch.batchList.length,
              );
      },
    );
  }
}
