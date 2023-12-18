import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

import 'group_message_helpers.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;

  const GroupMessage({super.key, required this.documentSnapshot});

  @override
  _GroupMessageState createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final TextEditingController messageController = TextEditingController();
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    Provider.of<GroupMessagingHelper>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot.id, widget.documentSnapshot['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessagingHelper>(context, listen: false).getHasMemberJoined == false) {
        Timer(
          const Duration(milliseconds: 10),
          () =>
              Provider.of<GroupMessagingHelper>(context, listen: false).askToJoin(context, widget.documentSnapshot.id),
        );
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fieldAgentDashboard,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        automaticallyImplyLeading: false,
        title: Container(
          child: Row(
            children: [
              SizedBox(
                height: 30,
                width: 30,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Container(
                    color: AppColors.landingOrangeButton.withOpacity(0.6),
                    child: Center(
                      child: Text(
                        widget.documentSnapshot['roomname'].toString().substring(0, 2).toUpperCase(),
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            color: AppColors.fieldAgentText,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.documentSnapshot['roomname']}',
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          color: AppColors.fieldAgentText,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(widget.documentSnapshot.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container();
                        } else {
                          if (snapshot.data == null) {
                            return Container();
                          }
                          return Text(
                            '${snapshot.data!.docs.length} members',
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: AppColors.fieldAgentText,
                                fontSize: 10.0,
                              ),
                            ),
                          );
                        }
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.keyboard_backspace_rounded,
            color: AppColors.fieldAgentText,
          ),
          onPressed: () {
            _pandora.logAPPButtonClicksEvent('CHAT_ROOM_BACK_BUTTON_CLICKED');
            Navigator.pop(context);
          },
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              AnimatedContainer(
                height: MediaQuery.of(context).size.height * 0.82,
                width: MediaQuery.of(context).size.width,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
                child: Provider.of<GroupMessagingHelper>(context, listen: false)
                    .showMessages(context, widget.documentSnapshot, widget.documentSnapshot['useruid']),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration:
                    const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(30))),
                child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 9,
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Send a message ...',
                            hintStyle: GoogleFonts.poppins(
                              textStyle: TextStyle(
                                color: Colors.black.withOpacity(0.8),
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          controller: messageController,
                          keyboardType: TextInputType.multiline,
                          style: GoogleFonts.poppins(
                            textStyle: TextStyle(
                              color: Colors.black.withOpacity(0.8),
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            _pandora.logAPPButtonClicksEvent('CHAT_SEND_MESSAGE_BUTTON_CLICKED');
                            if (messageController.text.isNotEmpty) {
                              Provider.of<GroupMessagingHelper>(context, listen: false)
                                  .sendMessage(context, widget.documentSnapshot, messageController)
                                  .whenComplete(messageController.clear);
                            }
                          },
                          child: Container(
                            child: const Icon(Icons.send),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
