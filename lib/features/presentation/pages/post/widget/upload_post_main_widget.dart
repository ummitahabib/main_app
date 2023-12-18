import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/upload_image_to_storage_usecase.dart';
import 'package:smat_crow/features/presentation/provider/get_single_user.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/AppHelper.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';
import 'package:uuid/uuid.dart';

class UploadPostMainWidget extends StatefulWidget {
  const UploadPostMainWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<UploadPostMainWidget> createState() => _UploadPostMainWidgetState();
}

class _UploadPostMainWidgetState extends State<UploadPostMainWidget> {
  Uint8List? _image;
  final TextEditingController _descriptionController = TextEditingController();
  bool _uploading = false;
  late GetSingleUserProvider _userProvider;
  ApplicationHelpers appHelper = ApplicationHelpers();
  late String _uid;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future selectImage() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles();

      if (pickedFile != null) {
        final bytes = pickedFile.files.first.bytes;
        setState(() {
          _image = Uint8List.fromList(bytes!);
        });
      } else {}
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();

    Pandora().getFromSharedPreferences(Const.uid).then((value) async {
      log(value);

      setState(() {
        _uid = value;
      });

      await Provider.of<GetSingleUserProvider>(context, listen: false)
          .getSingleUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    _userProvider = Provider.of<GetSingleUserProvider>(context, listen: false);
    return _image == null
        ? Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(SpacingConstants.size12),
              decoration: DecorationBox.uploadImageBoxDecoration(),
              child: Center(
                child: GestureDetector(
                  onTap: selectImage,
                  child: SizedBox(
                    width: SpacingConstants.size150,
                    height: SpacingConstants.size150,
                    child: Center(
                      child: Column(
                        children: [
                          const Icon(
                            EvaIcons.imageOutline,
                            color: AppColors.SmatCrowPrimary500,
                            size: SpacingConstants.size40,
                          ),
                          Text(
                            uploadPhotoText,
                            style: Styles.modelTextStyle,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            backgroundColor: AppColors.SmatCrowDefaultWhite,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(
                  left: SpacingConstants.size6,
                  right: SpacingConstants.size6,
                  top: SpacingConstants.size16,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _image = null),
                      child: const Icon(
                        EvaIcons.arrowBack,
                        color: AppColors.SmatCrowNeuBlue500,
                        size: SpacingConstants.size24,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      newPost,
                      style: Styles.smatCrowBodyRegular(
                        color: AppColors.SmatCrowNeuBlue800,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        appHelper
                            .trackButtonAndDeviceEvent('SUBMIT_BUTTON_CLICKED');
                        _submitPost(context);
                      },
                      child: Text(
                        newPost,
                        style: Styles.smatCrowMediumCaption(
                          AppColors.SmatCrowPrimary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(SpacingConstants.size25),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: SpacingConstants.size40,
                        height: SpacingConstants.size40,
                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(SpacingConstants.size40),
                          child: profileWidget(
                            imageUrl: "${_userProvider.user!.profileUrl}",
                          ),
                        ),
                      ),
                      customSizedBoxWidth(SpacingConstants.size10),
                      Expanded(
                        child: CustomTextField(
                          width: SpacingConstants.size80,
                          type: TextFieldType.Default,
                          hintText: writeYourCaptionText,
                          textEditingController: _descriptionController,
                          text: emptyString,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: SpacingConstants.size317,
                  height: SpacingConstants.size186,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(SpacingConstants.size15),
                  ),
                  child: profileWidget(image: _image),
                ),
                customSizedBoxHeight(SpacingConstants.size10),
                if (_uploading == true)
                  const LoadingStateWidget()
                else
                  const SizedBox(
                    width: SpacingConstants.size0,
                    height: SpacingConstants.size0,
                  )
              ],
            ),
          );
  }

  Future<void> _submitPost(BuildContext context) async {
    setState(() {
      _uploading = true;
    });

    try {
      final imageUrl = await di
          .locator<UploadImageToStorageUseCase>()
          .call(_image!, true, post);

      await _createSubmitPost(image: imageUrl);
      Navigator.pop(context);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(errorUploadImage),
            content: const Text(errorUploadingImage),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(ok),
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _uploading = false;
      });
    }
  }

  Future<void> _createSubmitPost({required String image}) async {
    try {
      final postEntity = PostEntity(
        description: _descriptionController.text,
        createAt: Timestamp.now(),
        creatorUid: _uid,
        likes: const [],
        postId: const Uuid().v1(),
        postImageUrl: image,
        totalComments: SpacingConstants.int0,
        totalLikes: SpacingConstants.int0,
        email: _userProvider.user!.email,
        userProfileUrl: _userProvider.user!.profileUrl,
      );

      final postDocumentReference = await FirebaseFirestore.instance
          .collection(post)
          .add(postEntity.toMap());

      await postDocumentReference.update({'postId': postDocumentReference.id});

      _clear();
    } catch (e) {}
  }

  void _clear() {
    setState(() {
      _image = null;
    });
  }
}
