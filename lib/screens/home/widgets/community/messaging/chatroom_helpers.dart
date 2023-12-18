import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/network/social/firebase.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/widgets/old_text_field.dart';
import 'package:smat_crow/screens/widgets/square_button.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelper with ChangeNotifier {
  String latestMessageTime = '';

  String get getLatestMessageTime => latestMessageTime;
  int chatroomMessageSize = 0;

  int get getMessagesSize => chatroomMessageSize;
  String chatroomAvatarUrl = '', chatroomID = '';

  String get getChatroomID => chatroomID;

  String get getChatroomAvatarUrl => chatroomAvatarUrl;
  final TextEditingController chatroomNameController = TextEditingController();
  final TextEditingController roomSubjectController = TextEditingController();
  final Pandora _pandora = Pandora();

  Future showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            color: AppColors.landingTextWhite,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 150.0),
                  child: Divider(
                    color: Colors.black,
                    thickness: 4.0,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextInputContainer(
                  child: TextField(
                    autocorrect: false,
                    controller: chatroomNameController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.name,
                    style: const TextStyle(
                      color: AppColors.signupSubHeaderGrey,
                      fontSize: 15.0,
                      fontFamily: 'NunitoSans_Regular',
                    ),
                    decoration: const InputDecoration(
                      hintText: "Room Name",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.signupSubHeaderGrey,
                        fontFamily: 'NunitoSans_Regular',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextInputContainer(
                  child: TextField(
                    autocorrect: false,
                    controller: roomSubjectController,
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      color: AppColors.signupSubHeaderGrey,
                      fontSize: 15.0,
                      fontFamily: 'NunitoSans_Regular',
                    ),
                    decoration: const InputDecoration(
                      hintText: "Room Subject",
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 15.0,
                        color: AppColors.signupSubHeaderGrey,
                        fontFamily: 'NunitoSans_Regular',
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                SquareButton(
                  backgroundColor: AppColors.landingOrangeButton,
                  press: () async {
                    _pandora.logAPPButtonClicksEvent(
                      'CREATE_CHATROOM_BUTTON_CLICKED',
                    );
                    await Provider.of<FirebaseOperations>(
                      context,
                      listen: false,
                    ).submitChatroomData(chatroomNameController.text, {
                      'time': Timestamp.now(),
                      'roomname': chatroomNameController.text,
                      'roomsubject': roomSubjectController.text,
                      'username': Provider.of<FirebaseOperations>(
                        context,
                        listen: false,
                      ).getInitUserName,
                      'userimage': Provider.of<FirebaseOperations>(
                        context,
                        listen: false,
                      ).getInitUserImage,
                      'useremail': Provider.of<FirebaseOperations>(
                        context,
                        listen: false,
                      ).getInitUserEmail,
                      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  textColor: AppColors.landingWhiteButton,
                  text: 'Create Room',
                ),
                const SizedBox(
                  height: 8,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> showChatrooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SizedBox(
              height: 200.0,
              width: 200.0,
              child: Lottie.asset('assets/animations/loading.json'),
            ),
          );
        } else {
          if (snapshot.data == null) {
            return Container();
          }
          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
              return Card(
                elevation: 0,
                child: ListTile(
                  onTap: () {
                    _pandora.logAPPButtonClicksEvent(
                      'VIEW_CHATROOM_${documentSnapshot['roomname'].toString().toUpperCase()}_ITEM_CLICKED',
                    );
                    _pandora.reRouteUser(
                      context,
                      '/groupChat',
                      documentSnapshot,
                    );
                  },
                  onLongPress: () {
                    _pandora.logAPPButtonClicksEvent(
                      'VIEW_CHATROOM_${documentSnapshot['roomname'].toString().toUpperCase()}_SETTINGS_CLICKED',
                    );
                    _pandora.reRouteUser(
                      context,
                      '/groupSettings',
                      documentSnapshot,
                    );
                  },
                  title: Text(
                    documentSnapshot['roomname'],
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  trailing: SizedBox(
                    width: 80.0,
                    child: getTrailing(documentSnapshot),
                  ),
                  subtitle: getSubtitles(documentSnapshot),
                  leading: SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                        color: AppColors.landingOrangeButton.withOpacity(0.6),
                        child: Center(
                          child: Text(
                            documentSnapshot['roomname'].toString().substring(0, 2).toUpperCase(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

  showLastMessageTime(dynamic timeData) {
    final Timestamp t = timeData;
    final DateTime dateTime = t.toDate();
    latestMessageTime = timeago.format(dateTime);
    Future.delayed(Duration.zero, () async {
      notifyListeners();
    });
  }

  Widget getSubtitles(DocumentSnapshot documentSnapshot) {
    FirebaseFirestore.instance.doc('chatrooms/${documentSnapshot.id}').collection('messages').get().then((value) {
      chatroomMessageSize = value.size;
      notifyListeners();
    });
    return (getMessagesSize == 0)
        ? Text(
            documentSnapshot['roomsubject'],
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: Colors.black.withOpacity(0.6),
                fontSize: 12.0,
              ),
            ),
          )
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(documentSnapshot.id)
                .collection('messages')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              chatroomMessageSize = 0;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if ((snapshot.data == null) &&
                  (snapshot.data!.docs.isNotEmpty) &&
                  snapshot.data!.docs.first['username'] != null &&
                  snapshot.data!.docs.first['message'] != null) {
                return Text(
                  '${snapshot.data!.docs.first['username']} : ${snapshot.data!.docs.first['message']}',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 10.0,
                    ),
                  ),
                );
              } else {
                return Text(
                  documentSnapshot['roomsubject'],
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                      color: Colors.black.withOpacity(0.6),
                      fontSize: 12.0,
                    ),
                  ),
                );
              }
            },
          );
  }

  Widget getTrailing(DocumentSnapshot documentSnapshot) {
    return (getMessagesSize == 0)
        ? const SizedBox(
            width: 0,
            height: 0,
          )
        : StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('chatrooms')
                .doc(documentSnapshot.id)
                .collection('messages')
                .orderBy('time', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data == null) {
                  return Container();
                } else {
                  try {
                    showLastMessageTime(snapshot.data!.docs.first['time']);
                  } catch (e) {}
                  return Text(
                    getLatestMessageTime,
                    style: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                        fontSize: 10.0,
                      ),
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
  }
}
