import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.asset,
    required this.name,
  });
  final String asset;
  final String name;

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      child: Container(
        height: SpacingConstants.size36,
        padding: EdgeInsets.symmetric(
          horizontal: SpacingConstants.size15,
          vertical: SpacingConstants.int7.toDouble(),
        ),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpacingConstants.size100),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(asset),
            const SizedBox(width: SpacingConstants.size5),
            Text(
              name,
              style: Styles.smatCrowSubParagraphRegular(
                color: AppColors.SmatCrowNeuBlue900,
              ),
            )
          ],
        ),
      ),
    );
  }
}
