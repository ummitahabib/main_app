// ignore_for_file: library_private_types_in_public_api, prefer_null_aware_method_calls

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/features/presentation/widgets/alert_body.dart';
import 'package:smat_crow/features/presentation/widgets/alert_header.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

class CustomAlertDialog extends StatefulWidget {
  const CustomAlertDialog({
    Key? key,
    required this.alertBodyTitle,
    required this.alertBodyDescription,
    this.alertbodyDescriptionColor,
    this.alertBodyIconColor,
    this.alertIconColorFirst,
    this.alertHeaderText,
    this.alertHeaderfirstIcon,
    this.alertHeadersecondIcon,
    this.alertBodyIcon,
    this.rightbuttonText,
    this.leftbuttonText,
    this.onPressedFirstbutton,
    this.onPressedSecondbutton,
    this.alertBodyDescriptionColor,
    this.alertIconColorSecond,
    this.alertbodytitleColor,
    this.alertHeaderBackgroundcolor,
  }) : super(key: key);

  final String? alertBodyTitle;
  final String? alertBodyDescription;
  final Color? alertbodyDescriptionColor;
  final Color? alertBodyIconColor;
  final Color? alertIconColorFirst;
  final Color? alertIconColorSecond;
  final Color? alertBodyDescriptionColor;
  final String? alertHeaderText;
  final Icon? alertHeaderfirstIcon;
  final Icon? alertHeadersecondIcon;
  final Icon? alertBodyIcon;
  final String? rightbuttonText;
  final String? leftbuttonText;
  final void Function()? onPressedFirstbutton;
  final void Function()? onPressedSecondbutton;
  final Color? alertbodytitleColor;
  final Color? alertHeaderBackgroundcolor;

  @override
  _CustomAlertDialogState createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {
  bool showDialog = true;

  @override
  Widget build(BuildContext context) {
    final isTabletOrDesktop = MediaQuery.of(context).size.width >= SpacingConstants.size600;

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(
          SpacingConstants.double0,
          showDialog ? SpacingConstants.double1 : SpacingConstants.double0,
        ),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOut)).animate(
            CurvedAnimation(
              parent: ModalRoute.of(context)!.animation!,
              curve: const Interval(
                SpacingConstants.double0,
                SpacingConstants.double1,
              ),
            ),
          ),
      child: Column(
        mainAxisAlignment: isTabletOrDesktop ? MainAxisAlignment.center : MainAxisAlignment.end,
        children: [
          AlertHeader(
            alertHeaderText: widget.alertHeaderText ?? userNotFound,
            alertHeaderfirstIcon: widget.alertHeaderfirstIcon ?? const Icon(EvaIcons.info),
            alertHeadersecondIcon: widget.alertHeadersecondIcon ?? const Icon(EvaIcons.info),
            alertIconColorFirst: widget.alertIconColorFirst,
            alertIconColorSecond: widget.alertIconColorFirst,
            alertHeaderBackgroundcolor: widget.alertHeaderBackgroundcolor,
          ),
          const SizedBox(
            height: SpacingConstants.size37,
          ),
          Container(
            width: SpacingConstants.size390,
            height: SpacingConstants.size380,
            padding: const EdgeInsets.only(bottom: SpacingConstants.size30),
            decoration: DecorationBox.customDecorationDesktopTablet(context),
            child: AlertBody(
              alertBodyIcon: widget.alertBodyIcon,
              alertBodyTitle: widget.alertBodyTitle,
              alertBodyDescription: widget.alertBodyDescription ?? descriptionText,
              alertbodyDescriptionColor: widget.alertbodyDescriptionColor ?? AppColors.SmatCrowNeuBlue900,
              alertbodytitleColor: widget.alertbodytitleColor,
              alertBodyIconColor: widget.alertBodyIconColor,
              onPressedFirstbutton: onPressedFirstButton,
              onPressedSecondbutton: onPressedSecondButton,
              rightbuttonText: widget.rightbuttonText,
              leftbuttonText: widget.leftbuttonText,
            ),
          ),
        ],
      ),
    );
  }

  void onPressedFirstButton() {
    if (widget.onPressedFirstbutton != null) {
      widget.onPressedFirstbutton!();
    }
    _dismissDialog();
  }

  void onPressedSecondButton() {
    if (widget.onPressedSecondbutton != null) {
      widget.onPressedSecondbutton!();
    }
    _dismissDialog();
  }

  void _dismissDialog() {
    setState(() {
      showDialog = false;
    });
    Navigator.of(context).pop();
  }
}

void showErrorDialog({
  String? rightbuttonText,
  String? messageType,
  String alertHeaderText = notice,
  void Function()? onPressedSecondbutton,
  void Function()? onPressedFirstbutton,
  String? alertBodyDescription,
  String? leftbuttonText,
}) {
  switch (messageType) {
    case success:
      _displayErrorDialog(
        alertBodyTitle: successfull,
        alertBodyDescription: alertBodyDescription,
        alertHeaderfirstIcon: const Icon(EvaIcons.checkmarkCircle2Outline),
        alertHeadersecondIcon: const Icon(EvaIcons.closeCircleOutline),
        alertHeaderText: alertHeaderText,
        alertBodyIcon: const Icon(EvaIcons.checkmarkCircle2Outline),
        rightbuttonText: rightbuttonText,
        alertBodyIconColor: AppColors.SmatCrowGreen500,
        onPressedSecondbutton: onPressedSecondbutton,
        alertIconColorFirst: AppColors.SmatCrowGreen500,
        alertIconColorSecond: AppColors.SmatCrowNeuBlue500,
        alertbodytitleColor: AppColors.SmatCrowGreen500,
        alertHeaderBackgroundcolor: AppColors.SmatCrowGreen50,
        alertBodyDescriptionColor: AppColors.SmatCrowNeuBlue900,
        alertbodyDescriptionColor: AppColors.SmatCrowNeuBlue900,
        onPressedFirstbutton: onPressedFirstbutton,
        leftbuttonText: leftbuttonText,
      );
      break;
    case failed:
      _displayErrorDialog(
        alertBodyTitle: errorOccured,
        alertBodyDescription: alertBodyDescription,
        alertHeaderfirstIcon: const Icon(EvaIcons.checkmarkCircle2Outline),
        alertHeadersecondIcon: const Icon(EvaIcons.closeCircleOutline),
        alertHeaderText: alertHeaderText,
        alertBodyIcon: const Icon(EvaIcons.closeCircleOutline),
        alertBodyIconColor: AppColors.SmatCrowRed500,
        rightbuttonText: rightbuttonText,
        leftbuttonText: leftbuttonText,
        alertIconColorFirst: AppColors.SmatCrowRed500,
        alertIconColorSecond: AppColors.SmatCrowNeuBlue500,
        alertbodytitleColor: AppColors.SmatCrowRed500,
        alertHeaderBackgroundcolor: AppColors.SmatCrowRed50,
        alertBodyDescriptionColor: AppColors.SmatCrowNeuBlue900,
        onPressedFirstbutton: onPressedFirstbutton,
        onPressedSecondbutton: onPressedSecondbutton,
        alertbodyDescriptionColor: AppColors.SmatCrowNeuBlue900,
      );

      break;
    case warningCase:
      _displayErrorDialog(
        alertBodyTitle: warningText,
        alertBodyDescription: alertBodyDescription,
        alertHeaderfirstIcon: const Icon(EvaIcons.checkmarkCircle2Outline),
        alertHeadersecondIcon: const Icon(EvaIcons.closeCircleOutline),
        alertHeaderText: alertHeaderText,
        alertBodyIcon: const Icon(EvaIcons.checkmarkCircle2Outline),
        alertBodyIconColor: AppColors.SmatCrowPrimary500,
        rightbuttonText: rightbuttonText,
        onPressedSecondbutton: onPressedSecondbutton,
        alertIconColorFirst: AppColors.SmatCrowPrimary500,
        alertIconColorSecond: AppColors.SmatCrowNeuBlue500,
        alertHeaderBackgroundcolor: AppColors.SmatCrowPrimary50,
        alertbodytitleColor: AppColors.SmatCrowPrimary500,
        alertBodyDescriptionColor: AppColors.SmatCrowNeuBlue500,
        leftbuttonText: leftbuttonText,
        onPressedFirstbutton: onPressedFirstbutton,
        alertbodyDescriptionColor: AppColors.SmatCrowNeuBlue500,
      );
      break;
  }
}

void _displayErrorDialog({
  String? alertBodyTitle,
  String? alertBodyDescription,
  Color? alertBodyDescriptionColor,
  Color? alertBodyIconColor,
  required Icon alertHeaderfirstIcon,
  required Icon alertHeadersecondIcon,
  required String alertHeaderText,
  required Icon alertBodyIcon,
  String? rightbuttonText,
  String? leftbuttonText,
  void Function()? onPressedFirstbutton,
  void Function()? onPressedSecondbutton,
  Color? alertIconColorFirst,
  Color? alertIconColorSecond,
  Color? alertbodytitleColor,
  Color? alertHeaderBackgroundcolor,
  Color? alertbodyDescriptionColor,
}) {
  OneContext().showDialog(
    barrierDismissible: false,
    builder: (BuildContext context) {
      return CustomAlertDialog(
        alertHeaderBackgroundcolor: alertHeaderBackgroundcolor,
        alertbodyDescriptionColor: alertbodyDescriptionColor,
        alertBodyTitle: alertBodyTitle,
        alertBodyDescription: alertBodyDescription,
        alertBodyDescriptionColor: alertBodyDescriptionColor,
        alertBodyIconColor: alertBodyIconColor,
        alertHeaderfirstIcon: alertHeaderfirstIcon,
        alertHeadersecondIcon: alertHeadersecondIcon,
        alertHeaderText: alertHeaderText,
        alertBodyIcon: alertBodyIcon,
        rightbuttonText: rightbuttonText,
        leftbuttonText: leftbuttonText,
        onPressedFirstbutton: onPressedFirstbutton,
        onPressedSecondbutton: onPressedSecondbutton,
        alertIconColorFirst: alertIconColorFirst,
        alertIconColorSecond: alertIconColorFirst,
        alertbodytitleColor: alertbodytitleColor,
      );
    },
  );
}
