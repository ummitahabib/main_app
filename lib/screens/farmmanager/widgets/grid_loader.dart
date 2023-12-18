import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class GridLoader extends StatelessWidget {
  const GridLoader({super.key, this.arrangement = 2});
  final int arrangement;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.size16),
        child: GridView.count(
          //to avoid scrolling conflict with the dragging sheet
          physics: const AlwaysScrollableScrollPhysics(),

          crossAxisCount: arrangement,
          mainAxisSpacing: SpacingConstants.font10,
          crossAxisSpacing: SpacingConstants.font10,
          childAspectRatio: SpacingConstants.size2,
          shrinkWrap: true,
          children: const <Widget>[
            GridLoaderItem(),
            GridLoaderItem(),
            GridLoaderItem(),
            GridLoaderItem(),
          ],
        ),
      ),
    );
  }
}

class GridLoaderItem extends StatelessWidget {
  const GridLoaderItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SpacingConstants.size100,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(SpacingConstants.size8),
      ),
    );
  }
}

class WrapLoader extends StatelessWidget {
  const WrapLoader({super.key, this.length});
  final int? length;
  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Wrap(
        runSpacing: SpacingConstants.double20,
        spacing: SpacingConstants.double20,
        children: List.generate(
          length ?? SpacingConstants.font10.toInt(),
          (index) => SizedBox(
            height: SpacingConstants.font48,
            width:
                Responsive.isMobile(context) ? null : Responsive.xWidth(context, percent: SpacingConstants.size0point1),
            child: const GridLoaderItem(),
          ),
        ),
      ),
    );
  }
}
