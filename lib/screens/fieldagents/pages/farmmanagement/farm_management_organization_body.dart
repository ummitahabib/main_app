import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../../../utils/session.dart';
import '../../../farmmanager/widgets/batches_list.dart';
import '../../../farmmanager/widgets/bottom_sheet_header.dart';
import '../../../farmmanager/widgets/custom_dragging_handle.dart';
import '../../../farmmanager/widgets/grid_loader.dart';
import '../../../farmmanager/widgets/sectors_list.dart';
import '../../../farmmanager/widgets/sites_list.dart';

class FarmManagementOrganizationBody extends StatefulWidget {
  const FarmManagementOrganizationBody({
    Key? key,
    this.getAllIds,
    required this.fieldAgentOrganizationArgs,
  }) : super(key: key);
  final dynamic getAllIds;
  final FieldAgentOrganizationArgs fieldAgentOrganizationArgs;

  @override
  _FarmManagementOrganizationBodyState createState() => _FarmManagementOrganizationBodyState();
}

class _FarmManagementOrganizationBodyState extends State<FarmManagementOrganizationBody> {
  String organizationId = emptyString, organizationName = emptyString;
  String siteId = emptyString, siteName = emptyString;
  String sectorId = emptyString, sectorName = emptyString;
  String batchId = emptyString, batchName = emptyString;
  int siteCount = 0, sectorCount = 0, batchCount = 0, imageCount = 0;
  bool tappedOrganization = false, tappedSite = false, tappedSector = false, tappedBatch = false;

  @override
  void initState() {
    _updateOrganizationId(
      widget.fieldAgentOrganizationArgs.organizationId,
      widget.fieldAgentOrganizationArgs.organizationName,
      1,
      true,
    );
    super.initState();
  }

  void _updateOrganizationId(String id, String name, int count, bool isTapped) {
    organizationId = id;
    organizationName = name;
    siteCount = count;
    tappedOrganization = isTapped;
  }

  void _updateSiteId(String id, String name, int count, bool isTapped) {
    setState(() {
      siteId = id;
      siteName = name;
      sectorCount = count;
      tappedSite = isTapped;

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

  _updateBatchId(String id, String name, int count, bool isTapped) {
    setState(() {
      batchId = id;
      batchName = name;
      imageCount = count;
      tappedBatch = isTapped;

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
      tappedOrganization = true;
      tappedSite = false;
      tappedSector = false;
      tappedBatch = false;
    });
    return Column(
      children: <Widget>[
        const SizedBox(height: 36),
        const CustomDraggingHandle(),
        const SizedBox(height: 16),
        BottomSheetHeaderText(
          text: "${widget.fieldAgentOrganizationArgs.organizationName} Sites",
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 16),
        if (organizationId.isEmpty && organizationName == emptyString)
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
        if (siteId.isEmpty && siteName == emptyString)
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
        if (sectorId.isEmpty && sectorName == emptyString)
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
