import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smat_crow/utils/colors.dart';

class CommodityGroupsItem extends StatefulWidget {
  final List<Widget> data;

  final String title;

  const CommodityGroupsItem({Key? key, required this.data, required this.title}) : super(key: key);

  @override
  _CommodityGroupsItemState createState() => _CommodityGroupsItemState();
}

class _CommodityGroupsItemState extends State<CommodityGroupsItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5),
          child: Text(
            widget.title,
            style: GoogleFonts.poppins(
              textStyle: const TextStyle(color: AppColors.blueGreyColor, fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        ListView.separated(
          shrinkWrap: true,
          itemCount: widget.data.length,
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 10,
            );
          },
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return Align(alignment: Alignment.topCenter, child: widget.data[index]);
          },
        ),
      ],
    );
  }
}
