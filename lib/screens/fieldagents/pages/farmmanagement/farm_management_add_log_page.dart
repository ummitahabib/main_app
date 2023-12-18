import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/network/crow/models/farm_management/assets/generic_log_response.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/farm_management/logs/generic_log_details.dart';
import '../../../../network/crow/models/request/farm_management/create_log.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/session.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/header_text.dart';
import '../../../widgets/square_button.dart';
import '../../../widgets/sub_header_text.dart';
import '../../widgets/farm_manager_input_dropdown_widget.dart';
import 'fam_management_select_boolean_menu.dart';
import 'fam_management_select_farming_season_menu.dart';
import 'fam_management_select_flags_menu.dart';
import 'fam_management_select_log_status_menu.dart';
import 'fam_management_select_log_types_menu.dart';
import 'farm_management_date_widget.dart';
import 'farm_management_time_widget.dart';

class AddFarmManagerLogPage extends StatefulWidget {
  final AddLogAssetPageArgs addAssetLogPageArgs;

  const AddFarmManagerLogPage({Key? key, required this.addAssetLogPageArgs}) : super(key: key);

  @override
  _AddFarmManagerLogPageState createState() {
    return _AddFarmManagerLogPageState();
  }
}

class _AddFarmManagerLogPageState extends State<AddFarmManagerLogPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool autoValidate = false;
  String? _logName,
      _logType,
      _logFlag,
      _logStatus = "Upcoming",
      _logFarmingSeason,
      _startDate,
      _endDate,
      _startTime,
      _endTime,
      _method,
      _reason,
      _testType,
      _laboratory,
      _logQuantity,
      _logSupplier,
      _logNotes;

  /// Editable Inputs
  final TextEditingController _logNameController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _testTypeController = TextEditingController();
  final TextEditingController _logQuantityController = TextEditingController();
  final TextEditingController _logSupplierController = TextEditingController();
  final TextEditingController _logNotesController = TextEditingController();
  final TextEditingController _logLaboratoryController = TextEditingController();

  ///End of section

  final TextEditingController _logFlagController = TextEditingController();
  final TextEditingController _logFarmingSeasonController = TextEditingController();
  final TextEditingController _logStartDateController = TextEditingController();
  final TextEditingController _logEndDateController = TextEditingController();
  final TextEditingController _logStartTimeController = TextEditingController();
  final TextEditingController _logEndTimeController = TextEditingController();
  final TextEditingController _logTypeController = TextEditingController();
  final TextEditingController _logGroupTaskController = TextEditingController();
  final TextEditingController _logMovementTaskController = TextEditingController();
  final TextEditingController _logStatusController = TextEditingController();
  DateTime? startDate, endDate, startTime, endTime;
  bool isGroup = false, isMovement = false;

  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    if (!widget.addAssetLogPageArgs.isNewInput) {
      setState(() {
        _logNameController.text = widget.addAssetLogPageArgs.logDetails!.name ?? "";
        _methodController.text = widget.addAssetLogPageArgs.logDetails!.method ?? "";
        _reasonController.text = widget.addAssetLogPageArgs.logDetails!.reason ?? "";
        _testTypeController.text = widget.addAssetLogPageArgs.logDetails!.testType ?? "";
        _logQuantityController.text = widget.addAssetLogPageArgs.logDetails!.quantity ?? "";
        _logSupplierController.text = widget.addAssetLogPageArgs.logDetails!.source ?? "";
        _logNotesController.text = widget.addAssetLogPageArgs.logDetails!.notes ?? "";
        _logLaboratoryController.text = widget.addAssetLogPageArgs.logDetails!.laboratory ?? "";
      });
    }
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        HeaderText(
                          text: (widget.addAssetLogPageArgs.isNewInput) ? 'Add Farm Log' : 'Update Farm',
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        const Icon(
                          EvaIcons.bookOpenOutline,
                          size: 20,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SubHeaderText(
                      text: (widget.addAssetLogPageArgs.isNewInput)
                          ? 'Log all events and activity happening on the farm'
                          : 'Update Farm log or event',
                      color: Colors.black,
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.always,
                child: formUI(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget formUI() {
    return Card(
      elevation: 0.2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.offWhite,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextFormField(
              keyboardType: TextInputType.name,
              style: Styles.inputStyle(),
              controller: _logNameController,
              decoration: InputDecoration(
                label: const Text("Log Title"),
                errorBorder: Styles.errorBorder(),
                focusedBorder: Styles.focusBorder(),
                border: Styles.border(),
              ),
              validator: (arg) {
                if (isEmpty(arg)) {
                  return 'Log Title cannot be empty';
                } else {
                  return null;
                }
              },
              onSaved: (val) {
                _logName = val;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagementSelectFarmingSeasonMenu(
                      selectedFarmingSeason: (value) {
                        _logFarmingSeasonController.text = value;
                        setState(() {
                          _logFarmingSeason = value;
                        });
                      },
                    ),
                    dialogTitle: 'Select Farming Season',
                    dialogTextController: _logFarmingSeasonController,
                    inputTitle: "Farming Season",
                    inputValue: (input) => _logFarmingSeason,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagementSelectFlagsMenu(
                      selectedFlag: (value) {
                        _logFlagController.text = value;
                        setState(() {
                          _logFlag = value;
                        });
                      },
                    ),
                    dialogTitle: 'Select Log Flags',
                    dialogTextController: _logFlagController,
                    inputTitle: "Log Flag",
                    inputValue: (input) => _logFlag,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagerDateDialogWidget(
                      selectedDate: (value) {
                        _logStartDateController.text = "${value.year} / ${value.month} / ${value.day}";
                        startDate = value;
                      },
                    ),
                    dialogTitle: 'Select Log Start Date',
                    dialogTextController: _logStartDateController,
                    inputTitle: "Start Date",
                    inputValue: (input) => _startDate,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagerDateDialogWidget(
                      selectedDate: (value) {
                        _logEndDateController.text = "${value.year} / ${value.month} / ${value.day}";
                        endDate = value;
                      },
                    ),
                    dialogTitle: 'Select Log End Date',
                    dialogTextController: _logEndDateController,
                    inputTitle: "End Date",
                    inputValue: (input) => _endDate,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (!widget.addAssetLogPageArgs.isNewInput) editableUI() else Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagerTimeDialogWidget(
                      selectedDate: (value) {
                        _logStartTimeController.text = "${value.hour} : ${value.minute}";
                        startTime = value;
                      },
                    ),
                    dialogTitle: 'Select Log Start Time',
                    dialogTextController: _logStartTimeController,
                    inputTitle: "Start Time",
                    inputValue: (input) => _startTime,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagerTimeDialogWidget(
                      selectedDate: (value) {
                        _logEndTimeController.text = "${value.hour} : ${value.minute}";
                        endTime = value;
                      },
                    ),
                    dialogTitle: 'Select Log End Time',
                    dialogTextController: _logEndTimeController,
                    inputTitle: "End Time",
                    inputValue: (input) => _endTime,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FarmManagerInputDropdownWidget(
              dialogWidget: FarmManagementSelectLogTypeMenu(
                selectedLogType: (value) {
                  _logTypeController.text = value;
                  setState(() {
                    _logType = value;
                  });
                },
              ),
              dialogTitle: 'Select Log Type',
              dialogTextController: _logTypeController,
              inputTitle: "Log Type",
              inputValue: (input) => _logType,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagementSelectBooleanMenu(
                      selectedOption: (value) {
                        _logGroupTaskController.text = value ? "Yes" : "No";
                        setState(() {
                          isGroup = value;
                        });
                      },
                    ),
                    dialogTitle: 'Is this a Group Task?',
                    dialogTextController: _logGroupTaskController,
                    inputTitle: "Group Task",
                    inputValue: (input) => isGroup,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: FarmManagerInputDropdownWidget(
                    dialogWidget: FarmManagementSelectBooleanMenu(
                      selectedOption: (value) {
                        _logMovementTaskController.text = value ? "Yes" : "No";
                        setState(() {
                          isMovement = value;
                        });
                      },
                    ),
                    dialogTitle: 'Is this an Asset Relocation Task?',
                    dialogTextController: _logMovementTaskController,
                    inputTitle: "Movement Task",
                    inputValue: (input) => isMovement,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            if (_logType == LogTypes.ACTIVITY || _logType == LogTypes.OBSERVATION)
              observationUI()
            else
              (_logType == LogTypes.LABTEST || _logType == LogTypes.PLANTS)
                  ? testLogUI()
                  : (_logType == LogTypes.PURCHASE)
                      ? purchaseUi()
                      : Container(),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 5,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              style: Styles.inputStyle(),
              controller: _logNotesController,
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
                _logNotes = val;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SquareButton(
              backgroundColor: AppColors.shopOrange,
              press: () {
                if (_validateInputs()) {
                  createNewLog();
                }
              },
              textColor: AppColors.whiteColor,
              text: 'Next',
            ),
          ],
        ),
      ),
    );
  }

  Widget observationUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          controller: _reasonController,
          style: Styles.inputStyle(),
          decoration: InputDecoration(
            label: const Text("Log Reason"),
            errorBorder: Styles.errorBorder(),
            focusedBorder: Styles.focusBorder(),
            border: Styles.border(),
          ),
          validator: (arg) {
            if (isEmpty(arg)) {
              return 'Log Reason cannot be empty';
            } else {
              return null;
            }
          },
          onSaved: (val) {
            _reason = val;
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 3,
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.done,
          controller: _methodController,
          style: Styles.inputStyle(),
          decoration: InputDecoration(
            label: const Text("Method of Approach"),
            errorBorder: Styles.errorBorder(),
            focusedBorder: Styles.focusBorder(),
            border: Styles.border(),
          ),
          validator: (arg) {
            if (isEmpty(arg)) {
              return 'Resolution Method cannot be empty';
            } else {
              return null;
            }
          },
          onSaved: (val) {
            _method = val;
          },
        ),
      ],
    );
  }

  Widget editableUI() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FarmManagerInputDropdownWidget(
          dialogWidget: FarmManagementSelectLogStatusMenu(
            selectedLogStatus: (value) {
              _logStatusController.text = value;
              setState(() {
                _logStatus = value;
              });
            },
          ),
          dialogTitle: 'Select Log Status',
          dialogTextController: _logStatusController,
          inputTitle: "Log Status",
          inputValue: (input) => _logStatus,
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }

  Widget testLogUI() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: Styles.inputStyle(),
            controller: _testTypeController,
            decoration: InputDecoration(
              label: const Text("Test Type"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Test Type cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _testType = val;
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: Styles.inputStyle(),
            controller: _logLaboratoryController,
            decoration: InputDecoration(
              label: const Text("Laboratory"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Laboratory cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _laboratory = val;
            },
          ),
        ),
      ],
    );
  }

  Widget purchaseUi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: TextFormField(
            keyboardType: const TextInputType.numberWithOptions(),
            style: Styles.inputStyle(),
            controller: _logQuantityController,
            decoration: InputDecoration(
              label: const Text("Quantity"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Quantity cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _logQuantity = val;
            },
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: TextFormField(
            keyboardType: TextInputType.name,
            style: Styles.inputStyle(),
            controller: _logSupplierController,
            decoration: InputDecoration(
              label: const Text("Supplier"),
              errorBorder: Styles.errorBorder(),
              focusedBorder: Styles.focusBorder(),
              border: Styles.border(),
            ),
            validator: (arg) {
              if (isEmpty(arg)) {
                return 'Laboratory cannot be empty';
              } else {
                return null;
              }
            },
            onSaved: (val) {
              _logSupplier = val;
            },
          ),
        ),
      ],
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

  Future<void> createNewLog() async {
    debugPrint(
      "Log Form: $_logName $_logType $_logFlag $_logStatus $startDate $endDate $_startTime $endTime $_logFarmingSeason$_method $_reason $_testType $_laboratory $_logQuantity $_logSupplier $_logNotes",
    );

    GetLogDetails? data;
    if (widget.addAssetLogPageArgs.isNewInput) {
      data = await createLog(
        CreateLogRequest(
          createdBy: USER_ID,
          createdDate: DateTime.now(),
          endDate: endDate ?? DateTime.now(),
          endTime: buildStartStopTime(endDate!, endTime!),
          farmingSeason: _logFarmingSeason ?? "",
          flags: _logFlag ?? "",
          isGroupAssignment: isGroup,
          isMovement: isMovement,
          laboratory: _laboratory ?? "",
          method: _method ?? "",
          modifiedDate: DateTime.now(),
          name: _logName ?? "",
          notes: _logNotes ?? "",
          organizationId: widget.addAssetLogPageArgs.details!.farmArgs.organizationId,
          quantity: _logQuantity ?? "",
          reason: _reason ?? "",
          siteId: widget.addAssetLogPageArgs.details!.farmArgs.siteId,
          source: _logSupplier ?? "",
          startDate: startDate ?? DateTime.now(),
          startTime: buildStartStopTime(startDate!, startTime!),
          status: _logStatus ?? "",
          testType: _testType ?? "",
          type: _logType ?? "",
        ),
      );
    } else {
      data = await updateLog(
        widget.addAssetLogPageArgs.logDetails!.id ?? 0,
        CreateLogRequest(
          createdBy: USER_ID,
          createdDate: DateTime.now(),
          endDate: endDate ?? DateTime.now(),
          endTime: buildStartStopTime(endDate!, endTime!),
          farmingSeason: _logFarmingSeason ?? "",
          flags: _logFlag ?? "",
          isGroupAssignment: isGroup,
          isMovement: isMovement,
          laboratory: _laboratory ?? "",
          method: _method ?? "",
          modifiedDate: DateTime.now(),
          name: _logName ?? "",
          notes: _logNotes ?? "",
          organizationId: widget.addAssetLogPageArgs.logDetails!.organizationId,
          quantity: _logQuantity ?? "",
          reason: _reason ?? "",
          siteId: widget.addAssetLogPageArgs.logDetails!.siteId,
          source: _logSupplier ?? "",
          startDate: startDate ?? DateTime.now(),
          startTime: buildStartStopTime(startDate!, startTime!),
          status: _logStatus ?? "",
          testType: _testType ?? "",
          type: _logType ?? "",
        ),
      );
    }

    _pandora.reRouteUserPopCurrent(
      context,
      "/farmManagerAdditionalDetails",
      FileUploadDetailsArgs(null, reserializeJson(data!), false),
    );
    debugPrint("ready for stage ");
  }

  Completed reserializeJson(GetLogDetails data) {
    return Completed(
      organizationId: data.data.organizationId,
      notes: data.data.notes,
      modifiedDate: data.data.modifiedDate,
      modifiedBy: data.data.modifiedBy,
      type: data.data.type,
      status: data.data.status,
      quantity: data.data.quantity,
      name: data.data.name,
      flags: data.data.flags,
      deletedBy: data.data.deletedBy,
      deleted: data.data.deleted,
      createdDate: data.data.createdDate,
      createdBy: data.data.createdBy,
      endDate: data.data.endDate,
      endTime: data.data.endTime,
      farmingSeason: data.data.farmingSeason,
      id: (widget.addAssetLogPageArgs.isNewInput) ? data.data.id : widget.addAssetLogPageArgs.logDetails!.id,
      isGroupAssignment: data.data.isGroupAssignment,
      isMovement: data.data.isMovement,
      laboratory: data.data.laboratory,
      method: data.data.method,
      reason: data.data.reason,
      siteId: data.data.siteId,
      source: data.data.source,
      startDate: data.data.startDate,
      startTime: data.data.startTime,
      testType: data.data.testType,
    );
  }

  DateTime buildStartStopTime(DateTime date, DateTime time) {
    return DateTime(
      date.month,
      date.month,
      date.day,
      time.hour,
      time.minute,
      time.second,
      time.millisecond,
      time.microsecond,
    );
  }
}
