import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/farm_management/assets/generic_asset_resources.dart';
import '../../../../network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import '../../../../pandora/pandora.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';
import '../../widgets/farm_management_additional_log_item.dart';
import '../../widgets/farm_management_log_file_item.dart';

class FarmManagementAssetFilesPage extends StatefulWidget {
  final int assetId;
  final bool isAsset;

  const FarmManagementAssetFilesPage({Key? key, required this.assetId, required this.isAsset}) : super(key: key);

  @override
  _FarmManagementAssetFilesPageState createState() {
    return _FarmManagementAssetFilesPageState();
  }
}

class _FarmManagementAssetFilesPageState extends State<FarmManagementAssetFilesPage> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  List<Widget> assetFilesList = [];
  final Pandora _pandora = Pandora();
  AssetsResourcesResponse? assetFiles;
  AdditionalLogDetails? additionalLogDetails;

  // Widget displayPage;

  @override
  void initState() {
    super.initState();
    (widget.isAsset) ? findAssetFiles(widget.assetId) : fetchAdditionalLogDetails(widget.assetId);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: (widget.isAsset) ? findAssetFiles(widget.assetId) : fetchAdditionalLogDetails(widget.assetId),
      rememberFutureResult: true,
      whenDone: (obj) => _assetFilesResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load additional log data"),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future findAssetFiles(int assetId) async {
    assetFiles = await getAssetsFiles(assetId);

    List<Widget> assetFilesList = [];
    int i = 0;

    if (assetFiles != null) {
      if (assetFiles!.data.isEmpty) {
        assetFilesList.add(const EmptyListItem(message: 'Log does not have any Files'));
      } else {
        for (final file in assetFiles!.data) {
          ++i;
          assetFilesList.add(
            FarmManagementLogFileItem(
              url: file.url ?? "",
              intCount: i,
              pandora: _pandora,
            ),
          );
        }
      }
    } else {
      assetFilesList.add(const EmptyListItem(message: 'Log does not have any Files'));
    }

    if (mounted) {
      setState(() {
        assetFilesList = assetFilesList;
      });
    }

    setState(() {});

    return assetFiles;
  }

  Future fetchAdditionalLogDetails(int logId) async {
    additionalLogDetails = await getAdditionalLogDetails(logId);

    List<Widget> logFilesList = [];
    int i = 0;

    if (additionalLogDetails!.data.logFiles.isEmpty) {
      logFilesList.add(const EmptyListItem(message: 'Log does not have any Files'));
    } else {
      for (final file in additionalLogDetails!.data.logFiles) {
        ++i;
        logFilesList.add(
          FarmManagementLogFileItem(
            url: file.url,
            intCount: i,
            pandora: _pandora,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        assetFilesList = logFilesList;
      });
    }

    setState(() {});

    return additionalLogDetails;
  }

  Widget _assetFilesResponse() {
    return FarmManagerAdditionalLogDetailsItem(title: "Files", listItems: assetFilesList);
  }
}
