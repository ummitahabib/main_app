// ignore_for_file: use_build_context_synchronously

import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/header_text.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import '../../../../network/crow/models/request/farm_management/create_log_owner.dart';
import '../../../../network/crow/models/request/farm_management/create_log_remark.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';
import '../../../widgets/square_button.dart';
import '../../widgets/farm_logs_assets_item.dart';
import '../../widgets/farm_management_log_owners_item.dart';
import '../../widgets/farm_management_log_remarks_item.dart';
import 'fam_management_add_log_asset_types_menu.dart';

class FarmManagementAdditionalDetailsPage extends StatefulWidget {
  final FileUploadDetailsArgs uploadArgs;

  const FarmManagementAdditionalDetailsPage({
    Key? key,
    required this.uploadArgs,
  }) : super(key: key);

  @override
  _FarmManagementAdditionalDetailsPageState createState() {
    return _FarmManagementAdditionalDetailsPageState();
  }
}

class _FarmManagementAdditionalDetailsPageState extends State<FarmManagementAdditionalDetailsPage> {
  final Pandora _pandora = Pandora();
  AdditionalLogDetails? additionalLogDetails;
  List<Widget> logOwnersList = [];
  List<Widget> logRemarksList = [];
  List<Widget> logAssetsList = [];
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _participantName = '', _participantRole = '';
  bool autoValidate = false;

  @override
  void initState() {
    super.initState();
    fetchAdditionalLogDetails(widget.uploadArgs.logDetailsResponse!.id!);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.farmManagerBackground,
        elevation: 0.1,
        title: Text(
          'Log Additional Information',
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
            _pandora.logAPPButtonClicksEvent('FARM_MANAGER_BACK_BTN');
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              _pandora.reRouteUserPopCurrent(
                context,
                '/farmManagerFileUploadPage',
                FileUploadDetailsArgs(
                  null,
                  widget.uploadArgs.logDetailsResponse,
                  widget.uploadArgs.isAsset,
                ),
              );
            },
            child: const Text(
              "Continue",
              style: TextStyle(
                fontSize: 16.0,
                fontFamily: 'regular',
                color: AppColors.shopOrange,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        ],
      ),
      backgroundColor: AppColors.dashboardBackground,
      body: EnhancedFutureBuilder(
        future: fetchAdditionalLogDetails(
          widget.uploadArgs.logDetailsResponse!.id!,
        ),
        rememberFutureResult: true,
        whenDone: (obj) => _showResponse(),
        whenError: (error) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text("Unable Additional Information"),
        ),
        whenNotDone: ListLoader(screenWidth: _screenWidth),
      ),
    );
  }

  Future fetchAdditionalLogDetails(int logId) async {
    additionalLogDetails = await getAdditionalLogDetails(logId);

    List<Widget> logOwnersList = [];
    List<Widget> logRemarksList = [];
    List<Widget> logAssetList = [];

    if (additionalLogDetails != null) {
      if (additionalLogDetails!.data.logOwnersList.isEmpty) {
        logOwnersList.add(const EmptyListItem(message: 'Log does not have any Owners'));
      } else {
        for (final owner in additionalLogDetails!.data.logOwnersList) {
          logOwnersList.add(FarmManagementLogOwnersItem(owner: owner));
        }
      }
    } else {
      logOwnersList.add(const EmptyListItem(message: 'Log does not have any Owners'));
    }

    if (additionalLogDetails != null) {
      if (additionalLogDetails!.data.logRemarks.isEmpty) {
        logRemarksList.add(const EmptyListItem(message: 'Log does not have any Remarks'));
      } else {
        for (final remark in additionalLogDetails!.data.logRemarks) {
          logRemarksList.add(FarmManagementLogRemarksItem(remark: remark));
        }
      }
    } else {
      logRemarksList.add(const EmptyListItem(message: 'Log does not have any Remarks'));
    }

    if (additionalLogDetails != null) {
      if (additionalLogDetails!.data.logAssets.isEmpty) {
        logAssetList.add(const EmptyListItem(message: 'Log does not have any Assets'));
      } else {
        for (final asset in additionalLogDetails!.data.logAssets) {
          logAssetList.add(
            FarmLogsAssetsItem(
              asset: asset,
            ),
          );
        }
      }
    } else {
      logAssetList.add(const EmptyListItem(message: 'Log does not have any Assets'));
    }

    if (mounted) {
      setState(() {
        logOwnersList = logOwnersList;
        logRemarksList = logRemarksList;
        logAssetsList = logAssetList;
      });
    }

    return additionalLogDetails;
  }

  Widget _showResponse() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Card(
            elevation: 0.2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: AppColors.offWhite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.shopOrange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeaderText(
                          text: "Log Owners ",
                          color: AppColors.black,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const HeaderText(
                                              text: 'Add Participant',
                                              color: Colors.black,
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Styles.closeBtnGrey(),
                                            )
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Divider(
                                            height: 1.0,
                                          ),
                                        ),
                                        _addOwnerBody(),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Add Participant",
                            style: Styles.regularWhiteSmoke(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: logOwnersList.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: logOwnersList[index],
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Card(
            elevation: 0.2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: AppColors.offWhite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.shopOrange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeaderText(
                          text: "Log Remarks ",
                          color: AppColors.black,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              context: context,
                              builder: (context) {
                                return SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: 20,
                                      right: 20,
                                      top: 20,
                                      bottom: MediaQuery.of(context).viewInsets.bottom,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            const HeaderText(
                                              text: 'Add Remark',
                                              color: Colors.black,
                                            ),
                                            const Spacer(),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Styles.closeBtnGrey(),
                                            )
                                          ],
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 8.0,
                                          ),
                                          child: Divider(
                                            height: 1.0,
                                          ),
                                        ),
                                        _addRemarkBody()
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Add New Remark",
                            style: Styles.regularWhiteSmoke(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: logRemarksList.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: logRemarksList[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Card(
            elevation: 0.2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            color: AppColors.offWhite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.shopOrange,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const HeaderText(
                          text: "Log Assets ",
                          color: AppColors.black,
                        ),
                        OutlinedButton(
                          onPressed: () {
                            displayModalWithChild(
                              FarmManagementAssetLogAssetTypeMenu(
                                uploadArgs: widget.uploadArgs,
                              ),
                              'Farm Asset Types',
                              context,
                            );
                          },
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          ),
                          child: Text(
                            "Add Log Asset",
                            style: Styles.regularWhiteSmoke(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 5.0,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        itemCount: logAssetsList.length,
                        separatorBuilder: (context, index) {
                          return const SizedBox(
                            height: 8,
                          );
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Align(
                            alignment: Alignment.topCenter,
                            child: logAssetsList[index],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addOwnerBody() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            style: Styles.inputStyle(),
            decoration: InputDecoration(
              label: const Text("Participant Name"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Participant Name cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _participantName = val!;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            style: Styles.inputStyle(),
            decoration: InputDecoration(
              label: const Text("Participant Role"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Participant Role cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _participantRole = val!;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SquareButton(
            backgroundColor: AppColors.shopOrange,
            press: () async {
              if (_validateInputs()) {
                await addLogOwner(
                  CreateLogOwner(
                    logId: widget.uploadArgs.logDetailsResponse!.id!,
                    ownerName: _participantName,
                    ownerRole: _participantRole,
                  ),
                );
                Navigator.pop(context);
              }
            },
            textColor: AppColors.whiteColor,
            text: 'Save',
          ),
        ],
      ),
    );
  }

  Widget _addRemarkBody() {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            style: Styles.inputStyle(),
            decoration: InputDecoration(
              label: const Text("Remark"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Remark cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _participantName = val!;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            style: Styles.inputStyle(),
            decoration: InputDecoration(
              label: const Text("Next Action"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Next Action cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _participantRole = val!;
            },
          ),
          const SizedBox(
            height: 10,
          ),
          SquareButton(
            backgroundColor: AppColors.shopOrange,
            press: () async {
              if (_validateInputs()) {
                await addLogRemark(
                  AddLogRemark(
                    logId: widget.uploadArgs.logDetailsResponse!.id!,
                    remark: _participantName,
                    nextAction: _participantRole,
                  ),
                );
                Navigator.pop(context);
              }
            },
            textColor: AppColors.whiteColor,
            text: 'Save',
          ),
        ],
      ),
    );
  }

  bool _validateInputs() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      return true;
    } else {
      setState(() {
        autoValidate = true;
      });
      return false;
    }
  }
}
