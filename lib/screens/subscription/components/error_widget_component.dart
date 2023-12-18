import 'package:flutter/material.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/assets/images.dart';
import '../../../utils/strings.dart';
import '../../widgets/square_button.dart';

class ErrorWidgetComponent extends StatelessWidget {
  const ErrorWidgetComponent({Key? key, required this.message, required this.buttonLabel, required this.onTap})
      : super(key: key);

  final String message;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(ImagesAssets.kEmptySub),
          const SizedBox(height: 24),
          Text(
            opps,
            style: const TextStyle(
              color: Color(0xFF644000),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF6E7191),
              fontSize: 14,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 197,
            child: SquareButton(
              backgroundColor: AppColors.landingOrangeButton,
              text: buttonLabel,
              textColor: Colors.white,
              press: onTap,
            ),
          )
        ],
      ),
    );
  }
}
