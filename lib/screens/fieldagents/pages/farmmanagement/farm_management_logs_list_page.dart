import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/models/farm_management/assets/generic_log_response.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../widgets/empty_list_item.dart';
import '../../widgets/farm_logs_item.dart';

class FarmManagerLogListPage extends StatefulWidget {
  final List<Completed> logList;
  final FarmManagerSiteManagementArgs siteArgs;

  const FarmManagerLogListPage(this.logList, this.siteArgs, {Key? key}) : super(key: key);

  @override
  _FarmManagerLogListPageState createState() {
    return _FarmManagerLogListPageState();
  }
}

class _FarmManagerLogListPageState extends State<FarmManagerLogListPage> {
  List<Widget> farmLogItem = [];

  @override
  void initState() {
    super.initState();
    setFarmLogItems(widget.logList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmLogItem.length,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmLogItem[index]);
      },
    );
  }

  void setFarmLogItems(List<Completed> logList) {
    List<Widget> logList0 = [];

    if (logList.isEmpty) {
      logList0.add(const EmptyListItem(message: 'You do not have any Logs'));
    } else {
      for (final log in logList) {
        logList0.add(
          FarmLogsItem(
            log: log,
            siteArgs: widget.siteArgs,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        farmLogItem = logList0;
      });
    }
  }
}
