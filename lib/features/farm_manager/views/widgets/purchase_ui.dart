import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/strings.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/features/widgets/custom_text_field.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class PurchaseUI extends HookConsumerWidget {
  const PurchaseUI({
    super.key,
    required this.logQuantity,
    required this.logSupplier,
    required this.cost,
  });

  final TextEditingController logQuantity;
  final TextEditingController logSupplier;
  final TextEditingController cost;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const Xmargin(SpacingConstants.font10),
        CustomTextField(
          hintText: supplierText,
          text: supplierText,
          controller: logSupplier,
          validator: (arg) {
            if (isEmpty(arg)) {
              return '$supplierText $cannotBeEmpty';
            } else {
              return null;
            }
          },
          keyboardType: TextInputType.text,
        ),
        const Ymargin(SpacingConstants.double20),
        CustomTextField(
          hintText: costText,
          text: costText,
          controller: cost,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CurrencyTextInputFormatter(name: ""),
          ],
          keyboardType: TextInputType.number,
          validator: (arg) {
            if (isEmpty(arg)) {
              return '$costText $cannotBeEmpty';
            } else {
              return null;
            }
          },
        )
      ],
    );
  }
}
