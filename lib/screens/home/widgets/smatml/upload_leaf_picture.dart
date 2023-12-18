import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';

class UploadLeafPicture with ChangeNotifier {
  File? uploadPostImage, uploadPostVideo;

  File? get getUploadPostImage => uploadPostImage;

  File? get getUploadPostVideo => uploadPostVideo;
  String uploadPostImageUrl = '', uploadVideoUrl = '';

  String get getUploadPostImageUrl => uploadPostImageUrl;

  String get getUploadVideoUrl => uploadVideoUrl;
  final picker = ImagePicker();
  UploadTask? imagePostUploadTask, videoUploadTask;
  final Pandora _pandora = Pandora();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(
      source: source,
      imageQuality: PickedImageQuality,
    );
    uploadPostImageVal == null ? debugPrint('Select image') : uploadPostImage = File(uploadPostImageVal.path);

    uploadPostImage != null ? _cropImage(context, uploadPostImageVal!.path) : debugPrint('Image upload error');

    notifyListeners();
  }

  Future<void> _cropImage(BuildContext context, filePath) async {
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
          minimumAspectRatio: 1.0,
        )
      ],
    );
    if (croppedFile != null) {
      uploadPostImage = File(croppedFile.path);

      uploadPostImage != null ? postImage(context) : debugPrint('Error');
    }
  }

  postImage(BuildContext context) {
    _pandora.reRouteUser(context, '/plantAnalysis', uploadPostImage!.path);
  }
}
