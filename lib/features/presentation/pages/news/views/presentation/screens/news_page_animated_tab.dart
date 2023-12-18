import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smat_crow/features/domain/entities/category_entity.dart';
import 'package:smat_crow/features/domain/entities/user/news_entity.dart';
import 'package:smat_crow/features/presentation/pages/news/views/presentation/widget/news_feeds.dart';
import 'package:smat_crow/features/presentation/provider/news_provider.dart';
import 'package:smat_crow/features/shared/views/loading_shimmer.dart';
import 'package:smat_crow/network/feeds/network/rss_to_json.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/decoration.dart';
import 'package:smat_crow/utils2/spacing_constants.dart';

//news page animated tab bar

class NewsPage extends StatefulWidget {
  final int? index;

  const NewsPage({
    super.key,
    this.index,
  });

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> with TickerProviderStateMixin {
  Map<String, List> newsData = <String, List>{};
  Future<Map<String, List>> getNewsdata([String region = 'agriculture']) async {
    try {
      log(region);
      final tag = region == "agriculture" ? "agriculture" : "agriculture+in+${region.replaceAll("-", "+")}";
      final result = await rssToJson(tag);
      newsData[region] = result;

      return newsData;
    } catch (e) {
      log(e.toString());
    }
    return {};
  }

  late Future future;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    future = getNewsdata();
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    for (int index = SpacingConstants.int0; index < categories.length; index++) {
      newsProvider.keys.add(GlobalKey());
    }
    newsProvider.controller = TabController(vsync: this, length: categories.length);
    newsProvider.controller!.animation!.addListener(
      () {
        newsProvider.handleTabAnimation(context);
      },
    );
    newsProvider.controller!.addListener(
      () {
        newsProvider.handleTabChange(context);
      },
    );

    newsProvider.animationControllerOff = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: SpacingConstants.int75),
    );
    newsProvider.animationControllerOff!.value = SpacingConstants.double1;
    newsProvider.colorTweenBackgroundOff = ColorTween(
      begin: newsProvider.backgroundOn,
      end: newsProvider.backgroundOff,
    ).animate(newsProvider.animationControllerOff!);
    newsProvider.colorTweenForegroundOff = ColorTween(
      begin: newsProvider.foregroundOn,
      end: newsProvider.foregroundOff,
    ).animate(newsProvider.animationControllerOff!);

    newsProvider.animationControllerOn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: SpacingConstants.int150),
    );
    newsProvider.animationControllerOn!.value = SpacingConstants.double1;
    newsProvider.colorTweenBackgroundOn = ColorTween(
      begin: newsProvider.backgroundOff,
      end: newsProvider.backgroundOn,
    ).animate(newsProvider.animationControllerOn!);
    newsProvider.colorTweenForegroundOn = ColorTween(
      begin: newsProvider.foregroundOff,
      end: newsProvider.foregroundOn,
    ).animate(newsProvider.animationControllerOn!);
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Scaffold(
        body: Center(
          child: Text(
            "Coming soon.. Download the mobile app",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
      );
    }
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    if (newsProvider.controller == null) {
      return const LoadingShimmer();
    }

    return Scaffold(
      appBar: AppBar(leading: const SizedBox.shrink(), title: const Text(newsText)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            return NestedScrollView(
              physics: const BouncingScrollPhysics(),
              headerSliverBuilder: (context, value) {
                return [
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: SpacingConstants.size49,
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        controller: newsProvider.scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            key: newsProvider.keys[index],
                            padding: const EdgeInsets.all(SpacingConstants.size6),
                            child: ButtonTheme(
                              child: AnimatedBuilder(
                                animation: newsProvider.colorTweenBackgroundOn,
                                builder: (context, child) => TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: newsProvider.getBackgroundColor(index),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                        SpacingConstants.size7,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    future = getNewsdata(categories[index].imageUrl!);
                                    setState(() {
                                      newsProvider.buttonTap = true;
                                      newsProvider.controller!.animateTo(index);
                                      newsProvider.setCurrentIndex(
                                        index,
                                        context,
                                      );
                                    });
                                  },
                                  child: Text(
                                    '${categories[index].name}',
                                    style: TextStyle(
                                      color: newsProvider.getForegroundColor(index),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ];
              },
              body: TabBarView(
                controller: newsProvider.controller,
                children: List.generate(categories.length, (index) {
                  final category = categories[index];
                  final key = category.imageUrl.toString();
                  if ((snapshot.connectionState == ConnectionState.none ||
                          snapshot.connectionState == ConnectionState.waiting) &&
                      !newsData.containsKey(key)) {
                    return const LoadingShimmer();
                  }

                  return ListView.separated(
                    itemCount: SpacingConstants.int10,
                    separatorBuilder: (context, index) {
                      return customSizedBoxHeight(SpacingConstants.size20);
                    },
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      if (newsData[key] != null) {
                        final data = newsData[key]![i];

                        return NewsFeedCard(
                          newsEntity: NewsEntity(
                            source: data['source'][r"$t"],
                            title: data['title'][r"$t"],
                            url: data['link'][r"$t"],
                            subtitle: Pandora().removeAllHtmlTags(data['description'][r"$t"]).replaceAll('&nbsp;', ' '),
                            time: data['pubDate'][r"$t"],
                          ),
                        );
                      }
                      return const Center(
                        child: Text("feed is empty"),
                      );
                    },
                    padding: DecorationBox.padding25(),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
