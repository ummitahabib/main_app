import 'package:flutter/material.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

//text widget

class TextWidget extends StatefulWidget {
  const TextWidget({Key? key}) : super(key: key);

  @override
  State<TextWidget> createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Text(
        homePageText,
        style: TextStyle(
          fontSize: SpacingConstants.size18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
