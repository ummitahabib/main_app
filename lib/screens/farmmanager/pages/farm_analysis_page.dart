// ignore_for_file: library_private_types_in_public_api

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/batch_operations.dart';
import 'package:smat_crow/network/crow/ml_operations.dart';
import 'package:smat_crow/network/crow/models/batch_by_id.dart';
import 'package:smat_crow/network/crow/models/plant_canopy_response.dart';
import 'package:smat_crow/network/crow/models/plant_count_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';

class FarmAnalysisPage extends StatefulWidget {
  const FarmAnalysisPage({Key? key, required this.batchId}) : super(key: key);
  final String batchId;

  @override
  _FarmAnalysisPageState createState() => _FarmAnalysisPageState();
}

class _FarmAnalysisPageState extends State<FarmAnalysisPage> {
  GetBatchById? batchData;
  Pandora pandora = Pandora();
  // WeedCountResponse weedCount;
  PlantCountResponse? plantCount;
  PlantCanopyResponse? plantCanopy;
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  final AsyncMemoizer _plantcountMem = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    getBatchDetails(widget.batchId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
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
        return _showResponse();
      },
      future: getBatchDetails(widget.batchId),
    );
  }

  Future getBatchDetails(String batchId) async {
    return _asyncMemoizer.runOnce(() async {
      final data = await getBatchById(batchId);
      if (mounted) {
        setState(() {
          batchData = data;
          getAnalysisInformation(batchData!.taskId!);
        });
      }
    });
  }

  Widget showLoader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
          ],
        ),
      ),
    );
  }

  Widget _showResponse() {
    return Column(
      children: [
        const SizedBox(height: 16),
        BottomSheetHeaderText(text: batchData!.name!),
        const SizedBox(height: 24),
        FutureBuilder(
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none && !snapshot.hasData ||
                snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
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
            return showAnalysisData();
          },
          future: getAnalysisInformation(batchData!.taskId!),
        ),
      ],
    );
  }

  Future getAnalysisInformation(String orthophotoId) async {
    return _plantcountMem.runOnce(() async {
      final plantCountData = await getPlantCountInBatch(orthophotoId);
      //final plantCanopyData = await getPlantCanopyInBatch(orthophotoId);
      //final weedCountData = await getWeedCountInBatch(orthophotoId);
      if (mounted) {
        setState(() {
          //weedCount = weedCountData;
          plantCount = plantCountData;
          //plantCanopy = plantCanopyData;
        });
      }
      return plantCountData;
    });
  }

  Widget showAnalysisData() {
    return plantCount != null
        ? Column(
            children: [
              //Text('Weed Count ${weedCount.success}'),
              Text('Plant Count ${plantCount!.success}'),
              //Text('Plant Canopy ${plantCanopy.success}'),
            ],
          )
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
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
}
