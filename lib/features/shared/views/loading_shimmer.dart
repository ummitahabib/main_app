import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    super.key,
    this.ishorizontal = true,
  });
  final bool ishorizontal;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.yHeight(context, percent: SpacingConstants.size0point4),
      child: Skeletonizer(
        child: ishorizontal
            ? ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    radius: SpacingConstants.size20,
                    backgroundColor: AppColors.SmatCrowNeuBlue400,
                    foregroundImage: NetworkImage(DEFAULT_IMAGE),
                  ),
                  title: const Text("..............."),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Container(width: SpacingConstants.size100)],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_horiz),
                    onPressed: () {},
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: SpacingConstants.size7.toInt(),
              )
            : ListView.separated(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: SpacingConstants.size100 + SpacingConstants.size10,
                      height: SpacingConstants.size80,
                      decoration: BoxDecoration(
                        color: AppColors.SmatCrowBlue50,
                        borderRadius: BorderRadius.circular(SpacingConstants.size20),
                      ),
                    ),
                    const Text("..................")
                  ],
                ),
                separatorBuilder: (context, index) => customSizedBoxWidth(SpacingConstants.size10),
                itemCount: SpacingConstants.size5.toInt(),
              ),
      ),
    );
  }
}

class GridLoadingShimmier extends StatelessWidget {
  const GridLoadingShimmier({super.key, required this.loading});
  final bool loading;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: loading,
      child: SizedBox(
        width: Responsive.xWidth(context),
        child: Padding(
          padding: const EdgeInsets.all(SpacingConstants.size20),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.5,
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
                      color: AppColors.SmatCrowBlue50,
                      borderRadius: BorderRadius.circular(SpacingConstants.size20),
                    ),
                  ),
                ],
              ),
            ),
            itemCount: 6,
          ),
        ),
      ),
    );
  }
}
