import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class CommentsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() onBackPress;

  const CommentsAppBar({super.key, required this.onBackPress});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.SmatCrowDefaultWhite,
      leading: IconButton(
        icon: const Icon(
          EvaIcons.arrowBackOutline,
          color: AppColors.SmatCrowNeuBlue900,
        ),
        onPressed: onBackPress,
      ),
      title: Text(commentText, style: Styles.commentTextStyle()),
    );
  }
}
