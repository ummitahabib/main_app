// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member, use_build_context_synchronously

import 'dart:developer';

import 'package:beamer/beamer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/features/organisation/data/controller/organization_controller.dart';
import 'package:smat_crow/features/shared/data/controller/asset_controller.dart';
import 'package:smat_crow/features/shared/data/controller/log_controller.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/shared/views/upload_images.dart';
import 'package:smat_crow/features/widgets/custom_button.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class UploadArchivesWeb extends StatefulHookConsumerWidget {
  const UploadArchivesWeb({
    super.key,
    required this.title,
  });
  final String title;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadAssetArchivesState();
}

class _UploadAssetArchivesState extends ConsumerState<UploadArchivesWeb> {
  Future<String?> uploadFileToFirebase1() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final storageRef = FirebaseStorage.instance.ref('uploads/${result.files.first.name}');
      final UploadTask uploadTask = storageRef.putData(result.files.first.bytes!);

      await uploadTask.whenComplete(() {});
      return storageRef.getDownloadURL().then((url) {
        log(url);
        return url;
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = useState<String?>(null);
    final fileUrl = useState<String?>(null);
    final fileList = useState<List<String>>([]);
    final imageList = useState<List<String>>([]);
    final asset = ref.watch(assetProvider);
    final logController = ref.watch(logProvider);
    final beamState = Beamer.of(context).currentBeamLocation.state as BeamState;

    final path = beamState.pathPatternSegments.last;

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(SpacingConstants.font10),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(SpacingConstants.double20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  BoldHeaderText(
                    text: widget.title.contains(assetText) ? uploadAssetArchiveText : uploadLogArchiveText,
                    fontSize: SpacingConstants.font21,
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.clear,
                      color: AppColors.SmatCrowNeuBlue900,
                    ),
                  )
                ],
              ),
              const Ymargin(SpacingConstants.size10),
              Text(
                uploadArchiveLabelText,
                style: Styles.smatCrowParagraphRegular(color: AppColors.SmatCrowNeuBlue400),
              ),
              const Ymargin(SpacingConstants.size20),
              UploadImage(
                loading: (widget.title.contains(assetText)
                    ? ref.watch(assetProvider).loading
                    : ref.watch(logProvider).loading),
                title: uploadImagesText,
                function: () async {
                  imageUrl.value = null;

                  imageUrl.value = await uploadFileToFirebase1();

                  if (imageUrl.value == null) return;
                  if (imageUrl.value != null && !fileList.value.contains(imageUrl.value)) {
                    imageList.value.add(imageUrl.value!);
                    imageList.notifyListeners();
                  }
                  if (widget.title.contains("Asset")) {
                    final id = await Pandora().getFromSharedPreferences("id");
                    await ref.read(assetProvider).addAssetImage(imageUrl.value!, id: id);
                  } else {
                    await ref.read(logProvider).addLogMedia(imageUrl.value!, id: path);
                  }
                },
                value: imageList,
              ),
              const Ymargin(SpacingConstants.size20),
              UploadImage(
                loading: (widget.title.contains(assetText)
                    ? ref.watch(assetProvider).loading
                    : ref.watch(logProvider).loading),
                title: uploadFileLabel1,
                value: fileList,
                function: () async {
                  fileUrl.value = null;
                  fileUrl.value = await uploadFileToFirebase1();

                  if (fileUrl.value == null) return;
                  if (fileUrl.value != null && !fileList.value.contains(fileUrl.value)) {
                    fileList.value.add(fileUrl.value!);
                    fileList.notifyListeners();
                  }
                  if (widget.title.contains(assetText)) {
                    final id = await Pandora().getFromSharedPreferences("id");
                    await ref.read(assetProvider).addAssetFile(fileUrl.value!, id: id);
                  } else {
                    await ref.read(logProvider).addLogFile(fileUrl.value!, id: path);
                  }
                },
              ),
              const Spacer(),
              CustomButton(
                text: widget.title.contains(assetText) ? publishAsset : publishLog,
                loading: widget.title.contains(assetText)
                    ? ref.watch(assetProvider).loading
                    : ref.watch(logProvider).loading,
                onPressed: () async {
                  if (fileList.value.isEmpty || imageList.value.isEmpty) {
                    snackBarMsg(uploadWarningText);
                    return;
                  }

                  if (widget.title.contains(assetText)) {
                    final id = await Pandora().getFromSharedPreferences("id");
                    await ref.read(assetProvider).publishAsset(id).then((value) async {
                      if (value) {
                        final id = await Pandora().getFromSharedPreferences("orgId");
                        snackBarMsg(assetPublishedText, type: SnackBarType.success);
                        Navigator.pop(context);
                        Pandora().reRouteUser(context, "${ConfigRoute.farmAsset}/$id", "args");
                      }
                    });
                  } else {
                    await ref.read(logProvider).publishLog(path).then((value) async {
                      if (value) {
                        final id = await Pandora().getFromSharedPreferences("orgId");
                        snackBarMsg(logPublishedText, type: SnackBarType.success);
                        Navigator.pop(context);
                        Pandora().reRouteUser(context, "${ConfigRoute.farmLog}/$id", "args");
                      }
                    });
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
