import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/farm_manager/views/mobile/upload_asset_archives.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/log_asset_item.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/log_info.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/log_owner_item.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/log_remark_item.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/organisation/views/widgets/dialog_header.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmLogAdditionalInfo extends StatefulHookConsumerWidget {
  const FarmLogAdditionalInfo({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmLogAdditionalInfoState();
}

class _FarmLogAdditionalInfoState extends ConsumerState<FarmLogAdditionalInfo> {
  List<Widget> logOwnersList = [];
  List<Widget> logRemarksList = [];
  List<Widget> logAssetsList = [];

  Future<void> fetchAdditionalLogDetails() async {
    if (ref.watch(logProvider).logResponse == null) return;
    final additionalLogDetails = ref.watch(logProvider).logResponse!.additionalInfo;
    if (additionalLogDetails == null) return;

    if (additionalLogDetails.logOwnersList!.isNotEmpty) {
      logOwnersList.clear();
      for (final owner in additionalLogDetails.logOwnersList!) {
        logOwnersList.add(LogOwnersItem(owner: owner));
      }
    }
    if (additionalLogDetails.logRemarks!.isNotEmpty) {
      logRemarksList.clear();
      for (final remark in additionalLogDetails.logRemarks!) {
        logRemarksList.add(LogRemarksItem(remark: remark));
      }
    }
    if (additionalLogDetails.logAssets!.isNotEmpty) {
      logAssetsList.clear();
      for (final asset in additionalLogDetails.logAssets!) {
        logAssetsList.add(LogsAssetsItem(asset: asset));
      }
    }

    if (mounted) {
      setState(() {
        logOwnersList = logOwnersList;
        logRemarksList = logRemarksList;
        logAssetsList = logAssetsList;
      });
    }
    return;
  }

  @override
  void initState() {
    super.initState();
    logOwnersList = [];
    logRemarksList = [];
    logAssetsList = [];
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final participantName = useTextEditingController(), participantRole = useTextEditingController();

    useEffect(
      () {
        Future(() {
          fetchAdditionalLogDetails();
          if (ref.read(assetProvider).orgAssetList.isEmpty) {
            ref.read(assetProvider).getOrgAssets();
          }
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const BoldHeaderText(
              text: additionalInfoText,
              fontSize: SpacingConstants.size28,
            ),
            const Color600Text(text: addFarmLogDesc),
            const Ymargin(SpacingConstants.double20),
            LogInfoItem(
              title: logOwnerText,
              subtitle: addParticipantText,
              body: noLogOwnerText,
              function: () {
                customDialogAndModal(
                  context,
                  Builder(
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ModalStick(),
                          DialogHeader(
                            headText: addParticipantText,
                            callback: () {
                              participantName.clear();
                              participantRole.clear();
                              if (!Navigator.canPop(context)) {
                                OneContext().popDialog();
                                return;
                              }
                              Navigator.pop(context);
                            },
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            showIcon: true,
                            showDivider: false,
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: SpacingConstants.double20,
                              right: SpacingConstants.double20,
                              bottom: SpacingConstants.double20,
                            ),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    hintText: participantNameText,
                                    text: participantNameText,
                                    keyboardType: TextInputType.name,
                                    controller: participantName,
                                    validator: (arg) {
                                      if (isEmpty(arg)) {
                                        return '$participantName $cannotBeEmpty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const Ymargin(SpacingConstants.double20),
                                  CustomTextField(
                                    hintText: participantRoleText,
                                    text: participantRoleText,
                                    controller: participantRole,
                                    keyboardType: TextInputType.text,
                                    validator: (arg) {
                                      if (isEmpty(arg)) {
                                        return '$participantRoleText $cannotBeEmpty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const Ymargin(SpacingConstants.double20),
                                  CustomButton(
                                    text: saveText,
                                    loading: ref.watch(logProvider).loading,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        ref
                                            .read(logProvider)
                                            .addLogOwner(
                                              participantName.text,
                                              participantRole.text,
                                            )
                                            .then((value) {
                                          participantName.clear();
                                          participantRole.clear();
                                          fetchAdditionalLogDetails();
                                          if (!Navigator.canPop(context)) {
                                            OneContext().popDialog();
                                            return;
                                          }
                                          Navigator.pop(context);
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: kIsWeb ? SpacingConstants.size40 : MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  Responsive.isTablet(context),
                );
              },
              logList: logOwnersList,
            ),
            const Ymargin(SpacingConstants.double20),
            LogInfoItem(
              title: logRemarkText,
              subtitle: addRemarkText,
              body: noLogRemarkText,
              function: () {
                customDialogAndModal(
                  context,
                  HookBuilder(
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const ModalStick(),
                          DialogHeader(
                            headText: addRemarkText,
                            callback: () {
                              participantName.clear();
                              participantRole.clear();
                              if (!Navigator.canPop(context)) {
                                OneContext().popDialog();
                                return;
                              }
                              Navigator.pop(context);
                            },
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            showIcon: true,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: SpacingConstants.double20,
                              right: SpacingConstants.double20,
                              bottom: SpacingConstants.double20,
                            ),
                            child: Form(
                              key: _formKey,
                              autovalidateMode: AutovalidateMode.always,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomTextField(
                                    hintText: remarkText,
                                    text: remarkText,
                                    keyboardType: TextInputType.name,
                                    controller: participantName,
                                    validator: (arg) {
                                      if (isEmpty(arg)) {
                                        return '$remarkText $cannotBeEmpty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const Ymargin(SpacingConstants.double20),
                                  CustomTextField(
                                    hintText: nextActionText,
                                    text: nextActionText,
                                    controller: participantRole,
                                    keyboardType: TextInputType.text,
                                    validator: (arg) {
                                      if (isEmpty(arg)) {
                                        return '$nextActionText $cannotBeEmpty';
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  const Ymargin(SpacingConstants.double20),
                                  CustomButton(
                                    text: saveText,
                                    loading: ref.watch(logProvider).loading,
                                    onPressed: () {
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      if (_formKey.currentState!.validate()) {
                                        ref
                                            .read(logProvider)
                                            .addLogRemark(
                                              participantName.text,
                                              participantRole.text,
                                            )
                                            .then((value) {
                                          participantName.clear();
                                          participantRole.clear();
                                          if (!Navigator.canPop(context)) {
                                            OneContext().popDialog();
                                            return;
                                          }
                                          Navigator.pop(context);
                                          fetchAdditionalLogDetails();
                                        });
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: kIsWeb ? SpacingConstants.size40 : MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                  Responsive.isTablet(context),
                );
              },
              logList: logRemarksList,
            ),
            const Ymargin(SpacingConstants.double20),
            LogInfoItem(
              title: logAssetText,
              subtitle: addLogAssetText,
              body: noLogAssetText,
              function: () {
                customDialogAndModal(
                  context,
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DialogHeader(
                            headText: "$selectText $logAssetText",
                            callback: () {
                              if (!Navigator.canPop(context)) {
                                OneContext().popDialog();
                                return;
                              }
                              Navigator.pop(context);
                            },
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            showIcon: true,
                          ),
                          if (ref.watch(assetProvider).loading) const Center(child: CupertinoActivityIndicator()),
                          ...ref
                              .watch(assetProvider)
                              .orgAssetList
                              .map(
                                (e) => RadioListTile(
                                  value: participantRole.text == e.assets!.name,
                                  groupValue: true,
                                  dense: true,
                                  title: Text(
                                    e.assets!.name ?? emptyString,
                                    style: Styles.smatCrowSubParagraphRegular(
                                      color: AppColors.SmatCrowNeuBlue900,
                                    ),
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      participantRole.text = e.assets!.name ?? emptyString;
                                    });
                                    ref
                                        .read(logProvider)
                                        .addLogAssets(
                                          ref
                                                  .watch(assetProvider)
                                                  .orgAssetList
                                                  .firstWhere(
                                                    (element) => element.assets!.name == participantRole.text,
                                                  )
                                                  .assets!
                                                  .uuid ??
                                              "",
                                        )
                                        .then((value) {
                                      participantRole.clear();
                                      if (!Navigator.canPop(context)) {
                                        OneContext().popDialog();
                                        return;
                                      }
                                      Navigator.pop(context);
                                      fetchAdditionalLogDetails();
                                    });
                                  },
                                ),
                              )
                              .toList()
                        ],
                      );
                    },
                  ),
                  Responsive.isTablet(context),
                );
              },
              logList: logAssetsList,
            ),
            const Ymargin(SpacingConstants.size30),
            CustomButton(
              text: nextText,
              onPressed: () {
                if (logAssetsList.isEmpty || logOwnersList.isEmpty || logRemarksList.isEmpty) {
                  snackBarMsg(validationWarningText);
                  return;
                }
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UploadAssetArchives(title: publishLog),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
