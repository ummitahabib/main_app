import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../utils/strings.dart';
import '../../../utils/styles.dart';

import '../fieldagents_providers/field_agent_sites_list_provider.dart';

class FieldAgentSitesList extends StatefulWidget {
  const FieldAgentSitesList({Key? key, this.getSelectedId, required this.organizationId}) : super(key: key);
  final String organizationId;
  final getSelectedId;

  @override
  State<StatefulWidget> createState() {
    return _FieldAgentSitesListState();
  }
}

class _FieldAgentSitesListState extends State<FieldAgentSitesList> {
  @override
  void initState() {
    super.initState();
    Provider.of<FieldAgentSitesProvider>(context).getSitesInOrganizations(widget.organizationId);
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: Provider.of<FieldAgentSitesProvider>(context).getSitesInOrganizations(widget.organizationId),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          unAvailabeSite,
        ),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showResponse() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: ListView.separated(
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(width: 12);
              },
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: Provider.of<FieldAgentSitesProvider>(context).sites.length,
              itemBuilder: (context, index) {
                return Provider.of<FieldAgentSitesProvider>(context).sites[index];
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _showLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              height: 200,
              width: 200,
              decoration: Styles.containerDecoGrey(),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: Styles.containerDecoGrey(),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: Styles.containerDecoGrey(),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: Styles.containerDecoGrey(),
            )
          ],
        ),
      ),
    );
  }
}
