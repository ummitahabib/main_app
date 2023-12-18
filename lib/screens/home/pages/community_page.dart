import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/home/widgets/community/messaging/chatroom_helpers.dart';
import 'package:smat_crow/utils/colors.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({Key? key}) : super(key: key);

  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  void initState() {
    super.initState();
  }

  final Pandora _pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.whiteColor,
        leadingWidth: 0.0,
        leading: Container(),
        title: const Text('Community',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.black, fontSize: 23.0, fontFamily: 'semibold', fontWeight: FontWeight.bold),),
        actions: [
          Row(
            children: [
              const Text('Add Room',
                  overflow: TextOverflow.fade,
                  style: TextStyle(color: Colors.black, fontSize: 16.0, fontFamily: 'regular'),),
              IconButton(
                  icon: SvgPicture.asset(
                    'assets/nsvgs/timeline/new_post.svg',
                    width: 20.0,
                    height: 20.0,
                  ),
                  onPressed: () {
                    _pandora.logAPPButtonClicksEvent('CREATE_CHATROOM_BUTTON_CLICKED');
                    Provider.of<ChatroomHelper>(context, listen: false).showCreateChatroomSheet(context);
                  },)
            ],
          )
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10),
        child: Provider.of<ChatroomHelper>(context, listen: false).showChatrooms(context),
      ),
    );
  }
}
