import 'package:flutter/cupertino.dart';

class EditProfileHeader extends StatelessWidget {
  final String text;
  final Color? color;

  const EditProfileHeader({Key? key, required this.text, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(color: color, fontSize: 16.0, fontWeight: FontWeight.w700, fontFamily: 'regular'),);
  }
}
