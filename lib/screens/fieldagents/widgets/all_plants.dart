import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/feeds/models/paginated_plants_response.dart' as pResponse;
import 'package:smat_crow/screens/fieldagents/widgets/all_plants_item.dart';

import '../fieldagents_providers/all_plants_provider.dart';

class AllPlants extends StatefulWidget {
  const AllPlants({Key? key}) : super(key: key);

  @override
  _AllPlantsState createState() => _AllPlantsState();
}

class _AllPlantsState extends State<AllPlants> {
  @override
  void initState() {
    super.initState();
    Provider.of<AllPlantsProvider>(context, listen: false).pagingController.addPageRequestListener((pageKey) {
      Provider.of<AllPlantsProvider>(context, listen: false).fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    Provider.of<AllPlantsProvider>(context, listen: false).pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 500,
          child: PagedListView<int, pResponse.Datum>(
            pagingController: Provider.of<AllPlantsProvider>(context, listen: false).pagingController,
            builderDelegate: PagedChildBuilderDelegate<pResponse.Datum>(
              itemBuilder: (context, item, index) {
                return AllPlantsItem(plantId: item.id!);
              },
            ),
          ),
        )
      ],
    );
  }
}
