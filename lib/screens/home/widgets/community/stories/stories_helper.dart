import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/screens/home/widgets/community/stories/stories_widget.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class StoriesHelper with ChangeNotifier {
  UploadTask? imageUploadTask;
  final picker = ImagePicker();
  File? storyImage;

  File? get getStoryImage => storyImage;
  final StoryWidgets storyWidgets = StoryWidgets();
  String storyImageUrl = '', storyHighlightIcon = '', storyTime = '', lastSeenTime = '';

  String get getStoryImageUrl => storyImageUrl;

  String get getStoryHighlightIcon => storyHighlightIcon;

  String get getStoryTime => storyTime;

  String get getLastSeenTime => lastSeenTime;

  Future selectStoryImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.pickImage(
      source: source,
      imageQuality: PickedImageQuality,
    );
    pickedStoryImage == null ? debugPrint('Error') : storyImage = File(pickedStoryImage.path);
    storyImage != null ? storyWidgets.previewStoryImage(context, storyImage!) : debugPrint('Error');
    notifyListeners();
  }

  Future<String?> uploadStoryImage(BuildContext context) async {
    final Reference imageReference =
        FirebaseStorage.instance.ref().child('stories/${getStoryImage!.path}/${Timestamp.now()}');

    imageUploadTask = imageReference.putFile(getStoryImage!);

    String? url;
    await imageUploadTask!.whenComplete(() async {
      url = await imageUploadTask!.snapshot.ref.getDownloadURL();
    });

    if (url != null) {
      await FirebaseFirestore.instance
          .collection('stories')
          .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
          .set({
        'image': url,
        'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
        'time': Timestamp.now(),
        'useruid': Provider.of<Authentication>(context, listen: false).getUserUid
      });

      await Fluttertoast.showToast(
        msg: 'Story Uploaded',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    } else {
      await Fluttertoast.showToast(
        msg: 'Story Upload Failed',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
      );
    }

    return url;
  }

  Future convertHighlightedIcon(String firestoreImageUrl) async {
    storyHighlightIcon = firestoreImageUrl;
    debugPrint(storyHighlightIcon);
    notifyListeners();
  }

/*
  Future addStoryToNewAlbum(BuildContext context, String userUid,
      String highlightName, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightName)
        .set({
      'title': highlightName,
      'cover': storyHighlightIcon
    }).whenComplete(() {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(userUid)
          .collection('highlights')
          .doc(highlightName)
          .collection('stories')
          .add({
        'image': storyImage,
        'username': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false)
            .getInitUserImage
      });
    });
  }

  Future addStoryToExistingAlbum(BuildContext context, String userUid,
      String highlightColId, String storyImage) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('highlights')
        .doc(highlightColId)
        .collection('stories')
        .add({
      'image': storyImage,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage
    });
  }
*/

  storyTimePosted(dynamic timeData) {
    final Timestamp timestamp = timeData;
    final DateTime dateTime = timestamp.toDate();
    storyTime = timeago.format(dateTime);
    lastSeenTime = timeago.format(dateTime);
    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });
  }

  Future addSeenStamp(
    BuildContext context,
    String storyId,
    String personId,
    DocumentSnapshot documentSnapshot,
  ) async {
    if (documentSnapshot['useruid'] != Provider.of<Authentication>(context, listen: false).getUserUid) {
      return FirebaseFirestore.instance.collection('stories').doc(storyId).collection('seen').doc(personId).set({
        'time': Timestamp.now(),
        'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
        'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
        'useruid': Provider.of<Authentication>(context, listen: false).getUserUid
      });
    }
  }
}
