import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../../../network/crow/farm_manager_operations.dart';
import '../../../../../network/crow/models/request/farm_management/upload_asset_resource.dart';
import '../../../../../utils/styles.dart';

class UploadResourcePicture with ChangeNotifier {
  File? uploadPostImage, uploadPostVideo;

  File? get getUploadPostImage => uploadPostImage;

  File? get getUploadPostVideo => uploadPostVideo;
  String? uploadPostImageUrl, uploadVideoUrl;

  String? get getUploadPostImageUrl => uploadPostImageUrl;

  String? get getUploadVideoUrl => uploadVideoUrl;
  final picker = ImagePicker();
  UploadTask? imagePostUploadTask, videoUploadTask;
  final Pandora _pandora = Pandora();

  Future pickUploadPostImage(
    BuildContext context,
    ImageSource source,
    int assetId,
    int logId,
    bool isAsset,
    isImage,
  ) async {
    final uploadPostImageVal = await picker.pickImage(
      source: source,
      imageQuality: PickedImageQuality,
    );
    uploadPostImageVal == null ? debugPrint('Select image') : uploadPostImage = File(uploadPostImageVal.path);

    uploadPostImage != null
        ? _cropImage(
            context,
            uploadPostImageVal!.path,
            assetId,
            logId,
            isAsset,
            isImage,
          )
        : debugPrint('Image upload error');

    notifyListeners();
  }

  Future<void> _cropImage(
    BuildContext context,
    filePath,
    assetId,
    logId,
    isAsset,
    isImage,
  ) async {
    final ImageCropper cropper = ImageCropper();
    final CroppedFile? croppedFile = await cropper.cropImage(
      sourcePath: filePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Post',
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Post',
          // minimumAspectRatio: 1.0,
        )
      ],
    );
    if (croppedFile != null) {
      uploadPostImage = File(croppedFile.path);

      uploadPostImage != null ? postImage(context, assetId, logId, isAsset, isImage) : debugPrint('Error');
    }
  }

  Future selectResourceImageType(int assetId, int logId, bool isAsset, bool isImage) {
    return OneContext().showModalBottomSheet(
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 150.0,
                ),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextButton(
                          onPressed: () {
                            _pandora.logAPPButtonClicksEvent(
                              'UPLOAD_GALLERY_BUTTON_CLICKED',
                            );
                            Navigator.of(context).pop('Gallery');
                            pickUploadPostImage(
                              context,
                              ImageSource.gallery,
                              assetId,
                              logId,
                              isAsset,
                              isImage,
                            );
                          },
                          child: Text(
                            'Gallery',
                            style: GoogleFonts.poppins(
                              textStyle: Styles.normalTextMd(),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextButton(
                          onPressed: () {
                            _pandora.logAPPButtonClicksEvent(
                              'UPLOAD_CAMERA_BUTTON_CLICKED',
                            );
                            Navigator.of(context).pop('Camera');
                            pickUploadPostImage(
                              context,
                              ImageSource.camera,
                              assetId,
                              logId,
                              isAsset,
                              isImage,
                            );
                          },
                          child: Text(
                            'Camera',
                            style: GoogleFonts.poppins(
                              textStyle: Styles.normalTextMd(),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  postImage(
    BuildContext context,
    int assetId,
    int logId,
    bool isAsset,
    bool isImage,
  ) async {
    final url = await uploadSingleResource(context, isAsset, isImage);

    if (url != null) {
      debugPrint("File==> $url");
      if (isAsset && isImage) {
        await uploadAssetMedia(UploadAssetResource(itemId: assetId, url: url));
      } else if (isAsset && !isImage) {
        await uploadAssetFile(UploadAssetResource(itemId: assetId, url: url));
      } else if (!isAsset && isImage) {
        await uploadLogMedia(UploadAssetResource(itemId: logId, url: url));
      } else {
        await uploadLogFile(UploadAssetResource(itemId: logId, url: url));
      }

      notifyListeners();

      await Fluttertoast.showToast(
        msg: 'Resource Uploaded',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      await Fluttertoast.showToast(
        msg: 'Resource Upload Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<String?> uploadSingleResource(
    BuildContext context,
    bool isAsset,
    bool isImage,
  ) async {
    Reference imageReference;
    if (isImage) {
      imageReference = FirebaseStorage.instance.ref().child(
            '${isAsset ? 'assets' : 'logs'}/images/${uploadPostImage!.path}/${TimeOfDay.now()}',
          );
    } else {
      imageReference = FirebaseStorage.instance.ref().child(
            '${isAsset ? 'assets' : 'logs'}/files/${uploadPostImage!.path}/${TimeOfDay.now()}',
          );
    }

    imagePostUploadTask = imageReference.putFile(File(uploadPostImage!.path));

    String? url;
    await imagePostUploadTask!.whenComplete(() async {
      url = await imagePostUploadTask!.snapshot.ref.getDownloadURL();
    });

    return url;
  }
}
