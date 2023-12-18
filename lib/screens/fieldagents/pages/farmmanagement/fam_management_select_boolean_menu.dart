import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../utils/styles.dart';

class FarmManagementSelectBooleanMenu extends StatefulWidget {
  final Function(bool) selectedOption;

  const FarmManagementSelectBooleanMenu({Key? key, required this.selectedOption}) : super(key: key);

  @override
  _FarmManagementSelectBooleanMenuState createState() {
    return _FarmManagementSelectBooleanMenuState();
  }
}

class _FarmManagementSelectBooleanMenuState extends State<FarmManagementSelectBooleanMenu> {
  List<Widget> booleanItem = [];

  @override
  void initState() {
    super.initState();
    booleanItem.add(
      InkWell(
        onTap: () {
          widget.selectedOption(true);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              const Icon(
                EvaIcons.checkmarkSquare2Outline,
                size: 25,
              ),
              const SizedBox(
                width: 15,
              ),
              Text("Yes", overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
            ],
          ),
        ),
      ),
    );
    booleanItem.add(
      InkWell(
        onTap: () {
          widget.selectedOption(false);
          Navigator.pop(context);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(
            children: [
              const Icon(
                EvaIcons.checkmarkSquare2Outline,
                size: 25,
              ),
              const SizedBox(
                width: 15,
              ),
              Text("No", overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _showResponse();
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: booleanItem.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: booleanItem[index]);
      },
    );
  }
}
