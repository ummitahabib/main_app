import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';

class BottomSheetHeaderText extends StatelessWidget {
  const BottomSheetHeaderText({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(fontSize: 18, color: AppColors.SmatCrowNeuBlue900, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
