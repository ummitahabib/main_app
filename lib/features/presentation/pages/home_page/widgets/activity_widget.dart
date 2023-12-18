import 'package:flutter/material.dart';
import 'package:smat_crow/features/presentation/pages/home_page/widgets/activity_grid_item.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

//activity widget

class ActivityWidgets extends StatelessWidget {
  const ActivityWidgets({super.key});

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: _buildGridView(
        context,
        crossAxisCount: SpacingConstants.int3,
        childAspectRatio: SpacingConstants.double1,
        mainAxisSpacing: SpacingConstants.double1,
        crossAxisSpacing: SpacingConstants.double0,
      ),
      tablet: _buildGridView(
        context,
        crossAxisCount: SpacingConstants.int5,
        childAspectRatio: SpacingConstants.double1,
        mainAxisSpacing: SpacingConstants.double1,
        crossAxisSpacing: SpacingConstants.double1,
      ),
      desktop: _buildGridView(
        context,
        crossAxisCount: SpacingConstants.int7,
        childAspectRatio: SpacingConstants.double1,
        mainAxisSpacing: SpacingConstants.double1,
        crossAxisSpacing: SpacingConstants.double1,
      ),
    );
  }

  Widget _buildGridView(
    BuildContext context, {
    required int crossAxisCount,
    required double childAspectRatio,
    required double mainAxisSpacing,
    required double crossAxisSpacing,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: dashboardMenuList.length,
      itemBuilder: (BuildContext context, int index) {
        final dashboardMenuItem = dashboardMenuList[index];
        return DashboardGridItem(
          name: dashboardMenuItem[DasbordGridItem.name],
          background: dashboardMenuItem[DasbordGridItem.background],
          image: dashboardMenuItem[DasbordGridItem.image],
          route: dashboardMenuItem[DasbordGridItem.route],
        );
      },
    );
  }
}
