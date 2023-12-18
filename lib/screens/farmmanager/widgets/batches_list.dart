import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/batch_operations.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'batches_item.dart';

class BatchesList extends StatefulWidget {
  const BatchesList({Key? key, this.getSelectedId, required this.sectorId}) : super(key: key);
  final String sectorId;
  final dynamic getSelectedId;

  @override
  State<StatefulWidget> createState() {
    return _BatchesListState();
  }
}

class _BatchesListState extends State<BatchesList> {
  bool loading = true;
  List<Widget> batches = [];
  String batchId = emptyString, batchName = emptyString;
  int imageCount = 0;
  bool clickedBatch = false;

  void _updateBatchId(String id, String name, int count, bool isTapped) {
    setState(() {
      batchId = id;
      batchName = name;
      imageCount = count;
      clickedBatch = isTapped;
      widget.getSelectedId(batchId, batchName, imageCount, clickedBatch);
    });
  }

  @override
  void initState() {
    super.initState();
    getBatchesInSector(widget.sectorId);
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: getBatchesInSector(widget.sectorId),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("No batches available"),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showResponse() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            //height: 200,
            child: GridView.builder(
              itemCount: batches.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemBuilder: (context, index) {
                return batches[index];
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _showLoader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            Container(
              height: 100,
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
              height: 100,
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
              height: 100,
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
              height: 100,
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

  Future getBatchesInSector(sectorId) async {
    final batchData = await getSectorBatches(sectorId);
    List<Widget> batchesItem = [];
    if (batchData.isNotEmpty) {
      for (final batch in batchData) {
        batchesItem.add(
          BatchesItem(
            batchName: batch.name!,
            imageCount: batch.images!.length,
            batchId: batch.id!,
            isDummy: false,
            getSelectedId: _updateBatchId,
          ),
        );
      }
      for (int i = 0; i < 3; i++) {
        batchesItem.add(
          BatchesItem(
            batchName: emptyString,
            imageCount: 0,
            batchId: emptyString,
            isDummy: true,
            getSelectedId: _updateBatchId,
          ),
        );
      }
      if (mounted) {
        setState(() {
          batches = batchesItem;
        });
      }
    } else {
      for (int i = 0; i < 8; i++) {
        batchesItem.add(
          BatchesItem(
            batchName: emptyString,
            imageCount: 0,
            batchId: emptyString,
            isDummy: true,
            getSelectedId: _updateBatchId,
          ),
        );
      }
      if (mounted) {
        setState(() {
          batches = batchesItem;
        });
      }
    }
    return batchData;
  }
}
