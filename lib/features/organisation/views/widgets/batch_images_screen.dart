import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/organisation/data/controller/batch_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/navigation_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/batch_option_menu.dart';
import 'package:smat_crow/features/organisation/views/widgets/empty_list_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/home_web_container.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class BatchImagesScreen extends HookConsumerWidget {
  const BatchImagesScreen({
    super.key,
    required this.controller,
  });
  final PageController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HomeWebContainer(
      title: ref.read(batchProvider).batch == null ? emptyString : ref.read(batchProvider).batch!.name ?? emptyString,
      trailingIcon: Padding(
        padding: const EdgeInsets.only(right: SpacingConstants.size20),
        child: BatchOptionMenu(
          pageController: kIsWeb ? ref.read(orgNavigationProvider).pageController : controller,
        ),
      ),
      center: true,
      elevation: kIsWeb ? null : 0,
      leadingCallback: kIsWeb
          ? null
          : () {
              controller.jumpToPage(4);
            },
      width: Responsive.xWidth(context),
      childHeight: Responsive.yHeight(context, percent: kIsWeb ? 0.75 : 0.4),
      child: HookConsumer(
        builder: (context, ref, child) {
          final batch = ref.watch(batchProvider);
          if (batch.loading) {
            return GridLoadingShimmier(
              loading: batch.loading,
            );
          }
          if (batch.batch != null && batch.batch!.images!.isEmpty) {
            return const EmptyListWidget(text: noImageFound);
          }
          return Padding(
            padding: const EdgeInsets.only(
              left: SpacingConstants.size20,
              right: SpacingConstants.size20,
              top: SpacingConstants.size20,
            ),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: SpacingConstants.int3,
                crossAxisSpacing: SpacingConstants.size10,
                mainAxisSpacing: SpacingConstants.size10,
                childAspectRatio: SpacingConstants.int3.toDouble(),
              ),
              shrinkWrap: true,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => InkWell(
                onTap: () {},
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SpacingConstants.size100 + SpacingConstants.size10,
                      height: SpacingConstants.size80,
                      decoration: BoxDecoration(
                        image: DecorationImage(image: NetworkImage(DEFAULT_IMAGE)),
                        borderRadius: BorderRadius.circular(SpacingConstants.size20),
                      ),
                    ),
                  ],
                ),
              ),
              itemCount: batch.batch!.images!.length,
            ),
          );
        },
      ),
    );
  }
}
