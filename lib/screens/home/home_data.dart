import 'package:flutter/material.dart';

import '../../network/feeds/network/rss_to_json.dart';

class HomeDataProvider extends ChangeNotifier {
  Map<String, List> newsData = <String, List>{};
  bool isLoading = true;

  getData() async {
    await Future.wait([
      rssToJson('agriculture'),
      rssToJson('agriculture+in+nigeria'),
      rssToJson('agriculture+in+africa'),
      rssToJson('agriculture+in+north+america'),
      rssToJson('agriculture+in+south+america'),
      rssToJson('agriculture+in+europe'),
      rssToJson('agriculture+in+middle+east'),
      rssToJson('agriculture+in+asia'),
      rssToJson('agriculture+in+australia'),
    ]).then((value) {
      newsData['agriculture'] = value[0];
      newsData['nigeria'] = value[1];
      newsData['africa'] = value[2];
      newsData['north-america'] = value[3];
      newsData['south-america'] = value[4];
      newsData['europe'] = value[5];
      newsData['middle-east'] = value[6];
      newsData['asia'] = value[7];
      newsData['australia'] = value[8];
      //isLoading = false;
      //notifyListeners();
    }).whenComplete(() {
      isLoading = false;
      notifyListeners();
      // ignore: argument_type_not_assignable_to_error_handler
    }).catchError((err) {
      debugPrint('Error$err');
    }).onError((error, stackTrace) {});

    // timeout(const Duration(seconds: 10)).whenComplete(() {
    //   isLoading = false;
    //   notifyListeners();
    // });
  }
}
