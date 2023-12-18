import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/utils/constants.dart';

class LandingUtils with ChangeNotifier {
  final picker = ImagePicker();
  File? userAvatar;

  File? get getUserAvatar => userAvatar;
  String userAvatarUrl = '';

  String get getUserAvatarUrl => userAvatarUrl;

  Future pickUserAvatar(BuildContext context, ImageSource source) async {
    final pickedUserAvatar = await picker.pickImage(
      source: source,
      imageQuality: PickedImageQuality,
    );
    pickedUserAvatar == null ? debugPrint('Select Image') : userAvatar = File(pickedUserAvatar.path);
    debugPrint(userAvatar!.path);

    userAvatar != null
        ? Provider.of<FirebaseOperations>(context, listen: false).uploadUserAvatar(context)
        : debugPrint('Image upload Error');

    notifyListeners();
  }
}
