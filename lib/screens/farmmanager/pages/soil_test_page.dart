import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/screens/farmmanager/widgets/bottom_sheet_header.dart';
import 'package:smat_crow/screens/farmmanager/widgets/grid_loader.dart';

class SoilTestPage extends StatefulWidget {
  const SoilTestPage({
    Key? key,
    required this.siteId,
    required this.siteName,
    required this.organizationId,
    this.getSelectedId,
  }) : super(key: key);
  final String siteId, siteName, organizationId;
  final getSelectedId;

  @override
  _SoilTestPageState createState() => _SoilTestPageState();
}

class _SoilTestPageState extends State<SoilTestPage> {
  List<Widget> siteAnalysisItems = [];
  String? missionId, siteName, missionName;
  bool clickedMission = false;

  @override
  void initState() {
    super.initState();
    //  Provider.of<FarmManagerProvider>(context, listen: false).getSiteMissions(widget.siteId, widget);
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return EnhancedFutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load soil test data"),
      ),
      whenNotDone: _showLoader(),
    );
  }

  Widget _showResponse() {
    return Column(
      children: [
        const SizedBox(height: 16),
        BottomSheetHeaderText(text: widget.siteName),
        const SizedBox(height: 24),
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(0),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              shrinkWrap: true,
              children: siteAnalysisItems,
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _showLoader() {
    return const Padding(padding: EdgeInsets.only(left: 20, right: 20, bottom: 20), child: GridLoader());
  }
}
