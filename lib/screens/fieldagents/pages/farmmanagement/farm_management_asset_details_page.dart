import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../pandora/pandora.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import 'fam_management_log_types_menu.dart';
import 'farm_management_files_list_page.dart';
import 'farm_management_images_list_page.dart';

class FarmManagementAssetDetailsPage extends StatefulWidget {
  final FarmManagementAssetArgs assetArgs;

  const FarmManagementAssetDetailsPage({Key? key, required this.assetArgs}) : super(key: key);

  @override
  _FarmManagementAssetDetailsPageState createState() {
    return _FarmManagementAssetDetailsPageState();
  }
}

class _FarmManagementAssetDetailsPageState extends State<FarmManagementAssetDetailsPage> {
  final List<bool> selectedScreen = <bool>[true, false];
  List<Widget> tabs = <Widget>[
    const Text('Details'),
    const Text('Logs'),
  ];
  final Pandora _pandora = Pandora();

  late Widget displayPage;

  @override
  void initState() {
    super.initState();
    UnsafeIds.assetId = widget.assetArgs.asset!.id ?? 0;
    displayPage = assetDetails();
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
          'Asset Details',
          overflow: TextOverflow.fade,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: AppColors.fieldAgentText,
              fontSize: 16.0,
            ),
          ),
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
              _pandora.reRouteUser(
                context,
                '/farmManagerAddAssets',
                AddLogAssetPageArgs(false, widget.assetArgs, null),
              );
            },
            child: Text(
              "Edit Asset",
              style: Styles.regularOrangeBold(),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.farmManagerBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Text("${widget.assetArgs.asset!.name} Asset", style: Styles.dashboardText()),
              const SizedBox(
                height: 16,
              ),
              Card(
                elevation: 0.2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                color: AppColors.offWhite,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      ToggleButtons(
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < selectedScreen.length; i++) {
                              selectedScreen[i] = i == index;
                              if (index == 0) {
                                displayPage = assetDetails();
                              } else {
                                displayPage = assetLogs();
                              }
                            }
                          });
                        },
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
                        selectedBorderColor: AppColors.greyScaleBody,
                        selectedColor: Colors.white,
                        fillColor: AppColors.greyScaleBody,
                        color: AppColors.black,
                        constraints: const BoxConstraints(
                          minHeight: 40.0,
                          minWidth: 80.0,
                        ),
                        isSelected: selectedScreen,
                        children: tabs,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              displayPage
            ],
          ),
        ),
      ),
    );
  }

  Widget assetDetails() {
    return Column(
      children: [
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
                                Styles.outlineCalenderBlueGrey()
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
                                "${widget.assetArgs.asset!.createdDate!.day}-${widget.assetArgs.asset!.createdDate!.month}-${widget.assetArgs.asset!.createdDate!.year}",
                                style: Styles.textGreyMd(),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: (widget.assetArgs.asset!.status == "Active")
                                      ? AppColors.completedColor
                                      : AppColors.inactiveTabTextColor.withOpacity(.2),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  child: Text(widget.assetArgs.asset!.status ?? "", style: Styles.textBlkMd()),
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
                                    "Asset Type",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(EvaIcons.bookmarkOutline, size: 13),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    "Manufacturer",
                                    maxLines: 1,
                                    style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(CupertinoIcons.building_2_fill, color: AppColors.blueGreyColor, size: 13),
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
                              child: Text(widget.assetArgs.asset!.type ?? "", style: Styles.textGreyMd()),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(widget.assetArgs.asset!.manufacturer ?? "", style: Styles.textGreyMd()),
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
                                Styles.trendUpOutlnBlue()
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
                                  color: (widget.assetArgs.asset!.flags == "Monitor")
                                      ? AppColors.redColor.withOpacity(.2)
                                      : AppColors.inactiveTabTextColor.withOpacity(.2),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  child: Text(widget.assetArgs.asset!.flags ?? "", style: Styles.textGreyMd()),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text("${widget.assetArgs.asset!.quantity}", style: Styles.greyColorRegular18()),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                //Seeds
                if (widget.assetArgs.asset!.type != "Seed")
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
                                      "Crop Family",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(CupertinoIcons.tree, size: 13),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Transplant After",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Styles.outlineCalender()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(widget.assetArgs.asset!.cropFamily ?? "", style: Styles.textGreyMd()),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${widget.assetArgs.asset!.daysToTransplant} Days",
                                  style: Styles.textGreyMd(),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                                      "Mature After",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(EvaIcons.calendarOutline, size: 13),
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
                                child:
                                    Text("${widget.assetArgs.asset!.daysToMaturity} Days", style: Styles.textGreyMd()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (widget.assetArgs.asset!.type != "Equipment")
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
                                      "Serial Number",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(CupertinoIcons.barcode, size: 13),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Model",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Styles.settingOutline(),
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
                                child: Text(widget.assetArgs.asset!.serialnumber ?? "", style: Styles.textGreyMd()),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(widget.assetArgs.asset!.model ?? "", style: Styles.textGreyMd()),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (widget.assetArgs.asset!.type != "Chemicals")
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
                                      "Manufacture Date",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  const Icon(EvaIcons.calendarOutline, size: 13),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Expiry Date",
                                      maxLines: 1,
                                      style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Styles.outlineCalender()
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
                                  "${widget.assetArgs.asset!.manufactureDate!.day}-${widget.assetArgs.asset!.manufactureDate!.month}-${widget.assetArgs.asset!.manufactureDate!.year}",
                                  style: Styles.textGreyMd(),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "${widget.assetArgs.asset!.expiryDate!.day}-${widget.assetArgs.asset!.expiryDate!.month}-${widget.assetArgs.asset!.expiryDate!.year}",
                                  style: Styles.textGreyMd(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                                style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
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
                          color: (widget.assetArgs.asset!.deleted == "Y")
                              ? AppColors.userProfileBackground.withOpacity(.2)
                              : AppColors.completedColor.withOpacity(.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Text(
                            (widget.assetArgs.asset!.deleted == "Y") ? "Draft" : "Published",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: (widget.assetArgs.asset!.canExpire ?? false)
                              ? AppColors.redColor.withOpacity(.2)
                              : AppColors.blueColor.withOpacity(.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Text(
                            (widget.assetArgs.asset!.canExpire ?? false) ? "Can Expire" : "Cannot Expire",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.greyColor.withOpacity(.2),
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                          child: Text(
                            (widget.assetArgs.asset!.location ?? false) ? "Location" : "Not Location",
                            maxLines: 1,
                            style: GoogleFonts.poppins(textStyle: Styles.textBlackMd()),
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
                                "Notes",
                                maxLines: 1,
                                style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
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
                          child: Text(widget.assetArgs.asset!.notes ?? "", style: Styles.textGreyMd()),
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
                                "Price",
                                maxLines: 1,
                                style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd()),
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
                          child: Text("₦ ${widget.assetArgs.asset!.cost}", style: Styles.textGreyMd()),
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
        FarmManagementAssetImagesPage(assetId: widget.assetArgs.asset!.id ?? 0, isAsset: true),
        const SizedBox(
          height: 22,
        ),
        FarmManagementAssetFilesPage(
          assetId: widget.assetArgs.asset!.id ?? 0,
          isAsset: true,
        )
      ],
    );
  }

  Widget assetLogs() {
    return Column(
      children: [
        const SizedBox(
          height: 22,
        ),
        Card(
          elevation: 0.2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: AppColors.offWhite,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: FarmManagementLogTypesMenu(
              siteArgs: FarmManagementTypeManagementArgs(widget.assetArgs.farmArgs, widget.assetArgs.asset!.type),
            ),
          ),
        ),
      ],
    );
  }
}
