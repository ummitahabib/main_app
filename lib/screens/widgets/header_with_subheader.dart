import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/screens/widgets/sub_header_text.dart';

import 'header_text.dart';

class HeaderWithSubHeader extends StatelessWidget {
  final String headerText, subHeaderText;
  final Color headerColor, subHeaderColor;
  final bool canGoBack;
  final bool? hasSubHeader;
  final Function()? press;

  const HeaderWithSubHeader({
    Key? key,
    required this.headerText,
    required this.subHeaderText,
    required this.headerColor,
    required this.subHeaderColor,
    required this.canGoBack,
    this.hasSubHeader,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Visibility(
            visible: canGoBack,
            child: InkWell(
              onTap: press,
              child: Icon(
                EvaIcons.arrowBack,
                color: headerColor,
              ),
            ),
          ),
          const SizedBox(
            height: 14.0,
          ),
          HeaderText(
            text: headerText,
            color: headerColor,
          ),
          const SizedBox(
            height: 10.0,
          ),
          SubHeaderText(text: subHeaderText, color: subHeaderColor)
        ],
      ),
    );
  }
}
