import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/utils/constants.dart';
import '../fieldagents_providers/field_agent_statistics_provider.dart';
import 'field_agent_statistics_carousel.dart';

class FieldAgentStatisticsCarouselHolder extends StatefulWidget {
  const FieldAgentStatisticsCarouselHolder({Key? key}) : super(key: key);

  @override
  _FieldAgentStatisticsCarouselHolderState createState() => _FieldAgentStatisticsCarouselHolderState();
}

class _FieldAgentStatisticsCarouselHolderState extends State<FieldAgentStatisticsCarouselHolder> {
  @override
  void initState() {
    super.initState();
    Provider.of<FieldAgentStatisticsProvider>(context, listen: false).getStatisticsData(USER_ID, context);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FieldAgentStatisticsProvider>(
      builder: (context, provider, child) {
        return FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SizedBox(
                  height: 200.0,
                  width: 200.0,
                  child: Lottie.asset('assets/animations/loading.json'),
                ),
              );
            } else {
              provider.populateContext(context);
              return FieldAgentStatisticsCarousel(fieldAgentGridItem: provider.partitionedData);
            }
          },
          future: provider.getStatisticsData(USER_ID, context),
        );
      },
    );
  }
}
