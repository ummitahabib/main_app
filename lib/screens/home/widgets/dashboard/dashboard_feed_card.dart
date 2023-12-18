import 'package:flutter/material.dart';
import 'package:inapp_browser/inapp_browser.dart';
import 'package:one_context/one_context.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/colors.dart';

class DashboardFeedCard extends StatelessWidget {
  final source, title, subtitle, time, url;

  const DashboardFeedCard({Key? key, this.source, this.title, this.time, this.subtitle, this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pandora pandora = Pandora();
    return InkWell(
      onTap: () {
        pandora.logAPPButtonClicksEvent('NEWS_FEED_ITEM_CLICKED');
        InappBrowser.showPopUpBrowser(
          context,
          Uri.parse(url),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      source.toString().toUpperCase(),
                      style: const TextStyle(
                        fontFamily: "regular",
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                        color: AppColors.landingOrangeButton,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: "regular",
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.dashGridTextColor,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontFamily: "regular", fontSize: 14, color: AppColors.dashGridTextColor),
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(time,
                        style: const TextStyle(fontFamily: "regular", fontSize: 12, color: AppColors.greyTextLogin)),
                    const SizedBox(
                      height: 7,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadDialogs(Widget widget, double height) {
    OneContext().showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
      ),
      builder: (context) => Container(
        alignment: Alignment.topCenter,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(50.0), topRight: Radius.circular(50.0)),
          color: Colors.white,
        ),
        height: height,
        child: widget,
      ),
    );
  }
}
