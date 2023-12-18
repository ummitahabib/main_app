import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/network/social/authentication.dart';
import 'package:smat_crow/screens/home/widgets/profile/edit_profile_header.dart';
import 'package:smat_crow/screens/home/widgets/profile/edit_profile_menu.dart';
import 'package:smat_crow/screens/home/widgets/profile/profile_helpers.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.1,
          backgroundColor: AppColors.whiteColor,
          leadingWidth: 0.0,
          leading: Container(),
          title: const Text(
            'Account',
            overflow: TextOverflow.fade,
            style: TextStyle(color: Colors.black, fontSize: 23.0, fontFamily: 'semibold', fontWeight: FontWeight.bold),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.more_vert_sharp,
                color: AppColors.greyColor,
              ),
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  context: context,
                  builder: (context) {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (userData != null)
                                  EditProfileHeader(
                                    text: 'Hi, ${"${userData!.firstName} ${userData!.lastName}"}',
                                    color: Colors.black,
                                  )
                                else
                                  const EditProfileHeader(
                                    text: 'Hi, ${'Unknown'}',
                                    color: Colors.black,
                                  ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: AppColors.closeButtonGrey,
                                    size: 20,
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Divider(
                                height: 1.0,
                              ),
                            ),
                            const EditProfileMenu(),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Container(),
                  );
                } else {
                  return Column(
                    children: [
                      Provider.of<ProfileHelpers>(context, listen: false).headerProfile(context, snapshot),
                      Provider.of<ProfileHelpers>(context, listen: false).footerProfile(context, snapshot),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
