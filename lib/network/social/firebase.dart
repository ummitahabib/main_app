import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/landing_utils.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../utils/styles.dart';
import 'authentication.dart';

class FirebaseOperations with ChangeNotifier {
  final Pandora _pandora = Pandora();

  UploadTask? imageUploadTask;
  String initUserName = '', initUserEmail = "", initUserImage = "";
  String userUId = "";

  String get getInitUserName => initUserName;

  String get getInitUserEmail => initUserEmail;

  String get getInitUserImage => initUserImage;

  Future uploadUserAvatar(BuildContext context) async {
    final Reference imageReference = FirebaseStorage.instance.ref().child(
          'userProfileAvatar/${Provider.of<LandingUtils>(context, listen: false).getUserAvatar!.path}/${TimeOfDay.now()}',
        );
    imageUploadTask = imageReference.putFile(
      Provider.of<LandingUtils>(context, listen: false).getUserAvatar!,
    );
    await imageUploadTask!.whenComplete(() {
      debugPrint('Image Uploaded');
    });

    await imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvatarUrl = url;
      debugPrint(
        'the user profile avatar url => ${Provider.of<LandingUtils>(context, listen: false).getUserAvatarUrl}',
      );

      notifyListeners();
    });
  }

  Future createUserCollection(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      debugPrint('Fetching User Data');
      try {
        initUserName = doc.data()!['username'];
        initUserEmail = doc.data()!['useremail'];
        initUserImage = doc.data()!['userimage'];
        debugPrint(initUserName);
        debugPrint(initUserEmail);
        debugPrint(initUserImage);
      } catch (e) {
        Provider.of<FirebaseOperations>(context, listen: false).createUserCollection(
          context,
          {'useruid': userUId, 'useremail': Email, 'username': 'Anonymous', 'userimage': ''},
        ).whenComplete(
          () => Provider.of<FirebaseOperations>(
            context,
            listen: false,
          ).updateUserField(
            context,
            {'username': Pandora.getEmailUserName(Email)},
          ),
        );
        initUserData(context);
      }
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(
    String userUid,
    String postId,
    dynamic collection,
  ) async {
    await FirebaseFirestore.instance.collection(collection).doc(postId).delete();

    return FirebaseFirestore.instance.collection('users').doc(userUid).collection('posts').doc(postId).delete();
  }

  Future deleteUserPost(String userUid, postId) async {
    return FirebaseFirestore.instance.collection('users').doc(userUid).collection('posts').doc(postId).delete();
  }

  Future addAward(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('post').doc(postId).collection('awards').add(data);
  }

  Future updateCaption(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).update(data);
  }

  Future updateUserField(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .update(data);
  }

  Future followUser(
    String followingUid,
    String followingDocId,
    dynamic followingData,
    String followerUid,
    String followerDocId,
    dynamic followerData,
  ) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followerUid)
        .collection('following')
        .doc(followerDocId)
        .set(followerData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followingUid)
          .collection('followers')
          .doc(followingDocId)
          .set(followingData);
    });
  }

  Future submitChatroomData(String chatRoomName, dynamic chatRoomData) async {
    return FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomName).set(chatRoomData);
  }

  Future reportUser(String userId) {
    return OneContext().showModalBottomSheet(
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
                              'DELETE_POST_BUTTON_CLICKED',
                            );
                            OneContext().showDialog(
                              // barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Report This User?',
                                    style: GoogleFonts.poppins(
                                      textStyle: Styles.defaultStyleBlackMx(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style: GoogleFonts.poppins(
                                          textStyle: Styles.defaultStyleBlackMd(),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Report User');
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style: GoogleFonts.poppins(
                                          textStyle: Styles.textStyleRed14(),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Report User');
                                        //TODO Report User HERE
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Report User',
                            style: GoogleFonts.poppins(
                              textStyle: Styles.textStyleRed14(),
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
                              'DELETE_POST_BUTTON_CLICKED',
                            );
                            OneContext().showDialog(
                              // barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Block This User?',
                                    style: GoogleFonts.poppins(
                                      textStyle: Styles.defaultStyleBlackMx(),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style: GoogleFonts.poppins(
                                          textStyle: Styles.defaultStyleBlackMd(),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Block User');
                                        //TODO Report POST HERE
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style: GoogleFonts.poppins(
                                          textStyle: Styles.textStyleRed14(),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Block User');
                                        //TODO Report User HERE
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Block User',
                            style: GoogleFonts.poppins(
                              textStyle: Styles.textStyleRed14(),
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
}
