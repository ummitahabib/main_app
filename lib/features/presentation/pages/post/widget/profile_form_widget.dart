import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class ProfileFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  const ProfileFormWidget({Key? key, this.title, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title",
          style: const TextStyle(
            color: Colors.amber,
            fontSize: SpacingConstants.size16,
          ),
        ),
        customSizedBoxHeight(SpacingConstants.size10),
        TextFormField(
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            border: InputBorder.none,
            labelStyle: TextStyle(color: AppColors.SmatCrowPrimary500),
          ),
        ),
        Container(
          width: double.infinity,
          height: SpacingConstants.size1,
          color: AppColors.SmatCrowPrimary500,
        )
      ],
    );
  }
}
