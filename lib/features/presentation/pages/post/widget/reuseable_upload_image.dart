import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/features/presentation/pages/post/widget/custome_image_picker.dart';

class ReuseableUploadPostWidget extends StatefulWidget {
  final UserEntity currentUser;
  final String uid;
  const ReuseableUploadPostWidget({
    Key? key,
    required this.currentUser,
    required this.uid,
  }) : super(key: key);

  @override
  State<ReuseableUploadPostWidget> createState() =>
      _ReuseableUploadPostWidgetState();
}

class _ReuseableUploadPostWidgetState extends State<ReuseableUploadPostWidget> {
  Uint8List? image;

  Future<void> selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        image = Uint8List.fromList(imageData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: GestureDetector(
          onTap: () {
            if (kIsWeb) {
              selectImage();
            } else {
              CustomImagePicker(
                title: emptyString,
                files: const [],
                folder: emptyString,
              );
            }
          },
        ),
      ),
    );
  }
}
