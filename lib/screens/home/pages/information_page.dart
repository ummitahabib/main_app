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

class InformationPage extends StatefulWidget {
  final Map<String, List>? newsData;

  const InformationPage({Key? key, this.newsData}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late TabController _tabController;
  int currentIndex = 0;
  String firstName = '', lastName = '', email = '';
  Map<String, List> _newsData = <String, List>{};
  UserDetailsResponse? _userDetailsResponse;
  final AsyncMemoizer _profileAsync = AsyncMemoizer();
  final Pandora _pandora = Pandora();

  @override
  void initState() {
    super.initState();
    getProfileInformation();
    _scrollController = ScrollController();
    _tabController = TabController(length: categories.length, vsync: this);
    _tabController.addListener(_smoothScrollToTop);
    setState(() {
      _newsData = Map.from(widget.newsData!);
    });
  }

  _smoothScrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(microseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
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
                            title: const Text(
                              'News',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 23.0,
                                fontFamily: 'semibold',
                                fontWeight: FontWeight.bold,
                              ),
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
                          labelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 19.0,
                            fontFamily: 'semibold',
                            fontWeight: FontWeight.bold,
                          ),
                          unselectedLabelColor: Colors.black45,
                          unselectedLabelStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontFamily: 'regular',
                            fontWeight: FontWeight.normal,
                          ),
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
                      if (categories[index].imageUrl == null) {
                        return const SizedBox.shrink();
                      }
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
                          if (_newsData[key] != null) {
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
                          }
                          return const Center(
                            child: Text('NO DATA'),
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
      setState(() {
        firstName = _userDetailsResponse!.user!.firstName!;
        email = _userDetailsResponse!.user!.email!;
      });
      return _userDetailsResponse;
    });
  }
}
