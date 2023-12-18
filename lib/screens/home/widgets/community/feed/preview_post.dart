import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/feed/post_functions.dart';

class PreviewPost extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PreviewPost({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.black,
        title: Text(
          'Post',
          overflow: TextOverflow.fade,
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: Image.network(snapshot['postimage']),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pandora.logAPPButtonClicksEvent('ADD_LIKE_TO_POST_BUTTON');
                            debugPrint('Adding like...');
                            Provider.of<PostFunctions>(context, listen: false).addLike(
                              context,
                              snapshot['caption'],
                              Provider.of<Authentication>(context, listen: false).getUserUid,
                            );
                          },
                          child: const Icon(
                            EvaIcons.heartOutline,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            pandora.logAPPButtonClicksEvent('SHOW_COMMENT_BUTTON_CLICKED');

                            Provider.of<PostFunctions>(context, listen: false)
                                .showCommentsSheet(context, snapshot, snapshot['caption']);
                          },
                          child: const Icon(
                            EvaIcons.messageCircleOutline,
                            color: Colors.white,
                            size: 22.0,
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 14),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  pandora.logAPPButtonClicksEvent('SHOW_LIKES_BUTTON_CLICKED');

                                  pandora.reRouteUser(context, '/likes', snapshot['caption']);
                                },
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(snapshot['caption'])
                                      .collection('likes')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else {
                                      if (snapshot.data == null) {
                                        return Container();
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${snapshot.data!.docs.length} Likes',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  pandora.logAPPButtonClicksEvent('SHOW_COMMENTS_BUTTON_CLICKED');

                                  Provider.of<PostFunctions>(context, listen: false)
                                      .showCommentsSheet(context, snapshot, snapshot['caption']);
                                },
                                child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('posts')
                                      .doc(snapshot['caption'])
                                      .collection('comments')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else {
                                      if (snapshot.data == null) {
                                        return Container();
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          '${snapshot.data!.docs.length} Comments',
                                          style: GoogleFonts.poppins(
                                            textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        snapshot['caption'],
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
