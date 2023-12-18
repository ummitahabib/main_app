import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:smat_crow/utils2/styles.dart';

class SearchWidget extends StatelessWidget {
  final TextEditingController controller;
  const SearchWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: SpacingConstants.size44,
      decoration: BoxDecoration(
        color: AppColors.SmatCrowNeuBlue100,
        borderRadius: BorderRadius.circular(SpacingConstants.size15),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: AppColors.SmatCrowNeuBlue900),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: const Icon(
            EvaIcons.search,
            color: AppColors.SmatCrowNeuBlue500,
          ),
          hintText: searchUserText,
          hintStyle: Styles.smatCrowSubParagraphRegular(
            color: AppColors.SmatCrowNeuBlue500,
          ),
        ),
      ),
    );
  }
}
