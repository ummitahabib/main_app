import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:inapp_browser/inapp_browser.dart';
import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
import 'package:smat_crow/features/shared/views/spacing_utils.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';
import 'package:url_launcher/url_launcher.dart';

//news feed

class NewsFeedCard extends StatefulWidget {
  final NewsEntity newsEntity;

  const NewsFeedCard({
    Key? key,
    required this.newsEntity,
  }) : super(key: key);

  @override
  _NewsFeedCardState createState() => _NewsFeedCardState();
}

class _NewsFeedCardState extends State<NewsFeedCard> {
  final Pandora pandora = Pandora();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        pandora.logAPPButtonClicksEvent('NEWS_FEED_ITEM_CLICKED');
        if (kIsWeb) {
          launchUrl(Uri.parse(widget.newsEntity.url ?? noUrl));
        } else {
          InappBrowser.showPopUpBrowser(
            context,
            Uri.parse(widget.newsEntity.url ?? noUrl),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: SpacingConstants.size10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Container(
                //   width: SpacingConstants.size72,
                //   height: SpacingConstants.size72,
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(SpacingConstants.size12),
                //     color: AppColors.SmatCrowPrimary200,
                //   ),
                //   child: CachedNetworkImage(
                //     imageUrl: widget.newsEntity.url ?? DEFAULT_IMAGE,
                //     errorWidget: (context, error, stackTrace) => CachedNetworkImage(imageUrl: DEFAULT_IMAGE),
                //   ),
                // ),
                // const SizedBox(
                //   width: SpacingConstants.size11,
                // ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.newsEntity.source.toString().toUpperCase(),
                        style: DecorationBox.newsSourceTextStyle(),
                      ),
                      Text(
                        widget.newsEntity.title ?? emptyString,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: DecorationBox.newsTitleTextStyle(),
                      ),
                      const Ymargin(SpacingConstants.font10),
                      Text(
                        widget.newsEntity.time ?? "",
                        style: DecorationBox.newsTitleTextStyle(),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
