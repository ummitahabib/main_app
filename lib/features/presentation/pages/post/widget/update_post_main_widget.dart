import 'dart:typed_data';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/posts/post_entity.dart';
import 'package:smat_crow/features/domain/usecases/firebase_usecases/upload_image_to_storage_usecase.dart';
import 'package:smat_crow/features/presentation/provider/post/post_state.dart';
import 'package:smat_crow/features/presentation/widgets/custom_text_field.dart';
import 'package:smat_crow/features/presentation/widgets/loading_state_widget.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/profile_widget.dart';
import 'package:smat_crow/utils2/service_locator.dart' as di;
import 'package:smat_crow/utils2/spacing_constants.dart';

class UpdatePostMainWidget extends StatefulWidget {
  final PostEntity post;
  const UpdatePostMainWidget({Key? key, required this.post}) : super(key: key);

  @override
  State<UpdatePostMainWidget> createState() => _UpdatePostMainWidgetState();
}

class _UpdatePostMainWidgetState extends State<UpdatePostMainWidget> {
  TextEditingController? _descriptionController;

  @override
  void initState() {
    _descriptionController =
        TextEditingController(text: widget.post.description);
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController!.dispose();
    super.dispose();
  }

  Uint8List? _image;
  bool? _uploading = false;
  Future selectImage() async {
    try {
      final pickedFile = await FilePicker.platform.pickFiles();

      setState(() {
        if (pickedFile != null) {
          _image = Uint8List(SpacingConstants.int0);
        } else {}
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      appBar: AppBar(
        backgroundColor: AppColors.SmatCrowDefaultWhite,
        title: const Text(editPostText),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: SpacingConstants.size10),
            child: GestureDetector(
              onTap: _updatePost,
              child: const Icon(
                EvaIcons.doneAllOutline,
                color: AppColors.SmatCrowPrimary500,
                size: SpacingConstants.size28,
              ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingConstants.size10,
          vertical: SpacingConstants.size10,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: SpacingConstants.size100,
                height: SpacingConstants.size100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(SpacingConstants.size50),
                  child: profileWidget(imageUrl: widget.post.userProfileUrl),
                ),
              ),
              customSizedBoxHeight(SpacingConstants.size10),
              Text(
                "${widget.post.email}",
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              customSizedBoxHeight(SpacingConstants.size10),
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: SpacingConstants.size200,
                    child: profileWidget(
                      imageUrl: widget.post.postImageUrl,
                      image: _image,
                    ),
                  ),
                  Positioned(
                    top: SpacingConstants.size15,
                    right: SpacingConstants.size15,
                    child: GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        width: SpacingConstants.size30,
                        height: SpacingConstants.size30,
                        decoration: BoxDecoration(
                          color: AppColors.SmatCrowDefaultWhite,
                          borderRadius:
                              BorderRadius.circular(SpacingConstants.size15),
                        ),
                        child: const Icon(
                          EvaIcons.editOutline,
                          color: AppColors.SmatCrowPrimary500,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              customSizedBoxHeight(SpacingConstants.size10),
              CustomTextField(
                hintText: writeYourCaptionText,
                type: TextFieldType.Default,
                textEditingController: _descriptionController,
              ),
              customSizedBoxHeight(SpacingConstants.size10),
              if (_uploading == true)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      updateText,
                      style: TextStyle(color: AppColors.SmatCrowDefaultBlack),
                    ),
                    customSizedBoxWidth(SpacingConstants.size10),
                    const LoadingStateWidget()
                  ],
                )
              else
                const SizedBox(
                  width: SpacingConstants.size0,
                  height: SpacingConstants.size0,
                )
            ],
          ),
        ),
      ),
    );
  }

  _updatePost() {
    setState(() {
      _uploading = true;
    });
    if (_image == null) {
      _submitUpdatePost(image: widget.post.postImageUrl!);
    } else {
      di
          .locator<UploadImageToStorageUseCase>()
          .call(_image!, true, post)
          .then((imageUrl) {
        _submitUpdatePost(image: imageUrl);
      });
    }
  }

  _submitUpdatePost({required String image}) {
    Provider.of<PostProvider>(context, listen: false)
        .updatePost(
          post: PostEntity(
            creatorUid: widget.post.creatorUid,
            postId: widget.post.postId,
            postImageUrl: image,
            description: _descriptionController!.text,
          ),
        )
        .then((value) => _clear());
  }

  _clear() {
    setState(() {
      _descriptionController!.clear();
      Navigator.pop(context);
      _uploading = false;
    });
  }
}
