import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/farm_management/assets/generic_log_response.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/list_loader.dart';
import 'farm_management_logs_list_page.dart';

class FarmManagementSiteLogsListTabs extends StatefulWidget {
  final FarmManagerSiteManagementArgs siteArgs;
  final String logType, assetType;

  const FarmManagementSiteLogsListTabs({
    Key? key,
    required this.siteArgs,
    required this.logType,
    required this.assetType,
  }) : super(key: key);

  @override
  _FarmManagementSiteLogsListTabsState createState() {
    return _FarmManagementSiteLogsListTabsState();
  }
}

class _FarmManagementSiteLogsListTabsState
    extends State<FarmManagementSiteLogsListTabs>
    with SingleTickerProviderStateMixin {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  late GetLogsResponse siteLogs;
  late TabController _tabController;
  List<Completed> allLogs = [];
  List<Completed> upcoming = [];
  List<Completed> ongoing = [];
  List<Completed> missed = [];
  List<Completed> completed = [];
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    getSiteLogs(widget.siteArgs.siteId);
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: getSiteLogs(widget.siteArgs.siteId),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load logs data"),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getSiteLogs(String siteId) async {
    return _asyncMemoizer.runOnce(() async {
      GetLogsResponse? data;
      if (widget.logType != "ALL") {
        if (widget.assetType == "ALL") {
          data = await getLogsInSiteByType(siteId, widget.logType);
        } else {
          data = await getLogsInAssetBySiteAndType(
              UnsafeIds.assetId, siteId, widget.logType);
        }
      } else {
        data = await getLogsInSite(siteId);
      }

      setState(() {
        siteLogs = data!;
        upcoming.addAll(siteLogs.data.upcoming);
        ongoing.addAll(siteLogs.data.ongoing);
        missed.addAll(siteLogs.data.missed);
        completed.addAll(siteLogs.data.completed);
        allLogs.addAll(upcoming);
        allLogs.addAll(ongoing);
        allLogs.addAll(missed);
        allLogs.addAll(completed);
      });
      allLogs.sort((a, b) => a.createdDate!.compareTo(b.createdDate!));
      return data;
    });
  }

  Widget _showResponse() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.all(1),
          elevation: 0.2,
          color: AppColors.offWhite,
          child: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: const BoxDecoration(
              color: AppColors.farmManagerTabColor,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            isScrollable: true,
            labelPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 12,
            ),
            physics: const BouncingScrollPhysics(),
            unselectedLabelStyle: Styles.defaultStyle16(),
            labelStyle: Styles.regularBold(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: "Upcoming"),
              Tab(text: "Ongoing"),
              Tab(text: "Missed"),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            physics: const BouncingScrollPhysics(),
            children: [
              FarmManagerLogListPage(allLogs, widget.siteArgs),
              FarmManagerLogListPage(upcoming, widget.siteArgs),
              FarmManagerLogListPage(ongoing, widget.siteArgs),
              FarmManagerLogListPage(missed, widget.siteArgs),
              FarmManagerLogListPage(completed, widget.siteArgs),
            ],
          ),
        ),
      ],
    );
  }
}
