import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils/constants.dart';

import 'field_agent_grid_item.dart';

class FieldAgentGridMenu extends StatelessWidget {
  const FieldAgentGridMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> fieldAgentGridItem = [];

    if (fieldAgentTools.isNotEmpty) {
      for (final item in fieldAgentTools) {
        fieldAgentGridItem.add(
          FieldAgentGridItem(
            route: item["route"],
            image: item["image"],
            text: item["text"],
            background: item["background"],
          ),
        );
      }
    }

    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: MediaQuery.of(context).size.width * 0.00250,
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      children: fieldAgentGridItem,
    );
  }
}
