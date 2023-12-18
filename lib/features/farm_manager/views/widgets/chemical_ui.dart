import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/features/farm_manager/views/widgets/select_container.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/utils2/constants.dart';

import 'package:smat_crow/utils2/spacing_constants.dart';

class ChemicalUI extends StatelessWidget {
  const ChemicalUI({
    super.key,
    required this.assetLifeSpan,
  });

  final ValueNotifier<Map<String, TextEditingController>> assetLifeSpan;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SelectContainer(
            value: assetLifeSpan.value['start']!.text,
            title: manufactureDaysText,
            hintText: selectDateText,
            function: () async {
              if (FocusScope.of(context).hasFocus) {
                FocusScope.of(context).unfocus();
              }
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2100),
                currentDate: DateTime.now(),
              );
              if (date != null) {
                assetLifeSpan.value['start']!.text = DateFormat("yyyy-MM-dd").format(date);
              }
            },
          ),
        ),
        const Xmargin(SpacingConstants.size10),
        Expanded(
          child: SelectContainer(
            value: assetLifeSpan.value['end']!.text,
            title: expiryDateText,
            hintText: selectDateText,
            function: () async {
              if (FocusScope.of(context).hasFocus) {
                FocusScope.of(context).unfocus();
              }
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2010),
                lastDate: DateTime(2100),
                currentDate: DateTime.now(),
              );
              if (date != null) {
                assetLifeSpan.value['end']!.text = DateFormat("yyyy-MM-dd").format(date);
              }
            },
          ),
        ),
      ],
    );
  }
}
