import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smat_crow/features/data/models/story/stories_model.dart';
import 'package:smat_crow/features/domain/entities/user/user_entity.dart';
import 'package:smat_crow/utils2/constants.dart';

enum StoryProvidersStatus {
  initial,
  loading,
  loaded,
  failure,
}

class StoryProviders extends ChangeNotifier {
  final String? userUid;
  StoryProviders({
    this.firebaseFirestore,
    this.userUid,
  });

  List<Story> _stories = [];
  List<Story> get stories => _stories;

  final String _error = emptyString;
  String get error => _error;

  StoryProvidersStatus _status = StoryProvidersStatus.initial;
  StoryProvidersStatus get status => _status;
  UserEntity? _user;
  UserEntity? get user => _user;

  bool isImgAvailable = false;
  final ImagePicker picker = ImagePicker();
  Uint8List? selectedImagePath;
  Uint8List? selectedImageSize;
  final FirebaseFirestore? firebaseFirestore;
  bool isLoading = false;
  final _userDatBaseReference = FirebaseFirestore.instance.collection("story");

  set status(StoryProvidersStatus newStatus) {
    _status = newStatus;
    notifyListeners();
  }

  Future<String?> getImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImagePath = await pickedFile.readAsBytes();

      final base64Image = selectedImagePath!.buffer.asUint8List();
      final base64String = base64Encode(base64Image);

      final imageUrls = base64String;

      selectedImageSize = Uint8List.fromList(selectedImagePath!);
      isImgAvailable = true;

      return imageUrls;
    } else {
      isImgAvailable = false;
    }
    return null;
  }

  Future<void> handleCreateStory(String username) async {
    final imageSelected = await getImage();

    if (imageSelected != null) {
      createStory(userName: username, userUrl: imageSelected);
    }
  }

  Future<void> init() async {
    final storiesJson = await loadStoriesFromDatabase();
    _stories = Story.fromJsonList(storiesJson);
    notifyListeners();
  }

  Future<String> loadStoriesFromDatabase() async {
    final querySnapshot = await _userDatBaseReference.get();
    final stories = querySnapshot.docs.map((doc) => Story.fromDocumentSnapshot(doc)).toList();

    return Story.toJsonList(stories);
  }

  Future<String?> uploadImage() async {
    final FirebaseStorage storage = FirebaseStorage.instance;

    const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final Random rnd = Random();
    final String randomStr = String.fromCharCodes(
      Iterable.generate(
        8,
        (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
      ),
    );

    try {
      await storage.ref('uploads/story/$randomStr').putData(selectedImagePath!);
    } on FirebaseException {
      return null;
    }

    final String downloadURL = await storage.ref('uploads/story/$randomStr').getDownloadURL();

    return downloadURL;
  }

  void createStory({
    required String userName,
    required String userUrl,
    String? image,
  }) {
    isLoading = true;
    uploadImage().then((url) {
      if (url != null) {
        saveDataToDb(url: url, userName: userName, userUrl: userUrl).then((value) {
          isLoading = false;
        });
      } else {
        isLoading = false;
      }
    });
  }

  Future<void> saveDataToDb({
    required String url,
    required String userName,
    required String userUrl,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    await _userDatBaseReference.doc(user!.uid).get().then((value) async {
      if (value.exists) {
        await _userDatBaseReference.doc(user.uid).update({
          'storyUrl': FieldValue.arrayUnion(
            [url],
          ),
        });
      } else {
        await _userDatBaseReference.doc(user.uid).set({
          'userUid': user.uid,
          'userName': userName,
          'userUrl': userUrl,
          'storyUrl': FieldValue.arrayUnion([url]),
        });
      }
    });
  }

  Future<void> deleteStory(String storyUrl) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await _userDatBaseReference.doc(user.uid).update({
        'storyUrl': FieldValue.arrayRemove([storyUrl]),
      });
      await init();
    }
  }
}
