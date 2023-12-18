import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/responsive.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

Future<dynamic> customModalSheet(BuildContext context, Widget child) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(SpacingConstants.size20),
        topRight: Radius.circular(SpacingConstants.size20),
      ),
    ),
    builder: (context) => child,
  );
}

Future<dynamic> customDialog(BuildContext context, Widget child) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      contentPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SpacingConstants.size16),
      ),
      content: SizedBox(width: SpacingConstants.size510, child: child),
    ),
  );
}

Future<dynamic> customDialogAndModal(BuildContext context, Widget child, [bool isDialog = false]) {
  if (Responsive.isDesktop(context) || isDialog) {
    return customDialog(context, child);
  }
  return customModalSheet(context, child);
}
