import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/user_response.dart';
import 'package:smat_crow/network/crow/user_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/screens/farmmanager/widgets/loader_tile.dart';
import 'package:smat_crow/screens/home/widgets/dashboard/dashboard_feed_card.dart';
import 'package:smat_crow/utils/colors.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/constants.dart';

import '../../../utils/styles.dart';

class InfoPageProvider extends ChangeNotifier {
  final ScrollController _scrollController = ScrollController();
  TabController? _tabController;
  int currentIndex = 0;
  String firstName = emptyString, lastName = emptyString, email = emptyString;
  final Map<String, List> _newsData = <String, List>{};
  UserDetailsResponse? _userDetailsResponse;
  final AsyncMemoizer _profileAsync = AsyncMemoizer();
  final Pandora _pandora = Pandora();

  Widget _showLoader() {
    return const Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 40),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: 25,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
            SizedBox(
              height: 16,
            ),
            LoaderTileLarge(),
          ],
        ),
      ),
    );
  }

  Widget infoPageContainer() {
    return Container(
      child: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.none || snapshot.connectionState == ConnectionState.waiting) {
            return _showLoader();
          }
          return Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
              ),
              NestedScrollView(
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                headerSliverBuilder: (context, value) {
                  return [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          AppBar(
                            elevation: 0.1,
                            backgroundColor: AppColors.whiteColor,
                            leadingWidth: 0.0,
                            leading: Container(),
                            title: Text(
                              'News',
                              overflow: TextOverflow.fade,
                              style: Styles.defaultStyleBlackSemiBold(),
                            ),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                            ),
                          ),
                          Container(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.only(left: 25),
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          labelPadding: const EdgeInsets.only(right: 15),
                          indicatorSize: TabBarIndicatorSize.label,
                          controller: _tabController,
                          isScrollable: true,
                          indicator: const UnderlineTabIndicator(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          labelColor: Colors.black,
                          labelStyle: Styles.labelStyleblackBold(),
                          unselectedLabelColor: Colors.black45,
                          unselectedLabelStyle: Styles.unselectedLabelStyle(),
                          tabs: List.generate(
                            categories.length,
                            (index) => Text(categories[index].name ?? ""),
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: Container(
                  child: TabBarView(
                    controller: _tabController,
                    children: List.generate(categories.length, (index) {
                      final key = categories[index].imageUrl.toString();
                      return ListView.separated(
                        itemCount: 10,
                        separatorBuilder: (context, index) {
                          return const Divider(
                            color: AppColors.dividerColor,
                            height: 1,
                          );
                        },
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          if (_newsData[key] == null) {
                            return Container();
                          }
                          return DashboardFeedCard(
                            title: _newsData[key]![i]['title'][r"$t"],
                            subtitle: _pandora
                                .removeAllHtmlTags(
                                  _newsData[key]![i]['description'][r"$t"],
                                )
                                .replaceAll('&nbsp;', ' '),
                            time: _newsData[key]![i]['pubDate'][r"$t"],
                            source: _newsData[key]![i]['source'][r"$t"],
                            url: _newsData[key]![i]['link'][r"$t"],
                          );
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                      );
                    }),
                  ),
                ),
              )
            ],
          );
        },
        future: getProfileInformation(),
      ),
    );
  }

  Future getProfileInformation() async {
    return _profileAsync.runOnce(() async {
      _userDetailsResponse = await getUserDetails();
      Session.userDetailsResponse = _userDetailsResponse;
      firstName = _userDetailsResponse!.user!.firstName!;
      email = _userDetailsResponse!.user!.email!;
      notifyListeners();
      return _userDetailsResponse;
    });
  }
}
