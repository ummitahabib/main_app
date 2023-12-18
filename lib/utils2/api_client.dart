// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:smat_crow/pandora/pandora.dart';
import 'package:smat_crow/utils/session.dart';
import 'package:smat_crow/utils2/data_exception.dart';

class ApiClient {
  static const String devBaseUrl = 'https://sandbox.airsmat.com:444/api';
  static const String farmProbe = "https://farmprobe.airsmat.com/api";
  static const String prodBaseUrl = 'https://api.airsmat.com/api';
  static bool isLiveEnvironment = true;
  final String baseUrl = isLiveEnvironment ? prodBaseUrl : devBaseUrl;
  late String accessToken;

  bool showError = false;

  ApiClient({
    this.showError = true,
    String? accessToken,
  }) : accessToken = accessToken ?? Session.SessionToken;

  Future<dynamic> get(String url, {Map<String, dynamic>? queries}) async {
    var responseJson;
    try {
      final token = await Pandora().getFromSharedPreferences("token");

      final response = await _getDio().get(
        url,
        queryParameters: queries,
        options: Options(
          headers: {
            'Content-type': 'application/json',
            "Accept": "application/json",
            'Authorization': 'Bearer $token',
          },
        ),
      );
      responseJson = _returnResponse(response);
    } on FirebaseException catch (e) {
      throw FetchDataException(e.message ?? e.stackTrace.toString());
    } on DioException catch (e) {
      final msg = DataException.fromDioError(e);
      if (e.response == null || e.response!.data == null) {
        throw Exception(msg.message);
      } else {
        throw processError(e.response!);
      }
    }
    return responseJson;
  }

  Future<dynamic> delete(String url, {Map<String, dynamic>? queries}) async {
    log("Url: $url");
    log("token: $accessToken");
    final token = await Pandora().getFromSharedPreferences("token");
    var responseJson;
    try {
      final response = await _getDio().delete(
        url,
        data: queries,
        options: Options(
          headers: {'Content-type': 'application/json', "Accept": "application/json", 'Authorization': 'Bearer $token'},
        ),
      );

      responseJson = _returnResponse(response);
    } on FirebaseException catch (e) {
      throw FetchDataException(e.message ?? e.stackTrace.toString());
    } on DioException catch (e) {
      final msg = DataException.fromDioError(e);
      if (e.response == null || e.response!.data == null) {
        throw Exception(msg.message);
      } else {
        throw processError(e.response!);
      }
    }
    return responseJson;
  }

  Future<dynamic> post(
    String url, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    var responseJson;
    final token = await Pandora().getFromSharedPreferences("token");
    try {
      final response = await _getDio().post(
        url,
        options: options ??
            Options(
              headers: {
                'Content-type': 'application/json',
                "Accept": "application/json",
                'Authorization': 'Bearer $token'
              },
            ),
        data: data,
      );

      responseJson = _returnResponse(response);
    } on FirebaseException catch (e) {
      throw FetchDataException(e.message ?? e.stackTrace.toString());
    } on DioException catch (e) {
      final msg = DataException.fromDioError(e);

      if (e.response == null || e.response!.data == null) {
        throw Exception(msg.message);
      } else {
        throw processError(e.response!);
      }
    } on TimeoutException catch (e) {
      log(e.toString());
    }
    return responseJson;
  }

  Future<dynamic> upload(
    String url, {
    required Map<String, dynamic> data,
  }) async {
    var responseJson;
    final token = await Pandora().getFromSharedPreferences("token");
    try {
      final response = await _getDio().put(
        url,
        options: Options(
          headers: {
            "content-type": "multipart/form-data",
            'Authorization': 'Bearer $token',
          },
        ),
        data: FormData.fromMap(data),
      );

      responseJson = _returnResponse(response);
    } on FirebaseException {
      throw FetchDataException('No Internet connection');
    } on DioException catch (e) {
      final msg = DataException.fromDioError(e);
      if (e.response == null || e.response!.data == null) {
        throw Exception(msg.message);
      } else {
        throw processError(e.response!);
      }
    }
    return responseJson;
  }

  Future<dynamic> put(
    String url, {
    Map<String, dynamic>? data,
    Options? options,
  }) async {
    var responseJson;
    try {
      final token = await Pandora().getFromSharedPreferences("token");
      final response = await _getDio().put(
        url,
        options: options ??
            Options(
              headers: {
                'Content-type': 'application/json',
                "Accept": "application/json",
                'Authorization': 'Bearer $token',
              },
            ),
        data: data,
      );

      responseJson = _returnResponse(response);
    } on FirebaseException catch (e) {
      throw FetchDataException(e.message ?? e.stackTrace.toString());
    } on DioException catch (e) {
      final msg = DataException.fromDioError(e);
      if (e.response == null || e.response!.data == null) {
        throw Exception(msg.message);
      } else {
        throw processError(e.response!);
      }
    }
    return responseJson;
  }

  dynamic _returnResponse(Response response) {
    try {
      if (!isResponseOk(response.statusCode!)) {
        throw processError(response);
      }

      return response.data ?? true;
    } on DioException catch (e) {
      final msg = DataException.fromDioError(e);
      if (e.response == null || e.response!.data == null) {
        throw Exception(msg.message);
      } else {
        throw processError(e.response!);
      }
    }
  }

  bool isResponseOk(int statusCode) {
    return statusCode >= 200 && statusCode <= 299;
  }

  dynamic processError(Response response) {
    return response.data["data"] ??
        response.data["message"] ??
        response.data["error_description"] ??
        response.data["error"] ??
        response.data["status"] ??
        "Server error. Please contact support for help.";
  }

  Dio _getDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30000),
        receiveTimeout: const Duration(seconds: 30000),
      ),
    );
    if (kDebugMode) {
      dio.interceptors.addAll([
        LogInterceptor(requestBody: true, responseBody: true),
      ]);
    }
    return dio;
  }
}

class AppException implements Exception {
  // ignore: type_annotate_public_apis
  final message;
  final _prefix;

  AppException([this.message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String message = ""]) : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidTokenException extends AppException {
  InvalidTokenException([message]) : super(message, "Invalid Token: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message = ""]) : super(message, "Invalid Input: ");
}

class ServerErrorException extends AppException {
  ServerErrorException([
    String message =
        "Oh no! Something bad happened but our technical staff have been automatically notified and will be looking into this with the utmost urgency",
  ]) : super(message, "Notice");
}

class GeneralErrorException extends AppException {
  GeneralErrorException([
    String message =
        "Oh no! Something bad happened but our technical staff have been automatically notified and will be looking into this with the utmost urgency",
  ]) : super(message, "Notice");
}
