import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:one_context/one_context.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../utils/styles.dart';
import '../fieldagents_providers/promo_carasoul_provider.dart';

class PromosCarousel extends StatefulWidget {
  const PromosCarousel({Key? key}) : super(key: key);

  @override
  _PromosCarouselState createState() => _PromosCarouselState();
}

class _PromosCarouselState extends State<PromosCarousel> {
  final int _current = 0;
  final Pandora _pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            selectContactType();
          },
          child: CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 1.6,
              viewportFraction: 1,
              autoPlayInterval: const Duration(seconds: 10),
              scrollPhysics: const BouncingScrollPhysics(),
              onPageChanged: (index, reason) {
                Provider.of<PromoCarouselProvider>(context, listen: false)
                    .setCurrent(index);
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.map((url) {
            final int index = imgList.indexOf(url);
            return Container(
              width: 14.0,
              height: 3.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: _current == index
                    ? AppColors.landingOrangeButton
                    : AppColors.shadowColor,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  final List<Widget> imageSliders = imgList
      .map(
        (item) => Container(
          child: Container(
            margin: const EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
              child: Stack(
                children: <Widget>[
                  Image.network(item.urlLink, fit: BoxFit.cover, width: 1000.0),
                  Positioned(
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(200, 0, 0, 0),
                            Color.fromARGB(0, 0, 0, 0)
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 20.0,
                      ),
                      child: Text(
                        '', //'No. ${imgList.indexOf(item)} image',
                        style: Styles.whiteBoldMx(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
      .toList();

  Future selectContactType() {
    return OneContext().showModalBottomSheet(
      builder: (context) {
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 120,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 150.0,
                ),
                child: Divider(
                  thickness: 4.0,
                  color: Colors.black,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextButton(
                          onPressed: () {
                            launch("tel://${ContactConfig.ContactPhone}");
                          },
                          child: Text(
                            'Call Phone',
                            style: GoogleFonts.poppins(
                              textStyle: Styles.defaultStyleBlackMd(),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: TextButton(
                          onPressed: () {
                            _pandora.composeEmail();
                          },
                          child: Text(
                            'Send Mail',
                            style: GoogleFonts.poppins(
                              textStyle: Styles.defaultStyleBlackMd(),
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
