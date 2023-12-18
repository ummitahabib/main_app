import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';

import '../../../../utils/colors.dart';
import '../../../splash/splash_page.dart';
import '../../../widgets/square_button.dart';
import 'edit_profile_item.dart';

class EditProfileMenu extends StatelessWidget {
  const EditProfileMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> editProfileItem = [];

    final Pandora pandora = Pandora();

    if (editProfile.isNotEmpty) {
      for (final item in editProfile) {
        editProfileItem.add(
          EditProfileItem(
            route: item["route"],
            image: item["image"],
            text: item["text"],
            background: item["background"],
          ),
        );
      }
    } else {}
    editProfileItem.insert(
      3,
      const SizedBox(
        height: 150,
      ),
    );
    editProfileItem.insert(
      4,
      SquareButton(
        backgroundColor: AppColors.landingOrangeButton,
        text: "Log out",
        textColor: Colors.white,
        press: () {
          pandora.clearUserData();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const SplashPage(),
            ),
            (route) => false,
          );
        },
      ),
    );

    return ListView.builder(
      itemCount: editProfileItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return editProfileItem[index];
      },
    );
  }
}
