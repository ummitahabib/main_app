import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../network/crow/farm_manager_operations.dart';
import '../../../../network/crow/models/farm_management/assets/generic_asset_resources.dart';
import '../../../../network/crow/models/farm_management/logs/generic_additional_log_details.dart';
import '../../../widgets/empty_list_item.dart';
import '../../../widgets/list_loader.dart';
import '../../widgets/farm_management_additional_log_item.dart';
import '../../widgets/farm_management_log_media_item.dart';

class FarmManagementAssetImagesPage extends StatefulWidget {
  final int assetId;
  final bool isAsset;

  const FarmManagementAssetImagesPage({Key? key, required this.assetId, required this.isAsset}) : super(key: key);

  @override
  _FarmManagementAssetImagesPageState createState() {
    return _FarmManagementAssetImagesPageState();
  }
}

class _FarmManagementAssetImagesPageState extends State<FarmManagementAssetImagesPage> {
  final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  AssetsResourcesResponse? assetImages;
  List<Widget> assetImagesList = [];
  AdditionalLogDetails? additionalLogDetails;

  // Widget displayPage;

  @override
  void initState() {
    super.initState();
    if (widget.isAsset) {
      findAssetImages(widget.assetId);
    } else {
      fetchAdditionalLogDetails(widget.assetId);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EnhancedFutureBuilder(
      future: (widget.isAsset) ? findAssetImages(widget.assetId) : fetchAdditionalLogDetails(widget.assetId),
      rememberFutureResult: true,
      whenDone: (obj) => _assetImagesResponse(),
      whenError: (error) => const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Text("Unable to load additional log data"),
      ),
      whenNotDone: ListLoader(screenWidth: _screenWidth),
    );
  }

  Future findAssetImages(int assetId) async {
    assetImages = await getAssetsMedia(assetId);

    List<Widget> assetImagesList = [];
    int i = 0;

    if (assetImages != null) {
      if (assetImages!.data.isEmpty) {
        assetImagesList.add(const EmptyListItem(message: 'Asset does not have any Media'));
      } else {
        for (final file in assetImages!.data) {
          ++i;
          assetImagesList.add(FarmManagementLogMediaItem(url: file.url!, intCount: i));
        }
      }
    } else {
      assetImagesList.add(const EmptyListItem(message: 'Asset does not have any Media'));
    }

    if (mounted) {
      setState(() {
        assetImagesList = assetImagesList;
      });
    }

    setState(() {});

    return assetImages;
  }

  Widget _assetImagesResponse() {
    return FarmManagerAdditionalLogDetailsItem(title: "Media", listItems: assetImagesList);
  }

  Future fetchAdditionalLogDetails(int logId) async {
    additionalLogDetails = await getAdditionalLogDetails(logId);

    List<Widget> logFilesList = [];
    int i = 0;

    if (additionalLogDetails!.data.logMedia.isEmpty) {
      logFilesList.add(const EmptyListItem(message: 'Log does not have any Media'));
    } else {
      for (final file in additionalLogDetails!.data.logMedia) {
        ++i;
        logFilesList.add(
          FarmManagementLogMediaItem(
            url: file.url,
            intCount: i,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        assetImagesList = logFilesList;
      });
    }

    setState(() {});

    return additionalLogDetails;
  }
}
