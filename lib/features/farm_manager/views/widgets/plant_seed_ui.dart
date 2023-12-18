import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/constants.dart';

import 'package:smat_crow/utils2/spacing_constants.dart';

class PlantSeedUI extends StatelessWidget {
  const PlantSeedUI({
    super.key,
    required this.assetCropFamily,
    required this.assetTransplantDays,
    required this.assetMaturityDays,
  });

  final TextEditingController assetCropFamily;
  final TextEditingController assetTransplantDays;
  final TextEditingController assetMaturityDays;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: cropTypeText,
                keyboardType: TextInputType.text,
                controller: assetCropFamily,
                textCapitalization: TextCapitalization.sentences,
                text: cropTypeText,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$cropTypeText $cannotBeEmpty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const Xmargin(SpacingConstants.font10),
            Expanded(
              child: CustomTextField(
                hintText: transplantDaysText,
                keyboardType: TextInputType.number,
                controller: assetTransplantDays,
                textCapitalization: TextCapitalization.sentences,
                text: transplantDaysText,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$transplantDaysText $cannotBeEmpty';
                  }
                  if (int.parse(arg ?? "0") < 1) {
                    return '${transplantDaysText}should be greater than 0';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const Ymargin(SpacingConstants.double20),
        CustomTextField(
          hintText: maturityDaysText,
          keyboardType: TextInputType.number,
          controller: assetMaturityDays,
          textCapitalization: TextCapitalization.sentences,
          text: maturityDaysText,
          validator: (arg) {
            if (isEmpty(arg)) {
              return '$maturityDaysText $cannotBeEmpty';
            }
            if (int.parse(arg ?? "0") < 1) {
              return '${transplantDaysText}should be greater than 0';
            }
            return null;
          },
        )
      ],
    );
  }
}
