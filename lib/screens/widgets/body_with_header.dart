import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BodyWithHeader extends StatefulWidget {
  final String header;
  final Widget listBody;

  const BodyWithHeader({
    Key? key,
    required this.header,
    required this.listBody,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BodyWithHeaderState();
  }
}

class _BodyWithHeaderState extends State<BodyWithHeader> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        right: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10, left: 5),
            child: Text(widget.header,
                style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.black, fontSize: 20)),),
          ),
          widget.listBody,
        ],
      ),
    );
  }
}
