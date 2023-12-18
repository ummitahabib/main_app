import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/styles.dart';

class RecentlyViewedPlants extends StatefulWidget {
  const RecentlyViewedPlants({Key? key}) : super(key: key);

  @override
  _RecentlyViewedPlantsState createState() => _RecentlyViewedPlantsState();
}

class _RecentlyViewedPlantsState extends State<RecentlyViewedPlants> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text('Recently Viewed',
                  style: GoogleFonts.poppins(
                    textStyle: Styles.textStyleBlueGrey(),
                  ),),
            ),
            const Spacer(),
            Styles.moreHorizOutlined()
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                color: Colors.white,
                elevation: 1,
                shadowColor: Colors.black.withOpacity(0.6),
                child: SizedBox(
                  width: 210,
                  height: 80,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
                            fit: BoxFit.cover,
                            height: 80,
                            width: 60,
                          ),),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Solanum lycopersicum',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: GoogleFonts.poppins(
                                  textStyle: Styles.textStyleBlueGreySm(),
                                ),),
                            Text('tomato',
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                                style: GoogleFonts.poppins(
                                  textStyle: Styles.textStyleBlueGreyMd(),
                                ),)
                          ],
                        ),
                      ),)
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
