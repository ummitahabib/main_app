import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class UploadProfilePicture with ChangeNotifier {
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
    //debugPrint(uploadPostImageVal.path);

    uploadPostImage != null ? _cropImage(context, uploadPostImageVal!.path) : debugPrint('Image upload error');

    notifyListeners();
  }

  Future<void> _cropImage(BuildContext context, CroppedFilePath) async {
    final ImageCropper cropper = ImageCropper();
    final CroppedFile? croppedCroppedFile = await cropper.cropImage(
      sourcePath: CroppedFilePath,
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
    if (croppedCroppedFile != null) {
      uploadPostImage = File(croppedCroppedFile.path);

      uploadPostImage != null ? showPostImage(context) : debugPrint('Error');
    }
  }

  Future<String> uploadSingleImage(BuildContext context) async {
    final Reference imageReference =
        FirebaseStorage.instance.ref().child('proCroppedFile/${uploadPostImage!.path}/${TimeOfDay.now()}');

    imagePostUploadTask = imageReference.putFile(File(uploadPostImage!.path));

    String url = '';
    await imagePostUploadTask!.whenComplete(() async {
      url = await imagePostUploadTask!.snapshot.ref.getDownloadURL();
    });

    if (url.isNotEmpty) {
      await Provider.of<FirebaseOperations>(context, listen: false).updateUserField(context, {'userimage': url});

      await Fluttertoast.showToast(
        msg: 'ProCroppedFile Picture Uploaded',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      await Fluttertoast.showToast(
        msg: 'ProCroppedFile Picture Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }
    return url;
  }

  Future selectProfileImageType() {
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
                            pickUploadPostImage(context, ImageSource.gallery);
                          },
                          child: Text(
                            'Gallery',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
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
                            pickUploadPostImage(context, ImageSource.camera);
                          },
                          child: Text(
                            'Camera',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
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

  Future showPostImage(BuildContext context) {
    return OneContext().showModalBottomSheet(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 150.0),
              child: Divider(
                thickness: 4.0,
                color: Colors.black,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Container(
                child: Image.file(
                  File(uploadPostImage!.path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 5,
                    child: MaterialButton(
                      child: Text(
                        'Reselect',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        selectProfileImageType();
                      },
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: MaterialButton(
                      color: AppColors.landingOrangeButton,
                      child: Text(
                        'Confirm Image',
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        OneContext().showProgressIndicator();
                        uploadSingleImage(context).whenComplete(() {
                          debugPrint("About to upload");
                          OneContext().hideProgressIndicator();
                          Navigator.of(context).pop('success');
                          debugPrint('Image uploaded!');
                        });
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
