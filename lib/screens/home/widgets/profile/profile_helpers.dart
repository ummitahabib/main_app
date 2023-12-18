import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/stories/stories_widget.dart';
import 'package:smat_crow/screens/home/widgets/profile/edit_profile_menu.dart';
import 'package:smat_crow/screens/home/widgets/profile/upload_profile_picture.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

import 'edit_profile_header.dart';

class ProfileHelpers with ChangeNotifier {
  final StoryWidgets storyWidgets = StoryWidgets();
  final Pandora _pandora = Pandora();

  Widget headerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.darkOrange,
                      width: 2.0,
                    ),
                  ),
                  child: InkWell(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50.0),
                      child: (snapshot.data['userimage'] != null)
                          ? Image.network(
                              snapshot.data['userimage'],
                              height: 55,
                              width: 55,
                              fit: BoxFit.cover,
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
                    onTap: () {
                      Provider.of<UploadProfilePicture>(
                        context,
                        listen: false,
                      ).selectProfileImageType();
                    },
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(
                                Provider.of<Authentication>(
                                  context,
                                  listen: false,
                                ).getUserUid,
                              )
                              .collection('posts')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            } else {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              return Text(
                                '${snapshot.data!.size}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'semibold',
                                ),
                              );
                            }
                          },
                        ),
                        const Text(
                          'Posts',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13.0,
                            fontFamily: 'regular',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pandora.logAPPButtonClicksEvent(
                          'PROFILE_FOLLOWERS_CLICKED',
                        );
                        _pandora.reRouteUser(context, '/followers', snapshot);
                      },
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(
                                  Provider.of<Authentication>(
                                    context,
                                    listen: false,
                                  ).getUserUid,
                                )
                                .collection('followers')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Container());
                              } else {
                                if (snapshot.data == null) {
                                  return Container();
                                }
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'semibold',
                                  ),
                                );
                              }
                            },
                          ),
                          const Text(
                            'Followers',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontFamily: 'regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        _pandora.logAPPButtonClicksEvent(
                          'PROFILE_FOLLOWING_CLICKED',
                        );
                        _pandora.reRouteUser(context, '/following', snapshot);
                      },
                      child: Column(
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(
                                  Provider.of<Authentication>(
                                    context,
                                    listen: false,
                                  ).getUserUid,
                                )
                                .collection('following')
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: Container());
                              } else {
                                if (snapshot.data == null) {
                                  return Container();
                                }
                                return Text(
                                  snapshot.data!.docs.length.toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'semibold',
                                  ),
                                );
                              }
                            },
                          ),
                          const Text(
                            'Following',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontFamily: 'regular',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            snapshot.data['username'],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontFamily: 'semibold',
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            snapshot.data['useremail'],
            style: const TextStyle(
              color: Colors.black,
              fontSize: 13.0,
              fontFamily: 'regular',
            ),
          ),
          const SizedBox(
            height: 21,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: OutlinedButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                EditProfileHeader(
                                  text:
                                      'Hi, ${"${userData!.firstName} ${userData!.lastName}"}',
                                  color: Colors.black,
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.closeButtonGrey,
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(
                                height: 1.0,
                              ),
                            ),
                            const EditProfileMenu(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text(
                'Edit Profile',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13.0,
                  fontFamily: 'semibold',
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14),
      height: MediaQuery.of(context).size.height * 0.53,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(
              Provider.of<Authentication>(context, listen: false).getUserUid,
            )
            .collection('posts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data == null) {
              return Container();
            }
            return GridView(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                return GestureDetector(
                  onTap: () {
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
                        fit: BoxFit.fill,
                        child: Image.network(
                          documentSnapshot['postimage'],
                          fit: BoxFit.fill,
                        ),
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

  Future checkFollowingSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.4,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data['useruid'])
                .collection('following')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                if (snapshot.data == null) {
                  return Container();
                }
                return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      return ListTile(
                        onTap: () {
                          _pandora.reRouteUser(
                            context,
                            '/altProfile',
                            documentSnapshot['useruid'],
                          );
                        },
                        trailing: MaterialButton(
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
}
