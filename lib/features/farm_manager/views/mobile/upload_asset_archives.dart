// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/farm_manager/data/controller/farm_manager_controller.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/organisation/views/widgets/custom_action_widget.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/firebase_controller.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/views/modal_stick.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/shared/views/upload_images.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class UploadAssetArchives extends StatefulHookConsumerWidget {
  const UploadAssetArchives({
    super.key,
    required this.title,
  });
  final String title;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadAssetArchivesState();
}

class _UploadAssetArchivesState extends ConsumerState<UploadAssetArchives> {
  Future<void> uploadToFirebase(ValueNotifier<String?> url, [String folderPath = "organization"]) async {
    url.value = await ref.watch(firebaseProvider).uploadImageToFirebase(folderPath);
    return;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = useState<String?>(null);
    final fileUrl = useState<String?>(null);
    final fileList = useState<List<String>>([]);
    final imageList = useState<List<String>>([]);
    final asset = ref.watch(assetProvider);
    final logController = ref.watch(logProvider);

    useEffect(
      () {
        if (widget.title.contains(assetText) && asset.assetDetails != null) {
          fileList.value = asset.assetDetails!.additionalInfo!.assetFiles!.map((e) => e.url ?? "").toList();
          imageList.value = asset.assetDetails!.additionalInfo!.assetMedia!.map((e) => e.url ?? "").toList();
          return;
        }
        if (widget.title.contains(logText) && logController.logResponse != null) {
          fileList.value = logController.logResponse!.additionalInfo!.logFiles!.map((e) => e.url ?? "").toList();
          imageList.value = logController.logResponse!.additionalInfo!.logMedia!.map((e) => e.url ?? "").toList();
          return;
        }
        return null;
      },
      [],
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.keyboard_arrow_left,
            size: 30,
          ),
          splashRadius: 20,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(SpacingConstants.double20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BoldHeaderText(
              text: widget.title.contains(assetText) ? uploadAssetArchiveText : uploadLogArchiveText,
              fontSize: SpacingConstants.font24,
            ),
            const Ymargin(SpacingConstants.size10),
            Text(
              uploadArchiveLabelText,
              style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue400),
            ),
            const Ymargin(SpacingConstants.size20),
            UploadImage(
              loading: ref.watch(firebaseProvider).loading ||
                  (widget.title.contains(assetText)
                      ? ref.watch(assetProvider).loading
                      : ref.watch(logProvider).loading),
              title: uploadImagesText,
              function: () {
                imageUrl.value = null;
                uploadToFirebase(imageUrl, "/farm-manager/images").then((value) async {
                  await Future.delayed(const Duration(seconds: 1));
                  imageUrl.value = ref.read(firebaseProvider).downloadUrl;
                  if (imageUrl.value == null) return;
                  if (imageUrl.value != null && !fileList.value.contains(imageUrl.value)) {
                    imageList.value.add(imageUrl.value!);
                    imageList.notifyListeners();
                  }
                  if (widget.title.contains("Asset")) {
                    await ref.read(assetProvider).addAssetImage(imageUrl.value!);
                  } else {
                    await ref.read(logProvider).addLogMedia(imageUrl.value!);
                  }
                  imageUrl.value = null;
                });
              },
              value: imageList,
            ),
            const Ymargin(SpacingConstants.size20),
            UploadImage(
              loading: ref.watch(firebaseProvider).loading ||
                  (widget.title.contains(assetText)
                      ? ref.watch(assetProvider).loading
                      : ref.watch(logProvider).loading),
              title: uploadFileLabel1,
              value: fileList,
              function: () {
                fileUrl.value = null;
                uploadToFirebase(fileUrl, "/farm-manager/files").then(
                  (value) async {
                    await Future.delayed(const Duration(seconds: 1));
                    fileUrl.value = ref.read(firebaseProvider).downloadUrl;

                    if (fileUrl.value == null) return;
                    if (fileUrl.value != null && !fileList.value.contains(fileUrl.value)) {
                      fileList.value.add(fileUrl.value!);
                      fileList.notifyListeners();
                    }

                    if (widget.title.contains(assetText)) {
                      await ref.read(assetProvider).addAssetFile(fileUrl.value!);
                    } else {
                      await ref.read(logProvider).addLogFile(fileUrl.value!);
                    }
                    fileUrl.value = null;
                  },
                );
              },
            ),
            const Spacer(),
            CustomButton(
              text: widget.title,
              loading:
                  widget.title.contains(assetText) ? ref.watch(assetProvider).loading : ref.watch(logProvider).loading,
              onPressed: () {
                if (fileList.value.isEmpty || imageList.value.isEmpty) {
                  snackBarMsg(uploadWarningText);
                  return;
                }
                final manager = ref.read(farmManagerProvider);
                if (manager.getAgentUserType() == AgentTypeEnum.field) {
                  if (widget.title.contains(assetText)) {
                    ref.read(assetProvider).publishAsset(ref.read(assetProvider).addAssetResponse!.uuid!).then((value) {
                      if (value) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          OneContext().popDialog();
                        }
                        snackBarMsg(assetPublishedText, type: SnackBarType.success);
                        Pandora().reRouteUserPopCurrent(context, ConfigRoute.farmAsset, "args");
                      }
                    });
                  } else {
                    ref.read(logProvider).publishLog(ref.read(logProvider).addLogResponse!.uuid!).then((value) {
                      if (value) {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          OneContext().popDialog();
                        }
                        snackBarMsg(logPublishedText, type: SnackBarType.success);
                        Pandora().reRouteUserPopCurrent(context, ConfigRoute.farmLog, "args");
                      }
                    });
                  }
                } else {
                  customModalSheet(
                    context,
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const ModalStick(),
                        CustomButton(
                          width: SpacingConstants.size200,
                          text: rejectText,
                          loading: widget.title.contains(assetText)
                              ? ref.watch(assetProvider).loading
                              : ref.watch(logProvider).loading,
                          leftIcon: Icons.clear,
                          color: AppColors.SmatCrowRed500,
                          textColor: Colors.white,
                          iconColor: Colors.white,
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              OneContext().popDialog();
                            }
                            if (widget.title.contains(assetText)) {
                              ref
                                  .read(assetProvider)
                                  .deleteAsset(ref.read(assetProvider).addAssetResponse!.uuid!, 'Rejected')
                                  .then((value) {
                                if (value) {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    OneContext().popDialog();
                                  }
                                  snackBarMsg(assetPublishedText, type: SnackBarType.success);
                                  Pandora().reRouteUserPopCurrent(context, ConfigRoute.farmAsset, "args");
                                }
                              });
                            } else {
                              ref
                                  .read(logProvider)
                                  .rejectLog(ref.read(logProvider).addLogResponse!.uuid!)
                                  .then((value) {
                                if (value) {
                                  if (Navigator.canPop(context)) {
                                    Navigator.pop(context);
                                  } else {
                                    OneContext().popDialog();
                                  }
                                  snackBarMsg(logPublishedText, type: SnackBarType.success);
                                  Pandora().reRouteUserPopCurrent(context, ConfigRoute.farmLog, "args");
                                }
                              });
                            }
                          },
                        ),
                        const Ymargin(SpacingConstants.double20),
                        CustomButton(
                          width: SpacingConstants.size200,
                          text: approveText,
                          loading: widget.title.contains(assetText)
                              ? ref.watch(assetProvider).loading
                              : ref.watch(logProvider).loading,
                          leftIcon: Icons.check,
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              OneContext().popDialog();
                            }
                            if (widget.title.contains(assetText)) {
                              ref
                                  .read(assetProvider)
                                  .publishAsset(ref.read(assetProvider).addAssetResponse!.uuid!)
                                  .then((value) {
                                if (value) {
                                  snackBarMsg(assetPublishedText, type: SnackBarType.success);
                                  Pandora().reRouteUserPopCurrent(context, ConfigRoute.farmAsset, "args");
                                }
                              });
                            } else {
                              ref
                                  .read(logProvider)
                                  .publishLog(ref.read(logProvider).addLogResponse!.uuid!)
                                  .then((value) {
                                if (value) {
                                  snackBarMsg(logPublishedText, type: SnackBarType.success);
                                  Pandora().reRouteUserPopCurrent(context, ConfigRoute.farmLog, "args");
                                }
                              });
                            }
                          },
                        ),
                        const Ymargin(40),
                      ],
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
