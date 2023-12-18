import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/bold_header_text.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class MoneyTile extends StatelessWidget {
  const MoneyTile({
    super.key,
    required this.title,
    required this.value,
    required this.color,
  });

  final String title;
  final double value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: SpacingConstants.size5,
        backgroundColor: color,
      ),
      minLeadingWidth: 0,
      horizontalTitleGap: 8,
      title: BoldHeaderText(
        text: "₦${Pandora().newMoneyFormat(value)}",
        fontFamily: arialFont,
      ),
      subtitle: Text(
        title,
        style: Styles.smatCrowCaptionRegular(
          color: AppColors.SmatCrowNeuBlue600,
        ),
      ),
      dense: true,
    );
  }
}
