import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/stories/stories_helper.dart';
import 'package:smat_crow/screens/home/widgets/community/stories/stories_widget.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class Stories extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const Stories({super.key, required this.documentSnapshot});

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  final StoryWidgets storyWidgets = StoryWidgets();
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    Provider.of<StoriesHelper>(context, listen: false).storyTimePosted(widget.documentSnapshot['time']);
    Provider.of<StoriesHelper>(context, listen: false).addSeenStamp(
      context,
      widget.documentSnapshot.id,
      Provider.of<Authentication>(context, listen: false).getUserUid,
      widget.documentSnapshot,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onPanUpdate: (update) {
          if (update.delta.dx > 0) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: (widget.documentSnapshot['image'] != null)
                          ? Image.network(widget.documentSnapshot['image'], fit: BoxFit.contain)
                          : Container(),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 30.0,
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child: (widget.documentSnapshot['userimage'] != null)
                              ? Image.network(
                                  widget.documentSnapshot['userimage'],
                                  height: 35,
                                  width: 35,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(DEFAULT_IMAGE, height: 35, width: 35, fit: BoxFit.cover);
                                  },
                                )
                              : Image.network(DEFAULT_IMAGE, height: 35, width: 35, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.53,
                        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (widget.documentSnapshot['username'] != null)
                              Text(
                                widget.documentSnapshot['username'],
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              )
                            else
                              Text(
                                'User',
                                style: GoogleFonts.poppins(
                                  textStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            Text(
                              Provider.of<StoriesHelper>(context, listen: false).getStoryTime,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  color: AppColors.landingOrangeButton,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (Provider.of<Authentication>(context, listen: false).getUserUid ==
                        widget.documentSnapshot['useruid'])
                      GestureDetector(
                        onTap: () {
                          _pandora.logAPPButtonClicksEvent('SHOW_STATUS_VIEWERS_BUTTON_CLICKED');
                          storyWidgets.showViewers(
                            context,
                            widget.documentSnapshot.id,
                            widget.documentSnapshot['useruid'],
                          );
                        },
                        child: SizedBox(
                          height: 30.0,
                          width: 50.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Icon(EvaIcons.eyeOutline, color: AppColors.whiteColor, size: 16.0),
                              StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('stories')
                                    .doc(widget.documentSnapshot.id)
                                    .collection('seen')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: Container());
                                  } else {
                                    if (snapshot.data == null) {
                                      return Container();
                                    }
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                        ),
                                      ),
                                    );
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      )
                    else
                      const SizedBox(width: 0.0, height: 0.0),
                    const SizedBox(
                      height: 30.0,
                      width: 30.0,
                      child: CircularCountDownTimer(
                        isTimerTextShown: false,
                        duration: 15,
                        fillColor: AppColors.whiteColor,
                        height: 20.0,
                        width: 20.0,
                        ringColor: Colors.black,
                        strokeWidth: 2,
                      ),
                    ),
                    Visibility(
                      visible: (widget.documentSnapshot['useruid'] ==
                              Provider.of<Authentication>(context, listen: false).getUserUid)
                          ? true
                          : false,
                      child: IconButton(
                        icon: const Icon(EvaIcons.moreVertical, color: AppColors.whiteColor),
                        onPressed: () {
                          showModalBottomSheet(
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
                                height: 80,
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
                                                  _pandora.logAPPButtonClicksEvent('DELETE_STORY_BUTTON_CLICKED');
                                                  FirebaseFirestore.instance
                                                      .collection('stories')
                                                      .doc(
                                                        Provider.of<Authentication>(context, listen: false).getUserUid,
                                                      )
                                                      .delete()
                                                      .whenComplete(() {
                                                    Navigator.pop(context);
                                                  }).whenComplete(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text(
                                                  'Delete...',
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
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
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
}
