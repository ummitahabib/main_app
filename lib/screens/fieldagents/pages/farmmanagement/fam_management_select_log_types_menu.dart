import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../utils/assets/images.dart';
import '../../../../utils/strings.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';

class FarmManagementSelectLogTypeMenu extends StatefulWidget {
  final Function(String) selectedLogType;

  const FarmManagementSelectLogTypeMenu({Key? key, required this.selectedLogType}) : super(key: key);

  @override
  _FarmManagementSelectLogTypeMenuState createState() {
    return _FarmManagementSelectLogTypeMenuState();
  }
}

class _FarmManagementSelectLogTypeMenuState extends State<FarmManagementSelectLogTypeMenu> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer logTypesAsync = AsyncMemoizer();
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
    return logTypesAsync.runOnce(() async {
      final data = await getLogTypes();

      List<Widget> logTypeList = [];
      if (data == null || data.data!.isEmpty) {
        logTypeList.add(EmptyListItem(message: logNotCreated));
      } else {
        for (final logType in data.data!) {
          logTypeList.add(
            InkWell(
              onTap: () {
                widget.selectedLogType(logType.types!);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    Image.asset(ImagesAssets.kTree, width: 25.0, height: 25.0, fit: BoxFit.contain),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(logType.types!, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
                  ],
                ),
              ),
            ),
          );
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
