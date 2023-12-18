import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/sites_operations.dart';
import 'package:smat_crow/utils2/constants.dart';

import 'sites_item.dart';

class SitesList extends StatefulWidget {
  const SitesList({Key? key, this.getSelectedId, required this.organizationId}) : super(key: key);
  final String organizationId;
  final getSelectedId;

  @override
  State<StatefulWidget> createState() {
    return _SitesListState();
  }
}

class _SitesListState extends State<SitesList> {
  bool loading = true;
  List<Widget> sites = [];
  String siteId = emptyString, siteName = emptyString;
  int sectorCount = 0;
  bool clickedSite = false;

  void _updateSiteId(String id, String name, int count, bool isTapped) {
    setState(() {
      siteId = id;
      siteName = name;
      sectorCount = count;
      clickedSite = isTapped;
      widget.getSelectedId(siteId, siteName, sectorCount, clickedSite);
    });
  }

  @override
  void initState() {
    super.initState();
    getSitesInOrganizations(widget.organizationId);
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: getSitesInOrganizations(widget.organizationId),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No Sites Available"),
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
              itemCount: sites.length,
              itemBuilder: (context, index) {
                return sites[index];
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
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future getSitesInOrganizations(organizationId) async {
    final sitesData = await getSitesInOrganization(organizationId);
    List<Widget> sitesItem = [];
    if (sitesData.isNotEmpty) {
      for (final site in sitesData) {
        sitesItem.add(
          SitesItem(
            siteName: site.name!,
            sectorCount: site.sectors!.length,
            organizationId: organizationId,
            siteId: site.id!,
            isDummy: false,
            getSelectedId: _updateSiteId,
          ),
        );
      }
      for (int i = 0; i < 3; i++) {
        sitesItem.add(
          SitesItem(
            siteName: emptyString,
            sectorCount: 0,
            organizationId: organizationId,
            siteId: emptyString,
            isDummy: true,
            getSelectedId: _updateSiteId,
          ),
        );
      }
      if (mounted) {
        setState(() {
          sites = sitesItem;
        });
      }
    } else {
      for (int i = 0; i < 4; i++) {
        sitesItem.add(
          SitesItem(
            siteName: emptyString,
            sectorCount: 0,
            organizationId: organizationId,
            siteId: emptyString,
            isDummy: true,
            getSelectedId: _updateSiteId,
          ),
        );
      }
      if (mounted) {
        setState(() {
          sites = sitesItem;
        });
      }
    }
    return sitesData;
  }
}
