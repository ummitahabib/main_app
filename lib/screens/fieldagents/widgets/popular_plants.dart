import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/responsive.dart';

import '../fieldagents_providers/popular_plant_provider.dart';

class PopularPlants extends StatefulWidget {
  const PopularPlants({Key? key}) : super(key: key);

  @override
  _PopularPlantsState createState() => _PopularPlantsState();
}

class _PopularPlantsState extends State<PopularPlants> {
  @override
  void initState() {
    super.initState();
    Provider.of<PopularPlantsProvider>(context, listen: false).fetchPopularPlants(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PopularPlantsProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  children: List.filled(
                    10,
                    Skeletonizer(
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                        color: AppColors.SmatCrowNeuBlue500,
                        elevation: 0,
                        shadowColor: Colors.black.withOpacity(0.6),
                        child: const SizedBox(
                          width: 150,
                          height: 200,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Responsive.isDesktop(context)
                    ? 4
                    : Responsive.isTablet(context)
                        ? 3
                        : 2,
              ),
              shrinkWrap: true,
              itemCount: provider.plantsItem.length,
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return provider.plantsItem[index];
              },
            );
          },
          future: provider.fetchPopularPlants(context),
        );
      },
    );
  }
}
