import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/assets.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class EmptyListWidget extends StatelessWidget {
  const EmptyListWidget({
    super.key,
    required this.text,
    this.asset = AppAssets.noGps,
  });
  final String text;
  final String asset;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (asset.split(".").last == "svg") SvgPicture.asset(asset) else Image.asset(asset),
          Text(
            text,
            style: Styles.smatCrowParagraphRegular(color: Colors.black),
          ),
          const Ymargin(SpacingConstants.double20)
        ],
      ),
    );
  }
}
