import 'package:beamer/beamer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

AppBar customAppBar(
  BuildContext context, {
  String title = emptyString,
  bool center = kIsWeb ? false : true,
  List<Widget>? actions,
  Widget? leading,
  VoidCallback? onTap,
}) {
  return AppBar(
    leading: leading ??
        InkWell(
          onTap: onTap ??
              () {
                if (kIsWeb) {
                  context.beamBack();
                } else {
                  Navigator.pop(context);
                }
              },
          child: const Icon(
            Icons.keyboard_arrow_left,
            size: SpacingConstants.size30,
          ),
        ),
    title: Text(title),
    centerTitle: center,
    actions: actions,
  );
}
