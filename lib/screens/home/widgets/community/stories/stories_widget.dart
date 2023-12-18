import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/stories/stories_helper.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class StoryWidgets {
  final TextEditingController storyHighlightTitleController = TextEditingController();
  final Pandora _pandora = Pandora();

  Future addStory(BuildContext context) {
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
                              'UPLOAD_STORY_FROM_GALLERY_CLICKED',
                            );
                            Provider.of<StoriesHelper>(
                              context,
                              listen: false,
                            )
                                .selectStoryImage(
                                  context,
                                  ImageSource.gallery,
                                )
                                .whenComplete(() {});
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Gallery',
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
                              'UPLOAD_STORY_FROM_CAMERA_CLICKED',
                            );
                            Provider.of<StoriesHelper>(
                              context,
                              listen: false,
                            ).selectStoryImage(
                              context,
                              ImageSource.camera,
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Camera',
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
                ],
              )
            ],
          ),
        );
      },
    );
  }

  previewStoryImage(BuildContext context, File storyImage) {
    OneContext().showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (_) => Container(
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(_).size.height,
              width: MediaQuery.of(_).size.width,
              child: Image.file(storyImage),
            ),
            Positioned(
              top: 600.0,
              child: SizedBox(
                width: MediaQuery.of(_).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FloatingActionButton(
                      heroTag: 'Reselect image',
                      backgroundColor: AppColors.redColor,
                      child: const Icon(
                        FontAwesomeIcons.cameraRetro,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: () {
                        addStory(_);
                      },
                    ),
                    FloatingActionButton(
                      heroTag: 'Confirm image',
                      backgroundColor: AppColors.blueColor,
                      child: const Icon(
                        FontAwesomeIcons.check,
                        color: AppColors.whiteColor,
                      ),
                      onPressed: () {
                        OneContext().showProgressIndicator();
                        Provider.of<StoriesHelper>(_, listen: false).uploadStoryImage(_).whenComplete(() {
                          debugPrint("About to upload");
                          OneContext().hideProgressIndicator();
                          Navigator.of(_).pop('success');
                          debugPrint('Story uploaded!');
                        });
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

/*

  addToHighlights(BuildContext context, String storyImage) {
    return showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 150.0),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text('Add To Existing Album',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ))),
                  Container(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(Provider.of<Authentication>(context,
                                  listen: false)
                              .getUserUid)
                          .collection('highlights')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          return new ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return GestureDetector(
                                  onTap: () {
                                    Provider.of<StoriesHelper>(context,
                                            listen: false)
                                        .addStoryToExistingAlbum(
                                            context,
                                            Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserUid,
                                            documentSnapshot.id,
                                            storyImage);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                AppColors.darkColor,
                                            backgroundImage: NetworkImage(
                                                documentSnapshot['cover']),
                                            radius: 20,
                                          ),
                                          Text(documentSnapshot['title'],
                                              style: TextStyle(
                                                  color: AppColors.greenColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0))
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList());
                        }
                      },
                    ),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text('Create New Album',
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 14.0,
                      ))),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else {
                          return ListView(
                              scrollDirection: Axis.horizontal,
                              children: snapshot.data.docs
                                  .map((DocumentSnapshot documentSnapshot) {
                                return GestureDetector(
                                    onTap: () {
                                      Provider.of<StoriesHelper>(context,
                                              listen: false)
                                          .convertHighlightedIcon(
                                              documentSnapshot['image']);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Container(
                                        height: 50.0,
                                        width: 50.0,
                                        child: Image.network(
                                            documentSnapshot['image']),
                                      ),
                                    ));
                              }).toList());
                        }
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            textCapitalization: TextCapitalization.sentences,
                            controller: storyHighlightTitleController,
                            style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            )),
                            decoration: InputDecoration(
                              hintText: 'Add Album Title...',
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              )),
                            ),
                          ),
                        ),
                        InkWell(
                          child: Icon(Icons.send),
                          onTap: () {
                            if (storyHighlightTitleController.text.isNotEmpty) {
                              Provider.of<StoriesHelper>(context, listen: false)
                                  .addStoryToNewAlbum(
                                      context,
                                      Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid,
                                      storyHighlightTitleController.text,
                                      storyImage);
                            } else {
                              return showModalBottomSheet(
                                  context: context,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  builder: (context) {
                                    return Container(
                                      color: Colors.black,
                                      height: 100.0,
                                      width: 400.0,
                                      child: Center(
                                        child: Text('Album Created',
                                            style: GoogleFonts.poppins(
                                                textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14.0,
                                            ))),
                                      ),
                                    );
                                  });
                            }
                          },
                        )
                      ],
                    ),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
            ),
          );
        });
  }
*/

  Future showViewers(BuildContext context, String storyId, String personUid) {
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
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 150),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('stories').doc(storyId).collection('seen').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      return ListView(
                        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                          Provider.of<StoriesHelper>(context, listen: false).storyTimePosted(documentSnapshot['time']);
                          return ListTile(
                            leading: GestureDetector(
                              onTap: () {
                                _pandora.reRouteUser(
                                  context,
                                  '/altProfile',
                                  documentSnapshot['useruid'],
                                );
                              },
                              child: Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(40.0),
                                  child: Image.network(
                                    documentSnapshot['userimage'],
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.network(
                                        DEFAULT_IMAGE,
                                        height: 40,
                                        width: 40,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              documentSnapshot['username'],
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                            ),
                            subtitle: Text(
                              Provider.of<StoriesHelper>(
                                context,
                                listen: false,
                              ).getLastSeenTime,
                              style: GoogleFonts.poppins(
                                textStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.8),
                                  fontSize: 12.0,
                                ),
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

  Future previewAllHighlights(BuildContext context, String hightlightTitle) {
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
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(
                  Provider.of<Authentication>(context, listen: false).getUserUid,
                )
                .collection('highlights')
                .doc(hightlightTitle)
                .collection('stories')
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
                return PageView(
                  children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                    return Container(
                      decoration: const BoxDecoration(color: AppColors.darkColor),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(documentSnapshot['image']),
                    );
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
