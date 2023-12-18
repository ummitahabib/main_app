import 'package:flutter/material.dart';
import 'package:smat_crow/utils/colors.dart';

import '../../../utils/assets/images.dart';

class TodoWidget extends StatelessWidget {
  final String text;
  final bool isDone;

  const TodoWidget({super.key, required this.text, required this.isDone});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
        vertical: 8.0,
      ),
      child: Row(
        children: [
          Container(
            width: 20.0,
            height: 20.0,
            margin: const EdgeInsets.only(
              right: 12.0,
            ),
            decoration: BoxDecoration(
              color: isDone ? AppColors.landingOrangeButton : Colors.transparent,
              borderRadius: BorderRadius.circular(6.0),
              border: isDone ? null : Border.all(color: AppColors.landingOrangeButton, width: 1.5),
            ),
            child: const Image(
              image: AssetImage(
                ImagesAssets.kCheckIcon,
              ),
            ),
          ),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: isDone ? AppColors.landingOrangeButton : const Color(0xFF86829D),
                fontSize: 16.0,
                fontWeight: isDone ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
