import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/screens/home/widgets/profile/alt_profile_helpers.dart';

class AltProfile extends StatelessWidget {
  final String userUid;

  const AltProfile({super.key, required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AltProfileHelpers>(context, listen: false).appBar(context, userUid),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('users').doc(userUid).snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Provider.of<AltProfileHelpers>(context, listen: false).headerProfile(context, snapshot, userUid),
                    Provider.of<AltProfileHelpers>(context, listen: false).divider(),
                    Provider.of<AltProfileHelpers>(context, listen: false).footerProfile(context, snapshot)
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
