import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class CustomModalItem {
  final IconData? icon;
  final String text;
  final Function? onTap;

  CustomModalItem({
    this.icon,
    required this.text,
    this.onTap,
  });
}

class ReusableModal extends StatelessWidget {
  final double width;
  final double height;
  final Color backgroundColor;
  final List<CustomModalItem> items;
  final Color? color;

  const ReusableModal({
    Key? key,
    this.width = SpacingConstants.double130,
    this.height = SpacingConstants.size90,
    this.backgroundColor = AppColors.SmatCrowDefaultWhite,
    this.color,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: SpacingConstants.double0,
      child: Padding(
        padding: const EdgeInsets.only(
          top: SpacingConstants.size24,
          bottom: SpacingConstants.size24,
        ),
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.symmetric(
            vertical: SpacingConstants.size16,
            horizontal: SpacingConstants.size18,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SpacingConstants.size8),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(
                  SpacingConstants.int0,
                  SpacingConstants.int0,
                  SpacingConstants.int0,
                  SpacingConstants.size07,
                ),
                blurRadius: SpacingConstants.size18,
                offset: Offset(SpacingConstants.size0, SpacingConstants.size12),
              ),
            ],
            color: backgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) {
              return GestureDetector(
                onTap: () {
                  item.onTap!();
                },
                child: Row(
                  children: [
                    Icon(
                      item.icon,
                      size: SpacingConstants.double24,
                      color: color ?? AppColors.SmatCrowBlue500,
                    ),
                    const SizedBox(
                      width: SpacingConstants.size8,
                    ),
                    Text(
                      item.text,
                      style: Styles.smatCrowParagraphRegular(
                        color: AppColors.SmatCrowNeuBlue900,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
