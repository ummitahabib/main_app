import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class Followers extends StatelessWidget {
  final dynamic snapshot;

  const Followers({Key? key, this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'Followers',
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
            Navigator.pop(context);
            pandora.logAPPButtonClicksEvent('FOLLOWERS_BACK_BUTTON_CLICKED');
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.data['useruid'])
            .collection('followers')
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else {
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
                  );
                }
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
}
