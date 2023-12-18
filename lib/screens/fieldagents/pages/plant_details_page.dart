import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:smat_crow/screens/fieldagents/fieldagents_providers/plant_detail_provider.dart';

class PlantDetailsPage extends StatefulWidget {
  const PlantDetailsPage({Key? key, required this.plantIdentifier}) : super(key: key);
  final String plantIdentifier;

  @override
  _PlantDetailsPageState createState() => _PlantDetailsPageState();
}

class _PlantDetailsPageState extends State<PlantDetailsPage> {
  late PlantDetailProvider plantDetailProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    plantDetailProvider = Provider.of<PlantDetailProvider>(context, listen: false);
    if (kIsWeb) {
      final id = (context.currentBeamLocation.state as BeamState).pathPatternSegments.last;
      plantDetailProvider.fetchPlantDetails(id, context);
    } else {
      plantDetailProvider.fetchPlantDetails(widget.plantIdentifier, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Provider.of<PlantDetailProvider>(context, listen: false).plantDetailContainer(context, widget);
  }
}
