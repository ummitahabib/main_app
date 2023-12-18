import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/feed/video.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:video_player/video_player.dart';

class UploadPost with ChangeNotifier {
  TextEditingController captionController = TextEditingController();
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
    debugPrint(uploadPostImageVal!.path);

    // uploadPostImage != null
    //     ? showPostImage(context)
    //     : debugPrint('Image upload error');

    uploadPostImage != null ? _cropImage(context, uploadPostImageVal.path) : debugPrint('Image upload error');

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
      uploadPostImage != null ? showPostImage(context) : debugPrint('Error');
    }
  }

  Future pickVideo(BuildContext context) async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      uploadPostVideo = File(pickedVideo.path);
      debugPrint(uploadPostVideo!.path);
      notifyListeners();
    }
  }

  Future uploadPostImageToFirebase() async {
    final Reference imageReference =
        FirebaseStorage.instance.ref().child('posts/${uploadPostImage!.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage!);
    await imagePostUploadTask!.whenComplete(() {
      debugPrint('Post image uploaded to storage');
    });
    await imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
      debugPrint(uploadPostImageUrl);
    });
    notifyListeners();
  }

  Future uploadVideoToFirebase() async {
    final Reference videoReference =
        FirebaseStorage.instance.ref().child('videos/${uploadPostVideo!.path}/${Timestamp.now()}');
    videoUploadTask = videoReference.putFile(uploadPostVideo!);
    await videoReference.getDownloadURL().then((url) {
      uploadVideoUrl = url;
      debugPrint(getUploadVideoUrl);
    });
    notifyListeners();
  }

  Future selectPostType() {
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
                              'UPLOAD_PHOTO_BUTTON_CLICKED',
                            );
                            Navigator.of(context).pop('Photo');
                            selectPostImageType();
                          },
                          child: Text(
                            'Photo',
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
                            pickVideo(context).whenComplete(() {
                              _pandora.logAPPButtonClicksEvent(
                                'UPLOAD_VIDEO_BUTTON_CLICKED',
                              );
                              Navigator.of(context).pop('Video');
                              previewVideo();
                            });
                          },
                          child: Text(
                            'Video',
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

  Future previewVideo() {
    return OneContext().showModalBottomSheet(
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  child: Video(
                    loop: true,
                    videoPlayerController: VideoPlayerController.file(getUploadPostVideo!),
                  ),
                ),
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
                              'RESELECT_VIDEO_BUTTON_CLICKED',
                            );

                            Provider.of<UploadPost>(context, listen: false).pickVideo(context).whenComplete(
                                  () => Navigator.of(context).pop('Reselect'),
                                );
                          },
                          child: Text(
                            'Reselect',
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
                              'UPLOAD_PHOTO_BUTTON_CLICKED',
                            );
                            Provider.of<UploadPost>(context, listen: false).uploadVideoToFirebase().whenComplete(() {
                              Navigator.of(context).pop('Upload Video');
                            });
                          },
                          child: Text(
                            'Upload Video',
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

  Future showEditVideoSheet(BuildContext context) {
    return OneContext().showModalBottomSheet(
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.darkColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: AppColors.whiteColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future selectPostImageType() {
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
                  uploadPostImage!,
                  fit: BoxFit.cover,
                  height: 300,
                  width: MediaQuery.of(context).size.width,
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
                        selectPostImageType();
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
                        uploadPostImageToFirebase().whenComplete(() {
                          Navigator.of(context).pop('success');
                          OneContext().hideProgressIndicator();
                          editPostSheet();
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

  Future editPostSheet() {
    return OneContext().showModalBottomSheet(
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.black,
                ),
              ),
              Container(
                child: Image.file(
                  uploadPostImage!,
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 10,
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 9,
                      child: TextField(
                        textCapitalization: TextCapitalization.words,
                        inputFormatters: [LengthLimitingTextInputFormatter(100)],
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add A Caption...',
                          hintStyle: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                        controller: captionController,
                        style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          OneContext().showProgressIndicator();
                          Provider.of<FirebaseOperations>(context, listen: false)
                              .uploadPostData(captionController.text, {
                            'postimage': getUploadPostImageUrl,
                            'caption': captionController.text,
                            'username': Provider.of<FirebaseOperations>(
                              context,
                              listen: false,
                            ).getInitUserName,
                            'userimage': Provider.of<FirebaseOperations>(
                              context,
                              listen: false,
                            ).getInitUserImage,
                            'useruid': Provider.of<Authentication>(
                              context,
                              listen: false,
                            ).getUserUid,
                            'time': Timestamp.now(),
                            'useremail': Provider.of<FirebaseOperations>(
                              context,
                              listen: false,
                            ).getInitUserEmail,
                          }).whenComplete(() async {
                            OneContext().hideProgressIndicator();
                            return FirebaseFirestore.instance
                                .collection('users')
                                .doc(
                                  Provider.of<Authentication>(
                                    context,
                                    listen: false,
                                  ).getUserUid,
                                )
                                .collection('posts')
                                .doc(captionController.text)
                                .set({
                              'postimage': getUploadPostImageUrl,
                              'caption': captionController.text,
                              'username': Provider.of<FirebaseOperations>(
                                context,
                                listen: false,
                              ).getInitUserName,
                              'userimage': Provider.of<FirebaseOperations>(
                                context,
                                listen: false,
                              ).getInitUserImage,
                              'useruid': Provider.of<Authentication>(
                                context,
                                listen: false,
                              ).getUserUid,
                              'time': Timestamp.now(),
                              'useremail': Provider.of<FirebaseOperations>(
                                context,
                                listen: false,
                              ).getInitUserEmail
                            });
                          }).whenComplete(() {
                            Navigator.of(context).pop('success');
                          });
                        },
                        child: Container(
                          child: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
