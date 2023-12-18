import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils/constants.dart';

import 'farm_probe_list_item.dart';

class FarmProbeMenu extends StatelessWidget {
  const FarmProbeMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldProbeListItem = [];
    const farmMenu = farmProbe;

    if (farmMenu.isEmpty) {
    } else {
      for (final item in farmMenu) {
        fieldProbeListItem.add(FarmProbeListItem(
          route: item["route"],
          image: item["image"],
          text: item["text"],
          background: item["background"],
        ),);
      }
    }

    return ListView.builder(
      itemCount: fieldProbeListItem.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return fieldProbeListItem[index];
      },
    );
  }
}
