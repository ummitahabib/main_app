import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:one_context/one_context.dart';
import 'package:smat_crow/network/feeds/models/commodity_prices.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/constants.dart';

import '../models/afex_commodity_prices.dart';

Pandora _pandora = Pandora();

Future<CommodityPricesResponse?> getNCXCommodityPrices() async {
  CommodityPricesResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/scrape/get-commodity-prices'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_COMMODITY_PRICES',
      '$BASE_URL/scrape/get-commodity-prices',
      response.statusCode.toString(),
      response.statusCode.toString(),
    );
    result = CommodityPricesResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_COMMODITY_PRICES',
      '$BASE_URL/scrape/get-commodity-prices',
      'FAILED',
      response.statusCode.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_COMMODITY_PRICES',
      '$BASE_URL/scrape/get-commodity-prices',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}

Future<AfexCommodityResponse?> getAFEXCommodityPrices() async {
  AfexCommodityResponse? result;
  final response = await http.get(
    Uri.parse('$BASE_URL/scrape/get-afex-prices'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == HttpStatus.ok) {
    _pandora.logAPIEvent(
      'GET_COMMODITY_PRICES',
      '$BASE_URL/scrape/get-afex-prices',
      response.statusCode.toString(),
      response.statusCode.toString(),
    );
    result = AfexCommodityResponse.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == HttpStatus.unauthorized) {
    _pandora.logAPIEvent(
      'GET_COMMODITY_PRICES',
      '$BASE_URL/scrape/get-commodity-prices',
      'FAILED',
      response.statusCode.toString(),
    );
    await OneContext().showSnackBar(
      builder: (_) => const SnackBar(content: Text('Unauthorized Access')),
    );
  } else {
    _pandora.logAPIEvent(
      'GET_COMMODITY_PRICES',
      '$BASE_URL/scrape/get-afex-prices',
      'FAILED',
      response.statusCode.toString(),
    );
  }
  return result;
}
