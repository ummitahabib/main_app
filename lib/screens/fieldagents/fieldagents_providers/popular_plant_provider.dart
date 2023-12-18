import 'dart:developer';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smat_crow/utils/constants.dart';
import 'package:smat_crow/utils2/colors.dart';
import 'package:smat_crow/utils2/constants.dart';
import 'package:smat_crow/utils2/styles.dart';

import '../../../network/feeds/network/plants_db_operations.dart';
import '../../../pandora/pandora.dart';

class PopularPlantsProvider extends ChangeNotifier {
  final AsyncMemoizer _asyncMemoizer = AsyncMemoizer();
  List<Widget> plantsItem = [];
  final Pandora _pandora = Pandora();
  final controller = PageController();
  bool get mounted => false;

  String _currentId = "";
  String get currentId => _currentId;
  set currentId(String value) {
    _currentId = value;
    notifyListeners();
  }

  Future fetchPopularPlants(BuildContext context) async {
    final data = await getPopularPlants();

    if (data.isNotEmpty) {
      for (int i = 0; i < data.length; i++) {
        plantsItem.add(
          InkWell(
            onTap: () {
              _pandora.logAPPButtonClicksEvent('POPULAR_PLANT_ITEM_CLICKED');
              log(data[i].toString());
              if (data[i] != null) {
                if (kIsWeb) {
                  _pandora.reRouteUser(context, "${ConfigRoute.plantDetails}/${data[i]['id']}", data[i]['id']);
                } else {
                  _pandora.reRouteUser(context, ConfigRoute.plantDetails, data[i]['id']);
                }
              }
            },
            child: SizedBox(
              width: 170,
              height: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: CachedNetworkImage(
                        imageUrl: data[i]['thumbnail_url'],
                        width: 170,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Image.network(DEFAULT_IMAGE),
                        progressIndicatorBuilder: (context, url, progress) => Skeletonizer(
                          child: Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                            color: AppColors.SmatCrowNeuBlue400,
                            elevation: 0,
                            child: const SizedBox(
                              width: 170,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data[i] == null ? '' : data[i]['name'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Styles.smatCrowMediumBody(color: AppColors.SmatCrowNeuBlue900)
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          data[i] == null ? '' : data[i]['scientific_name'],
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Styles.smatCrowSubParagraphRegular(color: AppColors.SmatCrowNeuBlue500),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    }

    notifyListeners();
    return data;
  }
}
