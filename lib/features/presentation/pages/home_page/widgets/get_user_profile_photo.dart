import 'package:flutter/material.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/profile_widget.dart';

//get user profile photo

class UserProfileWidget extends StatelessWidget {
  const UserProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 30,
      height: 30,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: profileWidget(imageUrl: DEFAULT_IMAGE),
      ),
    );
  }
}
