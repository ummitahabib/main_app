import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/sector_operations.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'sectors_item.dart';

class SectorsList extends StatefulWidget {
  const SectorsList({Key? key, this.getSelectedId, required this.siteId}) : super(key: key);
  final String siteId;
  final getSelectedId;

  @override
  State<StatefulWidget> createState() {
    return _SectorsListState();
  }
}

class _SectorsListState extends State<SectorsList> {
  bool loading = true;
  List<Widget> sites = [];
  String sectorId = emptyString, sectorName = emptyString, sId = emptyString;
  int batchCount = 0;
  bool clickedSector = false;

  void _updateSectorId(String id, String name, int count, bool isTapped) {
    setState(() {
      sectorId = id;
      sectorName = name;
      batchCount = count;
      clickedSector = isTapped;
      widget.getSelectedId(sectorId, sectorName, batchCount, clickedSector);
    });
  }

  @override
  void initState() {
    super.initState();
    getSectorsInSite(widget.siteId);
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: getSectorsInSite(widget.siteId),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No Sectors Available"),
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
            height: 150,
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
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 150,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.grey[350],
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Container(
              height: 150,
              width: 100,
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

  Future getSectorsInSite(String siteId) async {
    final sectorsData = await getSectorsForSite(siteId);
    List<Widget> sectorsItem = [];
    if (sectorsData.isNotEmpty) {
      for (final sector in sectorsData) {
        sectorsItem.add(
          SectorsItem(
            sectorName: sector.name,
            sectorId: sector.id,
            siteId: widget.siteId,
            batchCount: sector.batches.length,
            isDummy: false,
            getSelectedId: _updateSectorId,
          ),
        );
      }
      for (int i = 0; i < 3; i++) {
        sectorsItem.add(
          SectorsItem(
            sectorName: emptyString,
            batchCount: 0,
            sectorId: emptyString,
            siteId: widget.siteId,
            isDummy: true,
            getSelectedId: _updateSectorId,
          ),
        );
      }
      if (mounted) {
        setState(() {
          sites = sectorsItem;
        });
      }
    } else {
      for (int i = 0; i < 4; i++) {
        sectorsItem.add(
          SectorsItem(
            sectorName: emptyString,
            batchCount: 0,
            sectorId: emptyString,
            siteId: widget.siteId,
            isDummy: true,
            getSelectedId: _updateSectorId,
          ),
        );
      }
      if (mounted) {
        setState(() {
          sites = sectorsItem;
        });
      }
    }
    return sectorsData;
  }
}
