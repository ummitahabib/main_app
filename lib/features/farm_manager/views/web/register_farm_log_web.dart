// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:one_context/one_context.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/observation_activity_ui.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/purchase_ui.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/select_container.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/test_log_ui.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/data/controller/site_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/data/model/add_log_request.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_drop_down.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class RegisterFarmLogWeb extends StatefulHookConsumerWidget {
  const RegisterFarmLogWeb({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterFarmWebLogState();
}

enum LogTypeEnum { activity, observation, tests, health, purchase }

class _RegisterFarmWebLogState extends ConsumerState<RegisterFarmLogWeb> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final logTitle = useTextEditingController();
    final logMethod = useTextEditingController();
    final logTestType = useTextEditingController();
    final logQuantity = useTextEditingController();
    final logSupplier = useTextEditingController();
    final logLab = useTextEditingController();
    final logReason = useTextEditingController();
    final farmSeason = useState<String?>(null);
    final logType = useState<String?>(null);
    final logFlag = useState<String?>(null);
    final logStatus = useState<String?>(null);
    final logGoalTask = useState<String?>(null);
    final logMovementTask = useState<String?>(null);
    final reasonForAcq = useTextEditingController();
    final cost = useTextEditingController();
    final logCurrency = useState<String?>(null);
    final startTime = useState<DateTime>(DateTime.now()), endTime = useState<DateTime>(DateTime.now());
    final logDate = useState<Map<String, ValueNotifier<String?>>>(
      {"start": useState<String?>(null), "end": useState<String?>(null)},
    );
    final timePicked = useState<Map<String, ValueNotifier<String?>>>(
      {"start": useState<String?>(null), "end": useState<String?>(null)},
    );
    final shared = ref.read(sharedProvider);
    final logController = ref.watch(logProvider);
    useEffect(
      () {
        Future(() {
          if (shared.logStatusList.isEmpty) {
            shared.getLogStatus();
          }
          if (shared.flagList.isEmpty) {
            shared.getFlags();
          }

          if (shared.logTypesList.isEmpty) {
            shared.getLogTypes();
          }

          if (shared.currencyList.isEmpty) {
            shared.getCurrencies();
          }
        });
        if (logController.logResponse != null) {
          logTitle.text = logController.logResponse!.log!.name ?? emptyString;
          logQuantity.text = (logController.logResponse!.log!.quantity ?? 0).toString();
          cost.text = (logController.logResponse!.log!.cost ?? 0).toString().replaceAll(".", "");
          reasonForAcq.text = logController.logResponse!.log!.notes ?? "";
          logMethod.text = logController.logResponse!.log!.method ?? "";
          logTestType.text = logController.logResponse!.log!.testType ?? "";
          logSupplier.text = logController.logResponse!.log!.source ?? "";
          logLab.text = logController.logResponse!.log!.laboratory ?? "";
          logReason.text = logController.logResponse!.log!.reason ?? "";
          farmSeason.value = (logController.logResponse!.log!.farmingSeasonId ?? "").toString();
          logFlag.value = (logController.logResponse!.log!.logFlags!.isNotEmpty && shared.flagList.isNotEmpty)
              ? (shared.flagList
                      .firstWhere(
                        (element) => element.uuid == logController.logResponse!.log!.logFlags!.first,
                        orElse: () => shared.flagList.first,
                      )
                      .flag ??
                  "")
              : null;
          logDate.value['start']!.value = DateFormat("yyyy-MM-dd").format(
            logController.logResponse!.log!.startDate ?? DateTime.now(),
          );
          logDate.value['end']!.value = DateFormat("yyyy-MM-dd").format(
            logController.logResponse!.log!.endDate ?? DateTime.now(),
          );
          startTime.value = logController.logResponse!.log!.startTime ?? DateTime.now();
          endTime.value = logController.logResponse!.log!.endTime ?? DateTime.now();
          timePicked.value['start']!.value = DateFormat("yyyy-MM-dd").format(
            logController.logResponse!.log!.startTime ?? DateTime.now(),
          );
          timePicked.value['end']!.value = DateFormat("yyyy-MM-dd").format(
            logController.logResponse!.log!.endTime ?? DateTime.now(),
          );
          logStatus.value = logController.logResponse!.log!.status ?? emptyString;
          logCurrency.value = logController.logResponse!.log!.currency ?? emptyString;
          logGoalTask.value = (logController.logResponse!.log!.isGroupAssignment ?? false) ? "Yes" : "No";
          logMovementTask.value = (logController.logResponse!.log!.isMovement ?? false) ? "Yes" : "No";
          logType.value = logController.logResponse!.log!.type ?? emptyString;
        }
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(context),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: const EdgeInsets.all(SpacingConstants.double20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BoldHeaderText(
                        text: (logController.logResponse != null) ? updateFarmLog : addFarmLog,
                        fontSize: SpacingConstants.size28,
                      ),
                      const Color600Text(text: addFarmLogDesc),
                      const Ymargin(SpacingConstants.double20),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextField(
                                  hintText: logNameText,
                                  controller: logTitle,
                                  text: logNameText,
                                  validator: (arg) {
                                    if (isEmpty(arg)) {
                                      return '$logNameText $cannotBeEmpty';
                                    } else {
                                      return null;
                                    }
                                  },
                                ),
                                const Ymargin(SpacingConstants.double20),
                                SelectContainer(
                                  title: logFlagText,
                                  hintText: selectOptionText,
                                  value: logFlag.value,
                                  function: () {
                                    customDialogAndModal(
                                      context,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DialogHeader(
                                            headText: "$selectText $logFlagText",
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            callback: () {
                                              if (Responsive.isMobile(
                                                context,
                                              )) {
                                                Navigator.pop(context);
                                                return;
                                              }
                                              OneContext().popDialog();
                                            },
                                            showIcon: true,
                                          ),
                                          ...shared.flagList.map(
                                            (e) => RadioListTile(
                                              value: logFlag.value == e.flag,
                                              groupValue: true,
                                              dense: true,
                                              title: Text(
                                                e.flag ?? "",
                                                style: Styles.smatCrowSubParagraphRegular(
                                                  color: AppColors.SmatCrowNeuBlue900,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                logFlag.value = e.flag;
                                                if (Responsive.isMobile(
                                                  context,
                                                )) {
                                                  Navigator.pop(context);
                                                  return;
                                                }
                                                OneContext().popDialog();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      !Responsive.isMobile(context),
                                    );
                                  },
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                ),
                                const Ymargin(SpacingConstants.double20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SelectContainer(
                                        value: timePicked.value['start']!.value,
                                        title: timeText,
                                        hintText: startTimeText,
                                        function: () async {
                                          if (FocusScope.of(context).hasFocus) {
                                            FocusScope.of(context).unfocus();
                                          }
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (time != null) {
                                            timePicked.value['start']!.value = time.format(context);
                                            startTime.value = DateFormat("HH:mm:ss").parse(
                                              "${time.hour}:${time.minute}:${00}",
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    const Xmargin(SpacingConstants.size10),
                                    Expanded(
                                      child: SelectContainer(
                                        value: timePicked.value['end']!.value,
                                        title: "  ",
                                        hintText: endTimeText,
                                        function: () async {
                                          if (FocusScope.of(context).hasFocus) {
                                            FocusScope.of(context).unfocus();
                                          }
                                          final time = await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          );
                                          if (time != null) {
                                            timePicked.value['end']!.value = time.format(context);
                                            endTime.value = DateFormat("HH:mm:ss").parse(
                                              "${time.hour}:${time.minute}:${00}",
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Ymargin(SpacingConstants.double20),
                                SelectContainer(
                                  title: logStatusText,
                                  hintText: selectOptionText,
                                  value: logStatus.value,
                                  function: () {
                                    customDialogAndModal(
                                      context,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DialogHeader(
                                            headText: "$selectText $logStatusText",
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            callback: () {
                                              if (Responsive.isMobile(
                                                context,
                                              )) {
                                                Navigator.pop(context);
                                                return;
                                              }
                                              OneContext().popDialog();
                                            },
                                            showIcon: true,
                                          ),
                                          ...shared.logStatusList.map(
                                            (e) => RadioListTile(
                                              value: logStatus.value == e.status,
                                              groupValue: true,
                                              dense: true,
                                              title: Text(
                                                e.status ?? emptyString,
                                                style: Styles.smatCrowSubParagraphRegular(
                                                  color: AppColors.SmatCrowNeuBlue900,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                logStatus.value = e.status;
                                                if (Responsive.isMobile(
                                                  context,
                                                )) {
                                                  Navigator.pop(context);
                                                  return;
                                                }
                                                OneContext().popDialog();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      !Responsive.isMobile(context),
                                    );
                                  },
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                ),
                                const Ymargin(SpacingConstants.size20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const BoldHeaderText(text: groupTaskText),
                                    const Color600Text(text: isGroupTaskText),
                                    ...[yes, no].map(
                                      (e) => RadioListTile(
                                        contentPadding: EdgeInsets.zero,
                                        value: logGoalTask.value == e,
                                        groupValue: true,
                                        dense: true,
                                        title: Text(
                                          e,
                                          style: Styles.smatCrowSubParagraphRegular(
                                            color: AppColors.SmatCrowNeuBlue900,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          logGoalTask.value = e;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Ymargin(SpacingConstants.double20),
                                Builder(
                                  builder: (context) {
                                    if (logType.value == null) {
                                      return Container();
                                    }
                                    if (logType.value!.toLowerCase() == LogTypeEnum.activity.name ||
                                        logType.value!.toLowerCase() == LogTypeEnum.observation.name) {
                                      return ObservationActiviyUI(
                                        logReason: logReason,
                                        logMethod: logMethod,
                                      );
                                    }

                                    if (logType.value!.toLowerCase().contains(LogTypeEnum.tests.name) ||
                                        logType.value!.toLowerCase().contains(
                                              LogTypeEnum.health.name,
                                            )) {
                                      return TestLogUI(
                                        logTestType: logTestType,
                                        logLab: logLab,
                                      );
                                    }
                                    if (logType.value!.toLowerCase().contains(LogTypeEnum.purchase.name)) {
                                      return PurchaseUI(
                                        logQuantity: logQuantity,
                                        logSupplier: logSupplier,
                                        cost: cost,
                                      );
                                    }
                                    return Container();
                                  },
                                ),
                              ],
                            ),
                          ),
                          const Xmargin(SpacingConstants.double20),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SelectContainer(
                                  title: farmingSeasonText,
                                  hintText: selectOptionText,
                                  value: farmSeason.value,
                                  function: () {
                                    customDialogAndModal(
                                      context,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DialogHeader(
                                            headText: "$selectText $farmingSeasonText",
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            callback: () {
                                              if (Responsive.isMobile(
                                                context,
                                              )) {
                                                Navigator.pop(context);
                                                return;
                                              }
                                              OneContext().popDialog();
                                            },
                                            showIcon: true,
                                          ),
                                          ...shared.seasonList.map(
                                            (e) => RadioListTile(
                                              value: farmSeason.value == e.description,
                                              groupValue: true,
                                              dense: true,
                                              title: Text(
                                                e.description ?? "",
                                                style: Styles.smatCrowSubParagraphRegular(
                                                  color: AppColors.SmatCrowNeuBlue900,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                farmSeason.value = e.description;
                                                if (Responsive.isMobile(
                                                  context,
                                                )) {
                                                  Navigator.pop(context);
                                                  return;
                                                }
                                                OneContext().popDialog();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      !Responsive.isMobile(context),
                                    );
                                  },
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                ),
                                const Ymargin(SpacingConstants.double20),
                                Row(
                                  children: [
                                    Expanded(
                                      child: SelectContainer(
                                        value: logDate.value['start']!.value,
                                        title: dateText,
                                        hintText: startDateText,
                                        function: () async {
                                          if (FocusScope.of(context).hasFocus) {
                                            FocusScope.of(context).unfocus();
                                          }
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2010),
                                            lastDate: DateTime(2100),
                                            currentDate: DateTime.now(),
                                          );
                                          if (date != null) {
                                            logDate.value['start']!.value = DateFormat("yyyy-MM-dd").format(date);
                                          }
                                        },
                                      ),
                                    ),
                                    const Xmargin(SpacingConstants.size10),
                                    Expanded(
                                      child: SelectContainer(
                                        value: logDate.value['end']!.value,
                                        title: "  ",
                                        hintText: endDateText,
                                        function: () async {
                                          if (FocusScope.of(context).hasFocus) {
                                            FocusScope.of(context).unfocus();
                                          }
                                          final date = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1970),
                                            lastDate: DateTime(2100),
                                            currentDate: DateTime.now(),
                                          );
                                          if (date != null) {
                                            logDate.value['end']!.value = DateFormat("yyyy-MM-dd").format(date);
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Ymargin(SpacingConstants.double20),
                                SelectContainer(
                                  title: logTypeText,
                                  hintText: selectOptionText,
                                  value: logType.value,
                                  function: () {
                                    customDialogAndModal(
                                      context,
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          DialogHeader(
                                            headText: "$selectText $logTypeText",
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            callback: () {
                                              if (Responsive.isMobile(
                                                context,
                                              )) {
                                                Navigator.pop(context);
                                                return;
                                              }
                                              OneContext().popDialog();
                                            },
                                            showIcon: true,
                                          ),
                                          ...shared.logTypesList.map(
                                            (e) => RadioListTile(
                                              value: logType.value == e.types,
                                              groupValue: true,
                                              dense: true,
                                              title: Text(
                                                e.types ?? emptyString,
                                                style: Styles.smatCrowSubParagraphRegular(
                                                  color: AppColors.SmatCrowNeuBlue900,
                                                ),
                                              ),
                                              onChanged: (value) {
                                                logType.value = e.types;
                                                if (Responsive.isMobile(
                                                  context,
                                                )) {
                                                  Navigator.pop(context);
                                                  return;
                                                }
                                                OneContext().popDialog();
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      !Responsive.isMobile(context),
                                    );
                                  },
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                ),
                                const Ymargin(SpacingConstants.double20),
                                CustomDropdownField(
                                  labelText: currencyText,
                                  items: ref.watch(sharedProvider).currencyList.map((e) => e.name).toList(),
                                  value: logCurrency.value,
                                  hintText: selectOptionText,
                                  onChanged: (value) {
                                    logCurrency.value = value;
                                  },
                                ),
                                const Ymargin(SpacingConstants.double20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const BoldHeaderText(
                                      text: movementTaskText,
                                    ),
                                    const Color600Text(
                                      text: isMovementTaskText,
                                    ),
                                    ...[yes, no].map(
                                      (e) => RadioListTile(
                                        contentPadding: EdgeInsets.zero,
                                        value: logMovementTask.value == e,
                                        groupValue: true,
                                        dense: true,
                                        title: Text(
                                          e,
                                          style: Styles.smatCrowSubParagraphRegular(
                                            color: AppColors.SmatCrowNeuBlue900,
                                          ),
                                        ),
                                        onChanged: (value) {
                                          logMovementTask.value = e;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const Ymargin(SpacingConstants.size20),
                                CustomTextField(
                                  controller: reasonForAcq,
                                  hintText: reasonForAcqText,
                                  validator: (arg) {
                                    if (isEmpty(arg)) {
                                      return '$reasonText $cannotBeEmpty';
                                    } else {
                                      return null;
                                    }
                                  },
                                  text: reasonText,
                                  maxLines: 4,
                                  keyboardType: TextInputType.multiline,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Ymargin(SpacingConstants.size30),
                      CustomButton(
                        text: nextText,
                        loading: logController.loading,
                        onPressed: () async {
                          if (FocusScope.of(context).hasFocus) {
                            FocusScope.of(context).unfocus();
                          }
                          if (logStatus.value == null ||
                              logFlag.value == null ||
                              logType.value == null ||
                              farmSeason.value == null ||
                              logDate.value['start']!.value == null ||
                              logDate.value['end']!.value == null ||
                              timePicked.value['start']!.value == null ||
                              timePicked.value['end']!.value == null) {
                            snackBarMsg(validationWarningText);
                            return;
                          }
                          if (logType.value!.toLowerCase().contains(LogTypeEnum.purchase.name) &&
                              logCurrency.value == null) {
                            snackBarMsg(currencyWarningText);
                            return;
                          }

                          if (formKey.currentState!.validate()) {
                            if (ref.read(sharedProvider).userInfo == null) {
                              return;
                            }

                            final req = AddLogRequest(
                              createdBy: shared.userInfo!.user.id,
                              deleted: "N",
                              createdDate: DateTime.now().toUtc(),
                              modifiedDate: DateTime.now().toUtc(),
                              organizationId: await ref.read(sharedProvider).getOrganizationId(),
                              name: logTitle.text,
                              status: logStatus.value ?? "",
                              logFlags: [
                                shared.flagList
                                        .firstWhere(
                                          (element) => element.flag == logFlag.value,
                                        )
                                        .uuid ??
                                    emptyString
                              ],
                              type: logType.value!,
                              notes: reasonForAcq.text,
                              endDate: DateTime.parse(logDate.value['end']!.value!).toUtc(),
                              endTime: buildStartStopTime(
                                DateTime.parse(logDate.value['end']!.value!),
                                endTime.value,
                              ).toUtc(),
                              startDate: DateTime.parse(logDate.value['start']!.value!).toUtc(),
                              startTime: buildStartStopTime(
                                DateTime.parse(logDate.value['start']!.value!),
                                startTime.value,
                              ).toUtc(),
                              cost: cost.text.isEmpty ? 0.0 : double.parse(cost.text.replaceAll(",", "")),
                              farmingSeason: shared.seasonList
                                  .firstWhere(
                                    (element) => element.description == farmSeason.value,
                                  )
                                  .uuid,
                              flags: logFlag.value,
                              currency: shared.currencyList
                                  .firstWhere(
                                    (element) => element.name == logCurrency.value,
                                  )
                                  .code,
                              quantity: logQuantity.text.isEmpty ? null : logQuantity.text,
                              isGroupAssignment: logGoalTask.value == yes ? true : false,
                              isMovement: logMovementTask.value == yes ? true : false,
                              laboratory: logLab.text,
                              method: logMethod.text.isEmpty ? null : logMethod.text,
                              reason: logReason.text.isEmpty ? null : logReason.text,
                              siteId: ref.read(siteProvider).site == null
                                  ? await Pandora().getFromSharedPreferences("siteId")
                                  : ref.read(siteProvider).site!.id,
                              source: logSupplier.text.isEmpty ? null : logSupplier.text,
                              testType: logTestType.text.isEmpty ? null : logTestType.text,
                            );
                            if (ref.read(logProvider).logResponse != null) {
                              await ref.read(logProvider).updateLog(req).then((value) {
                                if (value) {
                                  Pandora().reRouteUser(
                                    context,
                                    "${ConfigRoute.farmLogAddInfo}/${ref.read(logProvider).addLogResponse!.uuid}",
                                    ref.read(logProvider).addLogResponse!.uuid,
                                  );
                                }
                              });
                            } else {
                              await ref.read(logProvider).addLog(req).then((value) {
                                if (value) {
                                  Pandora().reRouteUser(
                                    context,
                                    "${ConfigRoute.farmLogAddInfo}/${ref.read(logProvider).addLogResponse!.uuid}",
                                    ref.read(logProvider).addLogResponse!.uuid,
                                  );
                                }
                              });
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
              const Xmargin(SpacingConstants.size20),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(SpacingConstants.font16),
                    image: const DecorationImage(
                      image: AssetImage(AppAssets.logImage),
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: SpacingConstants.double20,
                      bottom: SpacingConstants.double20,
                      right: SpacingConstants.double20,
                    ),
                    child: Text(
                      expandHorizon,
                      maxLines: 3,
                      style: Styles.smatCrowHeadingBold3(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
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
