import 'package:flutter/cupertino.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:smat_crow/network/feeds/models/paginated_plants_response.dart' as pResponse;

import '../../../network/feeds/network/plants_db_operations.dart';

class AllPlantsProvider extends ChangeNotifier {
  List<Widget> plantsItem = [];
  static const _pageSize = 10;
  final PagingController<int, pResponse.Datum> _pagingController = PagingController(firstPageKey: 0);

  Future<void> Function(int pageKey) get fetchPage => _fetchPage;

  PagingController<int, pResponse.Datum> get pagingController => _pagingController;

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await getPaginatedPlants(pageKey);

      if (newItems != null) {
        final isLastPage = newItems.data.length < _pageSize;
        if (isLastPage) {
          _pagingController.appendLastPage(newItems.data);
        } else {
          final nextPageKey = pageKey + newItems.data.length;
          _pagingController.appendPage(newItems.data, nextPageKey);
        }
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }
}
