import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class Likes extends StatelessWidget {
  final String postId;

  const Likes({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'Likes',
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
            pandora.logAPPButtonClicksEvent('LIKES_BACK_BUTTON_CLICKED');
            Navigator.pop(context);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('posts').doc(postId).collection('likes').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data == null) {
                return Container();
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                  return ListTile(
                    leading: GestureDetector(
                      onTap: () {
                        pandora.logAPPButtonClicksEvent('ALT_PROFILE_BUTTON_CLICKED');
                        pandora.reRouteUser(context, '/altProfile', documentSnapshot['useruid']);
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40.0),
                          child: Image.network(
                            documentSnapshot['userimage'],
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(DEFAULT_IMAGE, height: 40, width: 40, fit: BoxFit.cover);
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
                      documentSnapshot['useremail'],
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(
                          color: Colors.black.withOpacity(0.8),
                          fontSize: 12.0,
                        ),
                      ),
                    ),
                    trailing: Provider.of<Authentication>(context, listen: false).getUserUid ==
                            documentSnapshot['useruid']
                        ? const SizedBox(width: 0.0, height: 0.0)
                        : MaterialButton(
                            onPressed: () {
                              pandora.logAPPButtonClicksEvent('FOLLOW_USER_BUTTON_CLICKED');

                              Provider.of<FirebaseOperations>(context, listen: false)
                                  .followUser(
                                      documentSnapshot['useruid'],
                                      Provider.of<Authentication>(context, listen: false).getUserUid,
                                      {
                                        'username':
                                            Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
                                        'userimage':
                                            Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
                                        'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                                        'useremail':
                                            Provider.of<FirebaseOperations>(context, listen: false).getInitUserEmail,
                                        'time': Timestamp.now()
                                      },
                                      Provider.of<Authentication>(context, listen: false).getUserUid,
                                      documentSnapshot['useruid'],
                                      {
                                        'username': documentSnapshot['username'],
                                        'userimage': documentSnapshot['userimage'],
                                        'useremail': documentSnapshot['useremail'],
                                        'useruid': documentSnapshot['useruid'],
                                        'time': Timestamp.now()
                                      })
                                  .whenComplete(() {
                                followedNotification(context, documentSnapshot['username']);
                              });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
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
                          ),
                  );
                }).toList(),
              );
            }
          },
        ),
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
}
