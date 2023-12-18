import 'package:flutter/material.dart';

import 'batches_list.dart';
import 'bottom_sheet_header.dart';
import 'custom_dragging_handle.dart';
import 'grid_loader.dart';
import 'organizations_list.dart';
import 'sectors_list.dart';
import 'sites_list.dart';

class FarmManagerBody extends StatefulWidget {
  const FarmManagerBody({Key? key, this.getAllIds}) : super(key: key);
  final getAllIds;

  @override
  _FarmManagerBodyState createState() => _FarmManagerBodyState();
}

class _FarmManagerBodyState extends State<FarmManagerBody> {
  String organizationId = '', organizationName = '';
  String siteId = '', siteName = '';
  String sectorId = '', sectorName = '';
  String batchId = '', batchName = '';
  int siteCount = 0, sectorCount = 0, batchCount = 0, imageCount = 0;
  bool tappedOrganization = false, tappedSite = false, tappedSector = false, tappedBatch = false;

  void _updateOrganizationId(String id, String name, int count, bool isTapped) {
    setState(() {
      organizationId = id;
      organizationName = name;
      siteCount = count;
      tappedOrganization = isTapped;
      debugPrint(
        'Org ID $organizationId Organization Name $organizationName Site Count $siteCount IsTapped $isTapped',
      );
      widget.getAllIds(
        organizationId,
        siteId,
        sectorId,
        batchId,
        tappedOrganization,
        tappedSite,
        tappedSector,
        tappedBatch,
      );
    });
  }

  void _updateSiteId(String id, String name, int count, bool isTapped) {
    setState(() {
      siteId = id;
      siteName = name;
      sectorCount = count;
      tappedSite = isTapped;
      debugPrint(
        'Site ID $siteId Site Name $siteName Sector Count $sectorCount  IsTapped $isTapped',
      );
      widget.getAllIds(
        organizationId,
        siteId,
        sectorId,
        batchId,
        tappedOrganization,
        tappedSite,
        tappedSector,
        tappedBatch,
      );
    });
  }

  void _updateSectorId(String id, String name, int count, bool isTapped) {
    setState(() {
      sectorId = id;
      sectorName = name;
      batchCount = count;
      tappedSector = isTapped;
      debugPrint(
        'Sector ID $sectorId Sector Name $sectorName Batch Count $batchCount IsTapped $isTapped',
      );
      widget.getAllIds(
        organizationId,
        siteId,
        sectorId,
        batchId,
        tappedOrganization,
        tappedSite,
        tappedSector,
        tappedBatch,
      );
    });
  }

  void _updateBatchId(String id, String name, int count, bool isTapped) {
    setState(() {
      batchId = id;
      batchName = name;
      imageCount = count;
      tappedBatch = isTapped;
      debugPrint(
        'Batch ID $batchId Batch Name $batchName Image Count $imageCount IsTapped $isTapped',
      );
      widget.getAllIds(
        organizationId,
        siteId,
        sectorId,
        batchId,
        tappedOrganization,
        tappedSite,
        tappedSector,
        tappedBatch,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      tappedOrganization = false;
      tappedSite = false;
      tappedSector = false;
      tappedBatch = false;
    });
    return Column(
      children: <Widget>[
        const SizedBox(height: 36),
        const CustomDraggingHandle(),
        const SizedBox(height: 16),
        const BottomSheetHeaderText(text: "Organizations"),
        const SizedBox(height: 16),
        OrganizationsList(getSelectedId: _updateOrganizationId),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: <Widget>[
              Text(
                "$organizationName Sites",
                style: const TextStyle(fontSize: 14),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (organizationId.isEmpty && organizationName == '')
          const GridLoader()
        else
          SitesList(
            organizationId: organizationId,
            getSelectedId: _updateSiteId,
          ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: <Widget>[
              Text("$siteName Sectors", style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (siteId.isEmpty && siteName == '')
          const CustomRecentPhotosSmall()
        else
          SectorsList(siteId: siteId, getSelectedId: _updateSectorId),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Row(
            children: <Widget>[Text("$sectorName Batches", style: const TextStyle(fontSize: 14))],
          ),
        ),
        const SizedBox(height: 16),
        if (sectorId.isEmpty && sectorName == '')
          const GridLoader()
        else
          BatchesList(sectorId: sectorId, getSelectedId: _updateBatchId),
        const SizedBox(height: 24),
      ],
    );
  }
}

class CustomRecentPhotosSmall extends StatelessWidget {
  const CustomRecentPhotosSmall({super.key});

  @override
  Widget build(BuildContext context) {
    return const GridLoader();
  }
}
