import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessagingHelper with ChangeNotifier {
  bool hasMemberJoined = false;
  String lastMessageTime = '';

  String get getLastMessageTime => lastMessageTime;

  bool get getHasMemberJoined => hasMemberJoined;
  final Pandora _pandora = Pandora();

  Future leaveTheRoom(BuildContext context, String chatRoomName) {
    return OneContext().showDialog(
      // barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Leave $chatRoomName?',
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
                Navigator.of(context).pop('Leave Room');
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
                _pandora.logAPPButtonClicksEvent(
                  'CONFIRM_LEAVE_ROOM_BUTTON_CLICKED',
                );
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(chatRoomName)
                    .collection('members')
                    .doc(
                      Provider.of<Authentication>(context, listen: false).getUserUid,
                    )
                    .delete()
                    .whenComplete(() {
                  OneContext().popDialog('success');
                  Navigator.of(context).pop('Leave Room');
                });
              },
            ),
          ],
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> showMessages(
    BuildContext context,
    DocumentSnapshot documentSnapshot,
    String adminUserUid,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chatrooms')
          .doc(documentSnapshot.id)
          .collection('messages')
          .orderBy('time', descending: true)
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
            reverse: true,
            physics: const BouncingScrollPhysics(),
            children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              showLastMessageTime(documentSnapshot['time']);
              return Container(
                margin: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                  left: (documentSnapshot['useruid'] ==
                          Provider.of<Authentication>(
                            context,
                            listen: false,
                          ).getUserUid)
                      ? 50
                      : 10,
                  right: (documentSnapshot['useruid'] ==
                          Provider.of<Authentication>(
                            context,
                            listen: false,
                          ).getUserUid)
                      ? 10
                      : 50,
                ),
                child: Column(
                  crossAxisAlignment: (documentSnapshot['useruid'] ==
                          Provider.of<Authentication>(
                            context,
                            listen: false,
                          ).getUserUid)
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Visibility(
                          visible: (documentSnapshot['useruid'] ==
                                  Provider.of<Authentication>(
                                    context,
                                    listen: false,
                                  ).getUserUid)
                              ? false
                              : true,
                          child: InkWell(
                            onTap: () {
                              _pandora.logAPPButtonClicksEvent(
                                'VIEW_ALT_PROFILE_BUTTON_CLICKED',
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
                              height: 30,
                              width: 30,
                              margin: const EdgeInsets.only(right: 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  documentSnapshot['userimage'],
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.network(
                                      DEFAULT_IMAGE,
                                      height: 10,
                                      width: 10,
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: (documentSnapshot['useruid'] ==
                                    Provider.of<Authentication>(context, listen: false).getUserUid)
                                ? AppColors.darkColor.withOpacity(0.8)
                                : AppColors.darkColor.withOpacity(0.9),
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(8),
                              topRight: const Radius.circular(8),
                              bottomLeft: (documentSnapshot['useruid'] ==
                                      Provider.of<Authentication>(context, listen: false).getUserUid)
                                  ? const Radius.circular(8)
                                  : const Radius.circular(0),
                              bottomRight: (documentSnapshot['useruid'] ==
                                      Provider.of<Authentication>(
                                        context,
                                        listen: false,
                                      ).getUserUid)
                                  ? const Radius.circular(0)
                                  : const Radius.circular(8),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${documentSnapshot['username']}',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    /*Provider.of<Authentication>(context,
                                                        listen: false)
                                                    .getUserUid ==
                                                adminUserUid
                                            ? Icon(FontAwesomeIcons.solidStar,
                                                color: AppColors
                                                    .landingOrangeButton,
                                                size: 8.0)
                                            : Container(
                                                width: 0.0,
                                                height: 0.0,
                                              )*/
                                  ],
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                if (documentSnapshot['message'] != null)
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.5,
                                    child: Text(
                                      '${documentSnapshot['message']}',
                                      softWrap: true,
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      height: 90.0,
                                      width: 100.0,
                                      child: Image.network(documentSnapshot['sticker']),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: (documentSnapshot['useruid'] ==
                              Provider.of<Authentication>(
                                context,
                                listen: false,
                              ).getUserUid)
                          ? false
                          : true,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 40,
                          ),
                          Text(
                            getLastMessageTime,
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.black,
                                fontSize: 8.0,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Visibility(
                      visible: (documentSnapshot['useruid'] ==
                              Provider.of<Authentication>(
                                context,
                                listen: false,
                              ).getUserUid)
                          ? true
                          : false,
                      child: Text(
                        getLastMessageTime,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Future<DocumentReference<Map<String, dynamic>>> sendMessage(
    BuildContext context,
    DocumentSnapshot documentSnapshot,
    TextEditingController messageController,
  ) {
    return FirebaseFirestore.instance.collection('chatrooms').doc(documentSnapshot.id).collection('messages').add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
    });
  }

  Future checkIfJoined(
    BuildContext context,
    String chatRoomName,
    String chatRoomAdminUid,
  ) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((value) {
      hasMemberJoined = false;
      debugPrint('Inital state => $hasMemberJoined');
      if (value.data() != null && value.data()!['joined'] != null) {
        hasMemberJoined = value.data()!['joined'];
        debugPrint('Final state => $hasMemberJoined');
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid == chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  Future askToJoin(BuildContext context, String roomName) {
    return showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Join $roomName?',
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
                Navigator.pop(_);
                Navigator.pop(context);
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
              onPressed: () async {
                _pandora.logAPPButtonClicksEvent(
                  'CONFIRM_JOIN_CHATROOM_BUTTON_CLICKED',
                );
                await FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(roomName)
                    .collection('members')
                    .doc(
                      Provider.of<Authentication>(_, listen: false).getUserUid,
                    )
                    .set({
                  'joined': true,
                  'username': Provider.of<FirebaseOperations>(_, listen: false).getInitUserName,
                  'userimage': Provider.of<FirebaseOperations>(_, listen: false).getInitUserImage,
                  'useruid': Provider.of<Authentication>(_, listen: false).getUserUid,
                  'time': Timestamp.now()
                }).whenComplete(() {
                  Navigator.pop(_);
                });
              },
            ),
          ],
        );
      },
    );
  }

  Future showSticker(BuildContext context, String chatroomid) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      builder: (context) {
        return AnimatedContainer(
          duration: const Duration(seconds: 1),
          curve: Curves.easeIn,
          height: MediaQuery.of(context).size.height * 0.5,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.darkColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 105.0),
                child: Divider(
                  thickness: 4,
                  color: AppColors.whiteColor,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: AppColors.blueColor),
                      ),
                      height: 30.0,
                      width: 30.0,
                      child: Image.asset('assets/icons/sunflower.png'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('stickers').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.data == null) {
                        return Container();
                      }
                      return GridView(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                          return GestureDetector(
                            onTap: () {
                              sendStickers(
                                context,
                                documentSnapshot['image'],
                                chatroomid,
                              );
                            },
                            child: SizedBox(
                              height: 40.0,
                              width: 40.0,
                              child: Image.network(
                                documentSnapshot['image'],
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

  sendStickers(
    BuildContext context,
    String stickerImageUrl,
    String chatRoomId,
  ) async {
    await FirebaseFirestore.instance.collection('chatrooms').doc(chatRoomId).collection('messages').add({
      'sticker': stickerImageUrl,
      'username': Provider.of<FirebaseOperations>(context, listen: false).getInitUserName,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false).getInitUserImage,
      'time': Timestamp.now()
    });
  }

  showLastMessageTime(dynamic timeData) {
    final Timestamp time = timeData;
    final DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    debugPrint(lastMessageTime);
    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });
  }
}
