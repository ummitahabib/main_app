import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ProfileOptionsWidget extends StatelessWidget {
  final String? text;
  final Icon? icon;
  final void Function()? onTap;
  const ProfileOptionsWidget({
    super.key,
    this.text,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        //width: SpacingConstants.size342,
        height: SpacingConstants.size56,
        child: Row(
          children: [
            icon ??
                const Icon(
                  EvaIcons.personOutline,
                  color: AppColors.SmatCrowPrimary500,
                  size: SpacingConstants.size24,
                ),
            customSizedBoxWidth(SpacingConstants.size8),
            Text(
              text ?? personalProfileText,
              style: Styles.profileOptionTextStyle(),
            )
          ],
        ),
      ),
    );
  }
}
