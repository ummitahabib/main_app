import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/colors.dart';
import '../../../utils/styles.dart';

class FarmManagerAdditionalLogDetailsItem extends StatelessWidget {
  final List<Widget> listItems;
  final String title;

  const FarmManagerAdditionalLogDetailsItem({Key? key, required this.title, required this.listItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.offWhite,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, maxLines: 1, style: GoogleFonts.poppins(textStyle: Styles.textBlueGreyMd())),
            const SizedBox(
              height: 10,
            ),
            ListView.separated(
              shrinkWrap: true,
              itemCount: listItems.length,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: 8,
                );
              },
              itemBuilder: (context, index) {
                return Align(alignment: Alignment.topCenter, child: listItems[index]);
              },
            )
          ],
        ),
      ),
    );
  }
}
