import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smat_crow/screens/farmtools/widgets/farm_measurement_list_item.dart';
import 'package:smat_crow/utils/constants.dart';

class FarmMeasurementsMenu extends StatelessWidget {
  final String size;

  const FarmMeasurementsMenu({
    Key? key,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldAgentListItem = [];
    const farmMenu = farmMeasurements;

    if (farmMenu.isEmpty) {
    } else {
      for (final item in farmMenu) {
        fieldAgentListItem.add(
          FarmMeasurementListItem(
            route: item["route"],
            image: item["image"],
            text:
                '${calculateAlternativeValues(item["route"], size)} ${item["text"]}',
            background: item["background"],
          ),
        );
      }
    }

    return ListView.builder(
      itemCount: fieldAgentListItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return fieldAgentListItem[index];
      },
    );
  }

  String calculateAlternativeValues(String route, String stringAsPrecision) {
    final NumberFormat numberFormat = NumberFormat('#,##0.00', 'en_US');
    String calculatedValue = '';
    final convertedValue = double.parse(stringAsPrecision);
    switch (route) {
      case '/metres':
        calculatedValue = numberFormat.format(convertedValue);
        break;
      case '/feet':
        calculatedValue = numberFormat.format(convertedValue * 10.7639);
        break;
      case '/plots':
        calculatedValue = numberFormat.format(convertedValue / 600);
        break;
      case '/acres':
        calculatedValue = numberFormat.format(convertedValue * 0.000247105);
        break;
      case '/hectares':
        calculatedValue = numberFormat.format(convertedValue * 0.0001);
        break;
    }
    return calculatedValue; //;
  }
}
