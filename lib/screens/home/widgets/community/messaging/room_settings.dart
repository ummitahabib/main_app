import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

import 'group_message_helpers.dart';

class RoomSettings extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  const RoomSettings({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        title: Text(
          'Settings',
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
            pandora.logAPPButtonClicksEvent('ROOM_SETTINGS_BACK_BUTTON_CLICKED');
            Navigator.pop(context);
          },
        ),
        actions: [
          if (Provider.of<Authentication>(context, listen: false).getUserUid == documentSnapshot['useruid'])
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                pandora.logAPPButtonClicksEvent('DELETE_CHATROOM_BUTTON_CLICKED');
                return showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: Colors.white,
                      title: Text(
                        'Delete ChatRoom?',
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
                            Navigator.pop(context);
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
                            pandora.logAPPButtonClicksEvent('CONFIRM_DELETE_CHATRROM_BUTTON_CLICKED');
                            FirebaseFirestore.instance
                                .collection('chatrooms')
                                .doc(documentSnapshot.id)
                                .delete()
                                .then((value) {
                              Navigator.pop(context, true);
                            }).whenComplete(() {
                              Fluttertoast.showToast(
                                msg: 'Deleted Room',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.login_rounded, color: Colors.red),
              onPressed: () async {
                await Provider.of<GroupMessagingHelper>(context, listen: false)
                    .leaveTheRoom(context, documentSnapshot.id);
              },
            ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(40.0),
                        child: Image.network(
                          documentSnapshot['userimage'],
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(DEFAULT_IMAGE, height: 40, width: 40, fit: BoxFit.cover);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          documentSnapshot['username'],
                          style: GoogleFonts.poppins(
                            textStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Admin',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 8.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Members',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatrooms')
                  .doc(documentSnapshot.id)
                  .collection('members')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  return ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                      return Card(
                        elevation: 0,
                        child: ListTile(
                          leading: GestureDetector(
                            onTap: () {
                              pandora.logAPPButtonClicksEvent('VIEW_ALT_PROFILE_BUTTON_CLICKED');
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
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ),
        ],
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
