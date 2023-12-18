import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/utils/session.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../pandora/pandora.dart';
import '../../../../utils/strings.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';
import '../../widgets/farm_management_log_type_item.dart';

class FarmManagementLogTypesMenu extends StatefulWidget {
  final FarmManagementTypeManagementArgs siteArgs;

  const FarmManagementLogTypesMenu({Key? key, required this.siteArgs}) : super(key: key);

  @override
  _FarmManagementLogTypesMenuState createState() {
    return _FarmManagementLogTypesMenuState();
  }
}

class _FarmManagementLogTypesMenuState extends State<FarmManagementLogTypesMenu> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer _logsTypesAsync = AsyncMemoizer();
  final Pandora pandora = Pandora();
  List<Widget> farmLogTypeItem = [];

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
    return EnhancedFutureBuilder(
      future: getFarmManagementLogTypes(),
      rememberFutureResult: true,
      whenDone: (obj) => _showResponse(),
      whenError: (error) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(unableToFetchLog),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getFarmManagementLogTypes() async {
    return _logsTypesAsync.runOnce(() async {
      final data = await getLogTypes();

      List<Widget> logTypeList = [];
      if (data == null || data.data!.isEmpty) {
        logTypeList.add(EmptyListItem(message: logNotCreated));
      } else {
        for (final logType in data.data!) {
          logTypeList.add(FarmManagementLogTypeItem(logType: logType, siteArgs: widget.siteArgs, pandora: pandora));
        }
      }

      if (mounted) {
        setState(() {
          farmLogTypeItem = logTypeList;
        });
      }
    });
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmLogTypeItem.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmLogTypeItem[index]);
      },
    );
  }
}
