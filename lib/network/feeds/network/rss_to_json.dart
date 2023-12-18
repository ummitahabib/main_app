import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:smat_crow/pandora/pandora.dart';
import 'package:xml2json/xml2json.dart';

Pandora _pandora = Pandora();

Future<List> rssToJson(
  String category, {
  String baseUrl = 'https://news.google.com/rss/search?q=',
}) async {
  final client = http.Client();
  final myTransformer = Xml2Json();

  try {
    final response = await client.get(
      Uri.parse('$baseUrl$category&hl=en-NG&gl=NG&ceid=NG:en'),
      headers: {
        "Access-Control-Allow-Origin": "*", // Required for CORS support to work
        "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        "Access-Control-Allow-Headers":
            "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        "Access-Control-Allow-Methods": "GET, OPTIONS"
      },
    );
    _pandora.logAPIEvent(
      'GET_NEWS_FEED',
      category,
      response.statusCode.toString(),
      response.statusCode.toString(),
    );
    log(response.body);
    myTransformer.parse(response.body);
  } catch (e) {
    log(e.toString());
    _pandora.logAPIEvent(
      'GET_NEWS_FEED',
      category,
      "error",
      '$e',
    );
  }
  final json = myTransformer.toGData();
  final result = jsonDecode(json)['rss']['channel']['item'];
  if (result is! List<dynamic>) {
    return [result];
  }
  return result;
}
