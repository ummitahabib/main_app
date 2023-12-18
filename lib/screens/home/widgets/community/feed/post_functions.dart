import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  String imageTimePosted = emptyString;

  String get getImageTimePosted => imageTimePosted;
  TextEditingController updatedCaptionController = TextEditingController();
  final Pandora _pandora = Pandora();

  String showTimeAgo(dynamic timedata) {
    final Timestamp time = timedata;
    final DateTime dateTime = time.toDate();
    return timeago.format(dateTime);
  }

  Future showPostOptions(String postId) {
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
                              'SHOW_POST_OPTIONS_BUTTON_CLICKED',
                            );

                            Navigator.of(context).pop('Post Options');
                            OneContext().showModalBottomSheet(
                              builder: (context) {
                                return Column(
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
                                      height: 10,
                                    ),
                                    Center(
                                      child: Text(
                                        'Edit Caption',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
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
                                              textCapitalization: TextCapitalization.sentences,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Add New Caption...',
                                                hintStyle: GoogleFonts.poppins(
                                                  textStyle: TextStyle(
                                                    color: Colors.black.withOpacity(0.8),
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              controller: updatedCaptionController,
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
                                                _pandora.logAPPButtonClicksEvent(
                                                  'EDIT_POST_CAPTION_BUTTON_CLICKED',
                                                );
                                                OneContext().showProgressIndicator();
                                                Provider.of<FirebaseOperations>(
                                                  context,
                                                  listen: false,
                                                ).updateCaption(
                                                  postId,
                                                  {'caption': updatedCaptionController.text},
                                                ).whenComplete(() {
                                                  Navigator.of(context).pop('Caption');
                                                  OneContext().hideProgressIndicator();
                                                });
                                              },
                                              child: Container(
                                                child: Text(
                                                  'Post',
                                                  style: GoogleFonts.poppins(
                                                    textStyle: const TextStyle(
                                                      color: AppColors.landingOrangeButton,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Edit Caption',
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
                              'DELETE_POST_BUTTON_CLICKED',
                            );
                            OneContext().showDialog(
                              barrierDismissible: true,
                              builder: (_) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Delete This Post?',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Delete Post');
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        Provider.of<FirebaseOperations>(
                                          context,
                                          listen: false,
                                        )
                                            .deleteUserData(
                                          Provider.of<Authentication>(
                                            context,
                                            listen: false,
                                          ).getUserUid,
                                          postId,
                                          'posts',
                                        )
                                            .whenComplete(() {
                                          OneContext().popDialog('success');
                                          Navigator.of(context).pop('Delete Post');
                                        });
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Delete Post...',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.red,
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

  Future showNonOwnerPostOptions(String postId) {
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
                              'SHOW_POST_OPTIONS_BUTTON_CLICKED',
                            );

                            Navigator.of(context).pop('Post Options');
                            OneContext().showDialog(
                              // barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Report This Post?',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Report Post');
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Report Post');
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Text(
                            'Report Post',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.red,
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
                              'DELETE_POST_BUTTON_CLICKED',
                            );
                            OneContext().showDialog(
                              barrierDismissible: false,
                              builder: (_) {
                                return AlertDialog(
                                  backgroundColor: Colors.white,
                                  title: Text(
                                    'Report This User?',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        OneContext().popDialog('success');
                                        Navigator.of(context).pop('Report User');
                                        //TODO Report POST HERE
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Yes',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                          ),
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
                              textStyle: const TextStyle(
                                color: Colors.red,
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
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      child: Text(
                                        'No',
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
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
                                          textStyle: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 14.0,
                                          ),
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
                              textStyle: const TextStyle(
                                color: Colors.red,
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

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(subDocId).set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future removeLike(
    BuildContext context,
    String postId,
    String subDocId,
  ) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').doc(subDocId).delete();
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').doc(comment).set({
      'comment': comment,
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future showAwardsPresenter(BuildContext context, String postId) {
    return showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: AppColors.whiteColor,
                ),
              ),
              Container(
                width: 200.0,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.whiteColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Center(
                  child: Text(
                    'Award Socialites',
                    style: TextStyle(
                      color: AppColors.blueColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .doc(postId)
                      .collection('awards')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                _pandora.reRouteUser(
                                  context,
                                  '/altProfile',
                                  documentSnapshot['useruid'],
                                );
                              },
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  documentSnapshot['userimage'],
                                ),
                                radius: 15.0,
                                backgroundColor: AppColors.darkColor,
                              ),
                            ),
                            trailing: Provider.of<Authentication>(
                                      context,
                                      listen: false,
                                    ).getUserUid ==
                                    documentSnapshot['useruid']
                                ? const SizedBox(width: 0.0, height: 0.0)
                                : MaterialButton(
                                    onPressed: () {},
                                    color: AppColors.blueColor,
                                    child: const Text(
                                      'Follow',
                                      style: TextStyle(
                                        color: AppColors.whiteColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                            title: Text(
                              documentSnapshot['username'],
                              style: const TextStyle(
                                color: AppColors.blueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future showCommentsSheet(
    BuildContext context,
    DocumentSnapshot snapshot,
    String docId,
  ) {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return Column(
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
              height: 10,
            ),
            Center(
              child: Text(
                'Comments',
                style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.515,
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(docId)
                    .collection('comments')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    if (snapshot.data == null) {
                      return Container();
                    }
                    return ListView(
                      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      _pandora.logAPPButtonClicksEvent(
                                        'ALT_PROFILE_BUTTON_CLICKED',
                                      );

                                      _pandora.reRouteUser(
                                        context,
                                        '/altProfile',
                                        documentSnapshot['useruid'],
                                      );
                                    },
                                    child: CircleAvatar(
                                      backgroundColor: AppColors.darkColor,
                                      radius: 15.0,
                                      backgroundImage: NetworkImage(
                                        documentSnapshot['userimage'],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Container(
                                    child: Text(
                                      documentSnapshot['username'],
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: Text(
                                    documentSnapshot['comment'],
                                    style: GoogleFonts.poppins(
                                      textStyle: TextStyle(
                                        color: Colors.black.withOpacity(0.8),
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: AppColors.darkColor.withOpacity(0.2),
                            ),
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
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
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Add Comment...',
                        hintStyle: GoogleFonts.poppins(
                          textStyle: TextStyle(
                            color: Colors.black.withOpacity(0.8),
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                      controller: commentController,
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
                        debugPrint('Adding Comment...');
                        _pandora.logAPPButtonClicksEvent(
                          'POST_COMMENT_BUTTON_CLICKED',
                        );
                        addComment(
                          context,
                          snapshot['caption'],
                          commentController.text,
                        ).whenComplete(() {
                          commentController.clear();
                          notifyListeners();
                        });
                      },
                      child: Container(
                        child: Text(
                          'Post',
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: AppColors.landingOrangeButton,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future showRewards(BuildContext context, String postId) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.2,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.blueGreyColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150.0),
                child: Divider(
                  thickness: 4.0,
                  color: AppColors.whiteColor,
                ),
              ),
              Container(
                width: 100.0,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.whiteColor),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Center(
                  child: Text(
                    'Rewards',
                    style: TextStyle(
                      color: AppColors.blueColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('awards').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else {
                        if (snapshot.data == null) {
                          return Container();
                        }
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                            return GestureDetector(
                              onTap: () async {
                                debugPrint(documentSnapshot['image']);
                                await Provider.of<FirebaseOperations>(
                                  context,
                                  listen: false,
                                ).addAward(postId, {
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
                                  'award': documentSnapshot['image']
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: Image.network(
                                    documentSnapshot['image'],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
