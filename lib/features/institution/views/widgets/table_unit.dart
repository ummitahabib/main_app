import 'package:flutter/material.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/color_600_text.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class TableUnit extends StatelessWidget {
  const TableUnit({
    super.key,
    required this.text,
    required this.onTap,
  });

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpacingConstants.double20, vertical: SpacingConstants.font10),
        child: Color600Text(
          text: text,
        ),
      ),
    );
  }
}
