import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/fieldagents/widgets/promos_carousel.dart';
import 'package:smat_crow/screens/home/widgets/community/feed/post_functions.dart';
import 'package:smat_crow/screens/home/widgets/community/feed/upload_post.dart';
import 'package:smat_crow/screens/home/widgets/community/stories/stories_widget.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class FeedHelpers with ChangeNotifier {
  final Pandora _pandora = Pandora();

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0.1,
      backgroundColor: AppColors.whiteColor,
      leadingWidth: 0.0,
      leading: Container(),
      title: const Text(
        'Highlights',
        overflow: TextOverflow.fade,
        style: TextStyle(
          color: Colors.black,
          fontSize: 23.0,
          fontFamily: 'semibold',
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          icon: SvgPicture.asset(
            'assets/nsvgs/timeline/new_post.svg',
            width: 20.0,
            height: 20.0,
          ),
          onPressed: () {
            _pandora.logAPPButtonClicksEvent('ADD_FEED_ITEM_CLICKED');
            Provider.of<UploadPost>(context, listen: false).selectPostImageType();
          },
        )
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    final StoryWidgets storyWidgets = StoryWidgets();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(
                                Provider.of<Authentication>(
                                  context,
                                  listen: false,
                                ).getUserUid,
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Center(
                                child: Container(),
                              );
                            } else {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              return InkWell(
                                onTap: () {
                                  _pandora.logAPPButtonClicksEvent(
                                    'ADD_STORY_ITEM_CLICKED',
                                  );
                                  storyWidgets.addStory(context);
                                },
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: AppColors.darkOrange,
                                              width: 2.0,
                                            ),
                                          ),
                                          height: 50,
                                          width: 50,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(50.0),
                                            child: Image.network(
                                              snapshot.data!['userimage'],
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) {
                                                return Image.network(
                                                  DEFAULT_IMAGE,
                                                  height: 50,
                                                  width: 50,
                                                  fit: BoxFit.cover,
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          left: 34,
                                          top: 34,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: AppColors.darkOrange,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black.withOpacity(0.6),
                                                  blurRadius: 1.0,
                                                  offset: const Offset(
                                                    1.0,
                                                    1.0,
                                                  ), // shadow direction: bottom right
                                                )
                                              ],
                                            ),
                                            width: 20,
                                            height: 20,
                                            child: const Center(
                                              child: Icon(
                                                Icons.add_circle_outline_rounded,
                                                size: 17,
                                                color: AppColors.whiteColor,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Text(
                                        'Your Story',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11.0,
                                          fontFamily: 'regular',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: SizedBox(
                            height: 80,
                            child: StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance.collection('stories').snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Container();
                                } else {
                                  if (snapshot.data == null) {
                                    return Container();
                                  }
                                  return ListView(
                                    scrollDirection: Axis.horizontal,
                                    children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                                      return GestureDetector(
                                        onTap: () {
                                          _pandora.logAPPButtonClicksEvent(
                                            'VIEW_STORIES_ITEM_CLICKED',
                                          );
                                          _pandora.reRouteUser(
                                            context,
                                            '/stories',
                                            documentSnapshot,
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 2.0,
                                                right: 2.0,
                                                top: 2.5,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: AppColors.darkOrange,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(
                                                    50.0,
                                                  ),
                                                  child: (documentSnapshot['userimage'] != null)
                                                      ? Image.network(
                                                          documentSnapshot['userimage'],
                                                          height: 50,
                                                          width: 50,
                                                          fit: BoxFit.cover,
                                                          errorBuilder: (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Image.network(
                                                              DEFAULT_IMAGE,
                                                              height: 50,
                                                              width: 50,
                                                              fit: BoxFit.cover,
                                                            );
                                                          },
                                                        )
                                                      : Image.network(
                                                          DEFAULT_IMAGE,
                                                          height: 50,
                                                          width: 50,
                                                          fit: BoxFit.cover,
                                                        ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(6),
                                              child: Text(
                                                '${documentSnapshot['username']}',
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 11.0,
                                                  fontFamily: 'regular',
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            )
                                          ],
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
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Divider(
                      color: AppColors.dividerColorDa,
                      height: 0.5,
                    ),
                  ),
                  const PromosCarousel(),
                  StreamBuilder<QuerySnapshot>(
                    stream:
                        FirebaseFirestore.instance.collection('posts').orderBy('time', descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: SizedBox(
                            height: 500.0,
                            width: 400.0,
                            child: Lottie.asset('assets/animations/loading.json'),
                          ),
                        );
                      } else {
                        return loadPosts(context, snapshot);
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget loadPosts(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> snapshot,
  ) {
    if (snapshot.data == null) {
      return Container();
    }
    return Column(
      children: [
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            return Card(
              elevation: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8, left: 8),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            _pandora.logAPPButtonClicksEvent(
                              'USER_ALTERNATE_PROFILE_BUTTON_CLICKED',
                            );
                            if (documentSnapshot['useruid'] !=
                                Provider.of<Authentication>(
                                  context,
                                  listen: false,
                                ).getUserUid) {
                              _pandora.reRouteUser(
                                context,
                                '/alternateProfile',
                                documentSnapshot['useruid'],
                              );
                            }
                          },
                          child: Container(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35.0),
                              child: Image.network(
                                documentSnapshot['userimage'],
                                height: 35,
                                width: 35,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    DEFAULT_IMAGE,
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            documentSnapshot['username'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12.0,
                              fontFamily: 'semibold',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.46,
                      width: MediaQuery.of(context).size.width,
                      child: GestureDetector(
                        child: Image.network(
                          documentSnapshot['postimage'],
                          fit: BoxFit.cover,
                        ),
                        onLongPress: () {
                          OneContext().showDialog(
                            // barrierDismissible: false,
                            builder: (_) {
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Text(
                                  'Download this Image ?',
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
                                    },
                                  ),
                                  TextButton(
                                    child: Text(
                                      'Yes',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: AppColors.landingOrangeButton,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      OneContext().popDialog('success');
                                      final path = downloadImage(
                                        documentSnapshot['postimage'],
                                      );
                                      Fluttertoast.showToast(
                                        msg: 'Image Downloaded to $path',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  likeUnlikeButton(
                                    context,
                                    documentSnapshot,
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _pandora.logAPPButtonClicksEvent(
                                        'SHOW_POST_COMMENT_BTN_CLICK',
                                      );

                                      Provider.of<PostFunctions>(
                                        context,
                                        listen: false,
                                      ).showCommentsSheet(
                                        context,
                                        documentSnapshot,
                                        documentSnapshot['caption'],
                                      );
                                    },
                                    child: SvgPicture.asset(
                                      'assets/nsvgs/timeline/Comment.svg',
                                      width: 20.0,
                                      height: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            Visibility(
                              visible: (Provider.of<Authentication>(
                                        context,
                                        listen: false,
                                      ).getUserUid ==
                                      documentSnapshot['useruid'])
                                  ? true
                                  : false,
                              child: GestureDetector(
                                onTap: () {
                                  _pandora.logAPPButtonClicksEvent(
                                    'POST_OWNER_MORE_BUTTON_CLICKED',
                                  );

                                  Provider.of<PostFunctions>(
                                    context,
                                    listen: false,
                                  ).showPostOptions(
                                    documentSnapshot['caption'],
                                  );
                                },
                                child: const Icon(
                                  EvaIcons.moreVertical,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                              ),
                            ),
                            Visibility(
                              visible: (Provider.of<Authentication>(
                                        context,
                                        listen: false,
                                      ).getUserUid !=
                                      documentSnapshot['useruid'])
                                  ? true
                                  : false,
                              child: GestureDetector(
                                onTap: () {
                                  _pandora.logAPPButtonClicksEvent(
                                    'POST_N_OWNER_MORE_BUTTON_CLICKED',
                                  );

                                  Provider.of<PostFunctions>(
                                    context,
                                    listen: false,
                                  ).showNonOwnerPostOptions(
                                    documentSnapshot['caption'],
                                  );
                                },
                                child: const Icon(
                                  EvaIcons.moreVertical,
                                  color: Colors.black,
                                  size: 22.0,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(documentSnapshot['caption'])
                              .collection('likes')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container();
                            } else {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              return GestureDetector(
                                onTap: () {
                                  _pandora.logAPPButtonClicksEvent(
                                    'SHOW_POST_LIKES_BTN_CLICK',
                                  );

                                  _pandora.reRouteUser(
                                    context,
                                    '/likes',
                                    documentSnapshot['caption'],
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      '${snapshot.data!.docs.length} likes - ',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.0,
                                        fontFamily: 'semibold',
                                      ),
                                    ),
                                    Text(
                                      ' ${Provider.of<PostFunctions>(context, listen: false).showTimeAgo(documentSnapshot['time'])}',
                                      style: const TextStyle(
                                        color: AppColors.greyTextLogin,
                                        fontSize: 12.0,
                                        fontFamily: 'semibold',
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        RichText(
                          text: TextSpan(
                            text: '${documentSnapshot['caption']}',
                            style: const TextStyle(
                              color: AppColors.dashGridTextColor,
                              fontSize: 15.0,
                              fontFamily: 'regular',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('posts')
                              .doc(documentSnapshot['caption'])
                              .collection('comments')
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Container();
                            } else {
                              if (snapshot.data == null) {
                                return Container();
                              }
                              return Visibility(
                                visible: (snapshot.data!.docs.isEmpty) ? false : true,
                                child: GestureDetector(
                                  child: Text(
                                    'View all ${snapshot.data!.docs.length} comments',
                                    style: const TextStyle(
                                      color: AppColors.greyTextLogin,
                                      fontSize: 12.0,
                                      fontFamily: 'semibold',
                                    ),
                                  ),
                                  onTap: () {
                                    _pandora.logAPPButtonClicksEvent(
                                      'SHOW_POST_COMMENTS_BUTTON_CLICKED',
                                    );

                                    Provider.of<PostFunctions>(
                                      context,
                                      listen: false,
                                    ).showCommentsSheet(
                                      context,
                                      documentSnapshot,
                                      documentSnapshot['caption'],
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            _pandora.logAPPButtonClicksEvent(
                              'SHOW_POST_COMMENT_BTN_CLICK',
                            );

                            Provider.of<PostFunctions>(
                              context,
                              listen: false,
                            ).showCommentsSheet(
                              context,
                              documentSnapshot,
                              documentSnapshot['caption'],
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Row(
                              children: [
                                StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(
                                        Provider.of<Authentication>(
                                          context,
                                          listen: false,
                                        ).getUserUid,
                                      )
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Center(
                                        child: Container(),
                                      );
                                    } else {
                                      if (snapshot.data == null) {
                                        return Container();
                                      }
                                      return Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(25.0),
                                          child: Image.network(
                                            snapshot.data!['userimage'],
                                            height: 25,
                                            width: 25,
                                            fit: BoxFit.cover,
                                            errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                            ) {
                                              return Image.network(
                                                DEFAULT_IMAGE,
                                                height: 25,
                                                width: 25,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    'Add comment ...',
                                    style: TextStyle(
                                      color: AppColors.greyTextLogin,
                                      fontSize: 12.0,
                                      fontFamily: 'regular',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget likeUnlikeButton(
    BuildContext context,
    DocumentSnapshot documentSnapshot,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .doc(documentSnapshot['caption'])
          .collection('likes')
          .where(
            "useruid",
            isEqualTo: Provider.of<Authentication>(context, listen: false).getUserUid,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data?.docs.isNotEmpty ?? true) {
            return GestureDetector(
              onTap: () {
                _pandora.logAPPButtonClicksEvent(
                  'ADDING_LIKE_TO_POST_BUTTON_CLICKED',
                );
                debugPrint('Removing like...');
                Provider.of<PostFunctions>(context, listen: false).removeLike(
                  context,
                  documentSnapshot['caption'],
                  Provider.of<Authentication>(context, listen: false).getUserUid,
                );
              },
              child: const Icon(
                EvaIcons.heart,
                color: AppColors.redColor,
              ),
            );
          } else {
            return GestureDetector(
              onTap: () {
                _pandora.logAPPButtonClicksEvent(
                  'ADDING_LIKE_TO_POST_BUTTON_CLICKED',
                );
                debugPrint('Adding like...');
                Provider.of<PostFunctions>(context, listen: false).addLike(
                  context,
                  documentSnapshot['caption'],
                  Provider.of<Authentication>(context, listen: false).getUserUid,
                );
              },
              child: SvgPicture.asset(
                'assets/nsvgs/timeline/Heart.svg',
                width: 20.0,
                height: 20.0,
              ),
            );
          }
        } else {
          return GestureDetector(
            onTap: () {
              _pandora.logAPPButtonClicksEvent(
                'ADDING_LIKE_TO_POST_BUTTON_CLICKED',
              );
            },
            child: SvgPicture.asset(
              'assets/nsvgs/timeline/Heart.svg',
              width: 20.0,
              height: 20.0,
            ),
          );
        }
      },
    );
  }

  Future<String?> downloadImage(String image) async {
    return null;

    // try {
    //   final imageId = await ImageDownloader.downloadImage(image);
    //   if (imageId == null) {
    //     return null;
    //   } else {
    //     final path = await ImageDownloader.findPath(imageId);
    //     return path;
    //   }
    // } on PlatformException catch (error) {
    //   debugPrint(error);
    //   return error.message;
    // }
  }
}
