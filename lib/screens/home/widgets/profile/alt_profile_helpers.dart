import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/feed/post_functions.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class AltProfileHelpers with ChangeNotifier {
  final Pandora _pandora = Pandora();

  AppBar appBar(BuildContext context, String userUid) {
    return AppBar(
      elevation: 0.1,
      backgroundColor: AppColors.whiteColor,
      title: Text(
        'Profile',
        overflow: TextOverflow.fade,
        style: GoogleFonts.poppins(
          textStyle: const TextStyle(
            color: AppColors.fieldAgentText,
            fontSize: 16.0,
          ),
        ),
      ),
      leading: IconButton(
        icon: const Icon(
          Icons.keyboard_backspace_rounded,
          color: AppColors.fieldAgentText,
        ),
        onPressed: () {
          _pandora.logAPPButtonClicksEvent('ALT_PROFILE_BACK_BUTTON_CLICKED');
          Navigator.pop(context);
        },
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.more_vert_sharp,
            color: AppColors.greyColor,
          ),
          onPressed: () {
            Provider.of<FirebaseOperations>(context, listen: false).reportUser(userUid);
          },
        ),
      ],
    );
  }

  Widget headerProfile(
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot> snapshot,
    String userUid,
  ) {
    if (snapshot.data == null) {
      return const SizedBox();
    }
    return SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: (snapshot.data!['userimage'] != null)
                        ? Image.network(
                            snapshot.data!['userimage'],
                            height: 55,
                            width: 55,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                DEFAULT_IMAGE,
                                height: 55,
                                width: 55,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                        : Image.network(
                            DEFAULT_IMAGE,
                            height: 55,
                            width: 55,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  snapshot.data!['username'],
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  snapshot.data!['useremail'],
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _pandora.logAPPButtonClicksEvent(
                                'ALT_PROFILE_FOLLOWERS_CLICKED',
                              );
                              _pandora.reRouteUser(
                                context,
                                '/followers',
                                snapshot,
                              );
                            },
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data!['useruid'])
                                      .collection('followers')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: Container());
                                    } else {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  'Followers',
                                  style: GoogleFonts.poppins(
                                    textStyle: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 0.7,
                            height: 30,
                            color: Colors.black,
                          ),
                          GestureDetector(
                            onTap: () {
                              _pandora.logAPPButtonClicksEvent(
                                'ALT_PROFILE_FOLLOWING_CLICKED',
                              );
                              _pandora.reRouteUser(
                                context,
                                '/following',
                                snapshot,
                              );
                            },
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(snapshot.data!['useruid'])
                                      .collection('following')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(child: Container());
                                    } else {
                                      return Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: GoogleFonts.poppins(
                                          textStyle: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  'Following',
                                  style: GoogleFonts.poppins(
                                    textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 0.7,
                            height: 30,
                            color: Colors.black,
                          ),
                          Column(
                            children: [
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snapshot.data!['useruid'])
                                    .collection('posts')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Container();
                                  } else {
                                    return Text(
                                      '${snapshot.data!.size}',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                              Text(
                                'Posts',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (Provider.of<Authentication>(context, listen: false).getUserUid == snapshot.data!['useruid'])
            Container()
          else
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Expanded(
                child: MaterialButton(
                  color: AppColors.landingOrangeButton,
                  child: Text(
                    'Follow',
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                  onPressed: () {
                    _pandora.logAPPButtonClicksEvent('ALT_PROFILE_FOLLOW_CLICK');
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .followUser(
                            userUid,
                            Provider.of<Authentication>(context, listen: false).getUserUid,
                            {
                              'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
                              'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
                              'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                              'useremail': Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
                              'time': Timestamp.now()
                            },
                            Provider.of<Authentication>(context, listen: false).getUserUid,
                            userUid,
                            {
                              'username': snapshot.data!['username'],
                              'userimage': snapshot.data!['userimage'],
                              'useremail': snapshot.data!['useremail'],
                              'useruid': snapshot.data!['useruid'],
                              'time': Timestamp.now()
                            })
                        .whenComplete(() {
                      followedNotification(context, snapshot.data!['username']);
                    });
                  },
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget divider() {
    return const Center(
      child: SizedBox(
        height: 25.0,
        width: 350.0,
        child: Divider(
          color: AppColors.whiteColor,
        ),
      ),
    );
  }

  Widget footerProfile(
    BuildContext context,
    AsyncSnapshot<DocumentSnapshot> snapshot,
  ) {
    if (snapshot.data == null) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      height: MediaQuery.of(context).size.height * 0.53,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.data!['useruid'])
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return GestureDetector(
                  onTap: () {
                    _pandora.logAPPButtonClicksEvent(
                      'ALT_PROFILE_PREVIEW_POST_CLICK',
                    );
                    _pandora.reRouteUser(
                      context,
                      '/previewPost',
                      documentSnapshot,
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Image.network(documentSnapshot['postimage']),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }

  Future followedNotification(BuildContext context, String name) {
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
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width,
          child: Center(
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
                Text(
                  'Followed $name',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future checkFollowersSheet(BuildContext context, dynamic snapshot) {
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
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.blueGreyColor,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data['useruid'])
                .collection('followers')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListTile(
                        onTap: () {
                          if (documentSnapshot['useruid'] !=
                              Provider.of<Authentication>(
                                context,
                                listen: false,
                              ).getUserUid) {
                            _pandora.reRouteUser(
                              context,
                              '/altProfile',
                              documentSnapshot['useruid'],
                            );
                          }
                        },
                        trailing: documentSnapshot['useruid'] ==
                                Provider.of<Authentication>(
                                  context,
                                  listen: false,
                                ).getUserUid
                            ? const SizedBox(
                                width: 0.0,
                                height: 0.0,
                              )
                            : MaterialButton(
                                color: AppColors.blueColor,
                                child: const Text(
                                  'Unfollow',
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                onPressed: () {},
                              ),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.darkColor,
                          backgroundImage: NetworkImage(
                            documentSnapshot['userimage'],
                          ),
                        ),
                        title: Text(
                          documentSnapshot['username'],
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        subtitle: Text(
                          documentSnapshot['useremail'],
                          style: const TextStyle(
                            color: AppColors.yellowColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      );
                    }
                  }).toList(),
                );
              }
            },
          ),
        );
      },
    );
  }

  Future showPostDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
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
          height: MediaQuery.of(context).size.height * 0.6,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.darkColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: FittedBox(
                  child: Image.network(documentSnapshot['postimage']),
                ),
              ),
              Text(
                documentSnapshot['caption'],
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
              Container(
                child: Row(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        _pandora.reRouteUser(
                          context,
                          '/likes',
                          documentSnapshot['caption'],
                        );
                      },
                      onTap: () {
                        debugPrint('Adding like...');
                        Provider.of<PostFunctions>(context, listen: false).addLike(
                          context,
                          documentSnapshot['caption'],
                          Provider.of<Authentication>(
                            context,
                            listen: false,
                          ).getUserUid,
                        );
                      },
                      child: const Icon(
                        FontAwesomeIcons.heart,
                        color: AppColors.redColor,
                        size: 22.0,
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(documentSnapshot['caption'])
                          .collection('likes')
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
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              snapshot.data!.docs.length.toString(),
                              style: const TextStyle(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      width: 80.0,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<PostFunctions>(
                                context,
                                listen: false,
                              ).showCommentsSheet(
                                context,
                                documentSnapshot,
                                documentSnapshot['caption'],
                              );
                            },
                            child: const Icon(
                              FontAwesomeIcons.comment,
                              color: AppColors.blueColor,
                              size: 22.0,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('comments')
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
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 80.0,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Provider.of<PostFunctions>(
                                context,
                                listen: false,
                              ).showRewards(
                                context,
                                documentSnapshot['caption'],
                              );
                            },
                            child: const Icon(
                              FontAwesomeIcons.award,
                              color: AppColors.yellowColor,
                              size: 22.0,
                            ),
                          ),
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('posts')
                                .doc(documentSnapshot['caption'])
                                .collection('awards')
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
                                return Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    snapshot.data!.docs.length.toString(),
                                    style: const TextStyle(
                                      color: AppColors.whiteColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                );
                              }
                            },
                          )
                        ],
                      ),
                    )
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
