import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/farm_management/assets/generic_log_response.dart';
import '../../../../network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';
import '../../widgets/farm_logs_assets_item.dart';
import '../../widgets/farm_management_additional_log_item.dart';
import '../../widgets/farm_management_log_file_item.dart';
import '../../widgets/farm_management_log_media_item.dart';
import '../../widgets/farm_management_log_owners_item.dart';
import '../../widgets/farm_management_log_remarks_item.dart';

class FarmManagementLogDetailsPage extends StatefulWidget {
  final Completed log;

  const FarmManagementLogDetailsPage({Key? key, required this.log}) : super(key: key);

  @override
  _FarmManagementLogDetailsPageState createState() {
    return _FarmManagementLogDetailsPageState();
  }
}

class _FarmManagementLogDetailsPageState extends State<FarmManagementLogDetailsPage> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;

  List<Widget> logRemarksList = [];
  List<Widget> logAssetsList = [];
  List<Widget> logOwnersList = [];
  List<Widget> logFilesList = [];
  List<Widget> logImagesList = [];
  AdditionalLogDetails? additionalLogDetails;
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    fetchAdditionalLogDetails(widget.log.id!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.farmManagerBackground,
        title: Text(
          'Log Details',
          overflow: TextOverflow.fade,
          style: GoogleFonts.poppins(textStyle: Styles.TextStyleField()),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace_rounded,
            color: AppColors.fieldAgentText,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _pandora.reRouteUser(context, '/farmManagerAddLogs', AddLogAssetPageArgs(false, null, widget.log));
            },
            child: Text(
              "Edit Log",
              style: Styles.regularOrangeBold(),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.farmManagerBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                Text("${widget.log.name} Log", style: Styles.dashboardText()),
                const SizedBox(
                  height: 22,
                ),
                Card(
                  elevation: 0.2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: AppColors.offWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Added Date",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Styles.outlineCalender(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Status",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Styles.infoOutlineBlueGrey(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "${widget.log.createdDate!.day}-${widget.log.createdDate!.month}-${widget.log.createdDate!.year}",
                                        style: Styles.textGreyMd(),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (widget.log.status == "Completed")
                                              ? AppColors.completedColor
                                              : AppColors.inactiveTabTextColor.withOpacity(.2),
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          child: Text(widget.log.status ?? "", style: Styles.textGreyMd()),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Start",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Styles.outlineCirclePlayGreen(),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Styles.outlineCalender(),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${widget.log.startDate!.day}-${widget.log.startDate!.month}-${widget.log.startDate!.year}",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                color: AppColors.fieldAgentText,
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(EvaIcons.clockOutline, color: AppColors.black, size: 13),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Flexible(
                                          child: Text(
                                            "${widget.log.startTime!.hour} : ${widget.log.startTime!.minute}",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Stop",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(EvaIcons.stopCircleOutline, color: AppColors.redColor, size: 13),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(EvaIcons.calendarOutline, color: AppColors.black, size: 13),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${widget.log.endDate!.day}-${widget.log.endDate!.month}-${widget.log.endDate!.year}",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Styles.outlineClock(),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Flexible(
                                            child: Text(
                                              "${widget.log.endTime!.hour} : ${widget.log.endTime!.minute}",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(textStyle: Styles.textStyleWithOverflow()),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Log Type",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Styles.bookMarkOutline(),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Farming Season",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Styles.outlineSunBlue(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(widget.log.type ?? "", style: Styles.textGreyMd()),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(widget.log.farmingSeason ?? "", style: Styles.textGreyMd()),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Flag",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        const Icon(EvaIcons.flagOutline, size: 13),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          child: Text(
                                            "Quantity",
                                            maxLines: 1,
                                            style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Styles.trendUpOutlnBlue(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: (widget.log.flags == "Monitor")
                                              ? AppColors.redColor.withOpacity(.2)
                                              : AppColors.inactiveTabTextColor.withOpacity(.2),
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          child: Text(widget.log.flags ?? "", style: Styles.textBlkMd()),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        widget.log.quantity ?? "",
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'regular',
                                          color: AppColors.greyColor,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        //Lab Tests
                        if (widget.log.testType == "string")
                          Container()
                        else
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                height: 29,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "Test Type",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  color: AppColors.blueGreyColor,
                                                  fontSize: 16.0,
                                                  fontFamily: 'regular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(EvaIcons.thermometerMinusOutline, size: 13),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "Laboratory",
                                              maxLines: 1,
                                              style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  color: AppColors.blueGreyColor,
                                                  fontSize: 16.0,
                                                  fontFamily: 'regular',
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(EvaIcons.homeOutline, color: AppColors.blueGreyColor, size: 13),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          widget.log.testType ?? "",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'regular',
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          widget.log.laboratory ?? "",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontFamily: 'regular',
                                            color: AppColors.greyColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        const SizedBox(
                          height: 29,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Tags",
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: AppColors.blueGreyColor,
                                            fontSize: 16.0,
                                            fontFamily: 'regular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(EvaIcons.awardOutline, size: 13),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            runSpacing: 5.0,
                            spacing: 5.0,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: (widget.log.deleted == "Y")
                                      ? AppColors.userProfileBackground.withOpacity(.2)
                                      : AppColors.completedColor.withOpacity(.2),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text(
                                    (widget.log.deleted == "Y") ? "Draft" : "Published",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'regular',
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: (widget.log.isGroupAssignment ?? false)
                                      ? AppColors.blueColor.withOpacity(.2)
                                      : AppColors.greyColor.withOpacity(.2),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text(
                                    (widget.log.isGroupAssignment ?? false)
                                        ? "Group Assignment"
                                        : "Not Group Assignment",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'regular',
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: (widget.log.isMovement ?? false)
                                      ? AppColors.yellowColor.withOpacity(.2)
                                      : AppColors.greyColor.withOpacity(.2),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                                  child: Text(
                                    (widget.log.isMovement ?? false) ? "Movement Task" : "Not A Movement Task",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        fontSize: 12.0,
                                        fontFamily: 'regular',
                                        color: AppColors.black,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                Card(
                  elevation: 0.2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  color: AppColors.offWhite,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Reason",
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: AppColors.blueGreyColor,
                                            fontSize: 16.0,
                                            fontFamily: 'regular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(EvaIcons.fileTextOutline, size: 13),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.log.reason ?? "",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'regular',
                                      color: AppColors.greyColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 29,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "Method",
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: AppColors.blueGreyColor,
                                            fontSize: 16.0,
                                            fontFamily: 'regular',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    const Icon(EvaIcons.editOutline, size: 13),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    widget.log.method ?? '',
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontFamily: 'regular',
                                      color: AppColors.greyColor,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 22,
                ),
                EnhancedFutureBuilder(
                  future: fetchAdditionalLogDetails(widget.log.id ?? 0),
                  rememberFutureResult: true,
                  whenDone: (obj) => _showResponse(),
                  whenError: (error) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text("Unable to load additional log data"),
                  ),
                  whenNotDone: ListLoader(screenWidth: _screenWidth),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future fetchAdditionalLogDetails(int logId) async {
    additionalLogDetails = await getAdditionalLogDetails(logId);

    setLogRemarks(additionalLogDetails!.data.logRemarks);
    setLogAssets(additionalLogDetails!.data.logAssets);
    setLogOwners(additionalLogDetails!.data.logOwnersList);
    setLogFiles(additionalLogDetails!.data.logFiles);
    setLogImages(additionalLogDetails!.data.logMedia);
    return additionalLogDetails;
  }

  void setLogRemarks(List<Log> logRemarks) {
    List<Widget> logRemarksList = [];
    if (logRemarks.isEmpty) {
      logRemarksList.add(const EmptyListItem(message: 'You do not have any Remarks'));
    } else {
      for (final remark in logRemarks) {
        logRemarksList.add(FarmManagementLogRemarksItem(remark: remark));
      }
    }

    if (mounted) {
      setState(() {
        logRemarksList = logRemarksList;
      });
    }
  }

  void setLogAssets(List<LogAsset> logAssets) {
    List<Widget> logAssetsList = [];
    if (logAssets.isEmpty) {
      logAssetsList.add(const EmptyListItem(message: 'This log has no Assets'));
    } else {
      for (final asset in logAssets) {
        logAssetsList.add(
          FarmLogsAssetsItem(
            asset: asset,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        logAssetsList = logAssetsList;
      });
    }
  }

  void setLogOwners(List<Log> ownersList) {
    List<Widget> logOwnersList = [];
    if (ownersList.isEmpty) {
      logOwnersList.add(const EmptyListItem(message: 'Log does not have any Owners'));
    } else {
      for (final owner in ownersList) {
        logOwnersList.add(FarmManagementLogOwnersItem(owner: owner));
      }
    }

    if (mounted) {
      setState(() {
        logOwnersList = logOwnersList;
      });
    }
  }

  void setLogFiles(List<Log> logFiles) {
    List<Widget> logFilesList = [];
    int i = 0;

    if (logFiles.isEmpty) {
      logFilesList.add(const EmptyListItem(message: 'Log does not have any Files'));
    } else {
      for (final file in logFiles) {
        ++i;
        logFilesList.add(
          FarmManagementLogFileItem(
            url: file.url,
            intCount: i,
            pandora: _pandora,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        logFilesList = logFilesList;
      });
    }
  }

  void setLogImages(List<Log> logMedia) {
    List<Widget> logImagesList = [];
    int i = 0;
    if (logMedia.isEmpty) {
      logImagesList.add(const EmptyListItem(message: 'Log does not have any Media'));
    } else {
      for (final file in logMedia) {
        ++i;
        logImagesList.add(FarmManagementLogMediaItem(url: file.url, intCount: i));
      }
    }

    if (mounted) {
      setState(() {
        logImagesList = logImagesList;
      });
    }
  }

  Widget _showResponse() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Remarks
        FarmManagerAdditionalLogDetailsItem(title: "Log Remarks", listItems: logRemarksList),
        const SizedBox(
          height: 22,
        ),
        //Assets
        FarmManagerAdditionalLogDetailsItem(title: "Log Assets", listItems: logAssetsList),
        const SizedBox(
          height: 22,
        ),
        //Owners
        FarmManagerAdditionalLogDetailsItem(title: "Log Owners", listItems: logOwnersList),
        const SizedBox(
          height: 22,
        ),
        //Images
        FarmManagerAdditionalLogDetailsItem(title: "Images", listItems: logImagesList),
        const SizedBox(
          height: 22,
        ),
        //Files
        FarmManagerAdditionalLogDetailsItem(title: "Files", listItems: logFilesList),
        const SizedBox(
          height: 22,
        ),
      ],
    );
  }
}
