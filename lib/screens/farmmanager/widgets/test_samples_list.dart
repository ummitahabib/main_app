import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/network/crow/models/sample_report_response.dart';
import 'package:smat_crow/network/crow/models/star_mission_by_id_response.dart';
import 'package:smat_crow/network/crow/star_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/styles.dart';
import 'bottom_sheet_header.dart';
import 'category_chip.dart';

class TestSamplesList extends StatefulWidget {
  const TestSamplesList({Key? key, required this.missionData, required this.missionId}) : super(key: key);
  final GetMissionById missionData;
  final String missionId;

  @override
  _TestSamplesListState createState() => _TestSamplesListState();
}

class _TestSamplesListState extends State<TestSamplesList> {
  List<Widget> samples = [];
  GetSampleReport? _sampleReport;
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.missionData.samples!.length; i++) {
      samples.add(
        Card(
          elevation: 0,
          color: AppColors.landingOrangeButton.withOpacity(.09),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      widget.missionData.samples![i].name!,
                      style: GoogleFonts.poppins(textStyle: Styles.normalTextLarge()),
                    ),
                    const Spacer(),
                    Text(
                      '${widget.missionData.samples![i].coordinates!.lat}, ${widget.missionData.samples![i].coordinates!.lng}',
                      style: GoogleFonts.poppins(textStyle: Styles.regularTextStyle()),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Spacer(),
                    CategoryChip(
                      EvaIcons.downloadOutline,
                      "Download",
                      () async {
                        _pandora.logAPPButtonClicksEvent('BEGIN_DOWNLOAD_SAMPLES_REPORT_BUTTON_CLICKED');

                        _sampleReport = await downloadSampleReport(widget.missionData.samples![i].id!);
                        await _pandora.downloadFile(_sampleReport!.data.pdfUrl, widget.missionData.samples![i].name!);
                      },
                      AppColors.landingOrangeButton,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      child: Column(
        children: [
          BottomSheetHeaderText(text: widget.missionData.name!),
          ListView.separated(
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 10,
              );
            },
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: samples.length,
            itemBuilder: (context, index) {
              return Align(alignment: Alignment.topCenter, child: samples[index]);
            },
          ),
        ],
      ),
    );
  }
}
