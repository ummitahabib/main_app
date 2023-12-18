import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';

import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class EquipmentSensorUI extends StatelessWidget {
  const EquipmentSensorUI({
    super.key,
    required this.assetSerialNumber,
    required this.assetManufacturer,
    required this.assetModel,
  });

  final TextEditingController assetSerialNumber;
  final TextEditingController assetManufacturer;
  final TextEditingController assetModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextField(
                hintText: serialNumberText,
                keyboardType: TextInputType.text,
                controller: assetSerialNumber,
                textCapitalization: TextCapitalization.characters,
                text: serialNumberText,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$serialNumberText $cannotBeEmpty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            const Xmargin(SpacingConstants.font10),
            Expanded(
              child: CustomTextField(
                hintText: supplierNmanufacturerText,
                keyboardType: TextInputType.text,
                controller: assetManufacturer,
                textCapitalization: TextCapitalization.characters,
                text: supplierNmanufacturerText,
                validator: (arg) {
                  if (isEmpty(arg)) {
                    return '$supplierNmanufacturerText $cannotBeEmpty';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
        const Ymargin(SpacingConstants.double20),
        CustomTextField(
          hintText: modelText,
          keyboardType: TextInputType.text,
          controller: assetModel,
          textCapitalization: TextCapitalization.characters,
          text: modelText,
          validator: (arg) {
            if (isEmpty(arg)) {
              return '$modelText $cannotBeEmpty';
            } else {
              return null;
            }
          },
        )
      ],
    );
  }
}
