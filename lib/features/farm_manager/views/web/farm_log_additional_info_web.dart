import 'package:beamer/beamer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/farm_manager/views/web/upload_archives_web.dart';
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
import 'package:smat_crow/features/shared/data/controller/shared_controller.dart';
import 'package:smat_crow/features/shared/views/custom_app_bar.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class FarmLogAdditionalInfoWeb extends StatefulHookConsumerWidget {
  const FarmLogAdditionalInfoWeb({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FarmLogAdditionalInfoState();
}

class _FarmLogAdditionalInfoState extends ConsumerState<FarmLogAdditionalInfoWeb> {
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
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;
    final shared = ref.watch(sharedProvider);
    final path = beamState.pathPatternSegments.last;
    useEffect(
      () {
        Future(() async {
          await ref.read(logProvider).getLogs(path);
          if (ref.read(assetProvider).orgAssetList.isEmpty) {
            await ref.read(assetProvider).getOrgAssets();
          }
          if (shared.assetTypesList.isEmpty) {
            await shared.getAssetTypes();
          }
          await fetchAdditionalLogDetails();
        });
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: customAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const BoldHeaderText(
                      text: additionalInfoText,
                      fontSize: SpacingConstants.size28,
                    ),
                    const Color600Text(text: addFarmLogDesc),
                    const Ymargin(SpacingConstants.double20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: LogInfoItem(
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
                                        DialogHeader(
                                          headText: addParticipantText,
                                          callback: () {
                                            participantName.clear();
                                            participantRole.clear();
                                            OneContext().popDialog();
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
                                                  hintText: participantNameText,
                                                  text: participantNameText,
                                                  keyboardType: TextInputType.name,
                                                  controller: participantName,
                                                  validator: (arg) {
                                                    if (isEmpty(arg)) {
                                                      return '$participantNameText $cannotBeEmpty';
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                                const Ymargin(
                                                  SpacingConstants.double20,
                                                ),
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
                                                const Ymargin(
                                                  SpacingConstants.double20,
                                                ),
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
                                                            id: path,
                                                          )
                                                          .then((value) {
                                                        fetchAdditionalLogDetails();
                                                        OneContext().popDialog();
                                                        participantName.clear();
                                                        participantRole.clear();
                                                      });
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: kIsWeb
                                                      ? SpacingConstants.size40
                                                      : MediaQuery.of(context).viewInsets.bottom,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                !Responsive.isMobile(context),
                              );
                            },
                            logList: logOwnersList,
                          ),
                        ),
                        const Xmargin(SpacingConstants.double20),
                        Expanded(
                          child: LogInfoItem(
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
                                        DialogHeader(
                                          headText: addRemarkText,
                                          callback: () {
                                            participantName.clear();
                                            participantRole.clear();
                                            OneContext().popDialog();
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
                                                const Ymargin(
                                                  SpacingConstants.double20,
                                                ),
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
                                                const Ymargin(
                                                  SpacingConstants.double20,
                                                ),
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
                                                            id: path,
                                                          )
                                                          .then((value) {
                                                        OneContext().popDialog();
                                                        fetchAdditionalLogDetails();
                                                        participantName.clear();
                                                        participantRole.clear();
                                                      });
                                                    }
                                                  },
                                                ),
                                                SizedBox(
                                                  height: kIsWeb
                                                      ? SpacingConstants.size40
                                                      : MediaQuery.of(context).viewInsets.bottom,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  },
                                ),
                                !Responsive.isMobile(context),
                              );
                            },
                            logList: logRemarksList,
                          ),
                        ),
                      ],
                    ),
                    const Ymargin(SpacingConstants.double20),
                    Row(
                      children: [
                        Expanded(
                          child: LogInfoItem(
                            title: logAssetText,
                            subtitle: addLogAssetText,
                            body: noLogAssetText,
                            function: () {
                              customDialogAndModal(
                                context,
                                HookBuilder(
                                  builder: (context) {
                                    final selected = useState("");
                                    final assetCon = ref.watch(assetProvider);
                                    return StatefulBuilder(
                                      builder: (context, setState) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            DialogHeader(
                                              headText: "$selectText $logAssetText",
                                              callback: () {
                                                OneContext().popDialog();
                                              },
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              showIcon: true,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              physics: const AlwaysScrollableScrollPhysics(),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: SpacingConstants.double20,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ...shared.assetTypesList.map(
                                                    (e) => Padding(
                                                      padding: const EdgeInsets.only(
                                                        right: SpacingConstants.font10,
                                                      ),
                                                      child: InkWell(
                                                        onTap: () async {
                                                          selected.value = e.types ?? "";
                                                          await ref
                                                              .read(
                                                            assetProvider,
                                                          )
                                                              .getOrgAssets(
                                                            orgId: path,
                                                            queries: {"assetTypeName": e.types},
                                                          );
                                                          setState(() {});
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(
                                                              SpacingConstants.size5,
                                                            ),
                                                            color: selected.value == e.types
                                                                ? AppColors.SmatCrowNeuBlue900
                                                                : AppColors.SmatCrowNeuBlue100,
                                                          ),
                                                          padding: const EdgeInsets.symmetric(
                                                            horizontal: SpacingConstants.font10,
                                                            vertical: SpacingConstants.font10,
                                                          ),
                                                          child: Row(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(
                                                                e.types ?? emptyString,
                                                                style: Styles.smatCrowSubParagraphRegular(
                                                                  color: selected.value == e.types
                                                                      ? AppColors.SmatCrowNeuBlue100
                                                                      : AppColors.SmatCrowNeuBlue900,
                                                                ).copyWith(
                                                                  fontSize: SpacingConstants.font12,
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Ymargin(
                                              SpacingConstants.double20,
                                            ),
                                            if (assetCon.loading)
                                              const Center(
                                                child: CupertinoActivityIndicator(),
                                              ),
                                            ...assetCon.orgAssetList
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
                                                                    .watch(
                                                                      assetProvider,
                                                                    )
                                                                    .orgAssetList
                                                                    .firstWhere(
                                                                      (element) =>
                                                                          element.assets!.name == participantRole.text,
                                                                    )
                                                                    .assets!
                                                                    .uuid ??
                                                                "",
                                                            id: path,
                                                          )
                                                          .then((value) {
                                                        OneContext().popDialog();
                                                        fetchAdditionalLogDetails();
                                                        participantRole.clear();
                                                      });
                                                    },
                                                  ),
                                                )
                                                .toList()
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                                !Responsive.isMobile(context),
                              );
                            },
                            logList: logAssetsList,
                          ),
                        ),
                      ],
                    ),
                    const Ymargin(SpacingConstants.size30),
                    CustomButton(
                      text: nextText,
                      onPressed: () {
                        if (logAssetsList.isEmpty || logOwnersList.isEmpty || logRemarksList.isEmpty) {
                          snackBarMsg(validationWarningText);
                          return;
                        }
                        customDialog(
                          context,
                          const UploadArchivesWeb(title: logText),
                        );
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
            )
          ],
        ),
      ),
    );
  }
}
