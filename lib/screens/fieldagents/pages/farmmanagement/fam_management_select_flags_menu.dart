import 'package:async/async.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/material.dart';
import 'package:smat_crow/network/crow/farm_manager_operations.dart';
import 'package:smat_crow/pandora/pandora.dart';

import '../../../../utils/strings.dart';
import '../../../../utils/styles.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';

class FarmManagementSelectFlagsMenu extends StatefulWidget {
  final Function(String) selectedFlag;

  const FarmManagementSelectFlagsMenu({Key? key, required this.selectedFlag}) : super(key: key);

  @override
  _FarmManagementSelectFlagsMenuState createState() {
    return _FarmManagementSelectFlagsMenuState();
  }
}

class _FarmManagementSelectFlagsMenuState extends State<FarmManagementSelectFlagsMenu> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  final AsyncMemoizer flagsTypesAsync = AsyncMemoizer();
  final Pandora pandora = Pandora();
  List<Widget> farmFlagsItem = [];

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
        child: Text(unableToFetchFlag),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future getFarmManagementLogTypes() async {
    return flagsTypesAsync.runOnce(() async {
      final data = await getLogFlags();
      List<Widget> flagsList = [];
      if (data == null || data.data.isEmpty) {
        flagsList.add(EmptyListItem(message: noFlag));
      } else {
        for (final flag in data.data) {
          flagsList.add(
            InkWell(
              onTap: () {
                widget.selectedFlag(flag.flag!);
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 13),
                child: Row(
                  children: [
                    Styles.flagOutline(),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(flag.flag!, overflow: TextOverflow.fade, style: Styles.textStyleGridColor()),
                  ],
                ),
              ),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          farmFlagsItem = flagsList;
        });
      }
    });
  }

  Widget _showResponse() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: farmFlagsItem.length,
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: 8,
        );
      },
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Align(alignment: Alignment.topCenter, child: farmFlagsItem[index]);
      },
    );
  }
}
