// ignore_for_file: no_default_cases

import 'package:dio/dio.dart';

class DataException implements Exception {
  DataException({required this.message});
  String message = "";
  DataException.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = dioError.message ?? kErrorRequestCancelled;
        break;
      case DioExceptionType.connectionTimeout:
        message = dioError.message ?? kErrorConnectionTimeout;
        break;
      case DioExceptionType.receiveTimeout:
        message = dioError.message ?? kErrorReceiveTimeout;
        break;
      case DioExceptionType.badResponse:
        message = dioError.message ?? _handleError(dioError.response!.statusCode ?? 504);
        break;
      case DioExceptionType.sendTimeout:
        message = dioError.message ?? kErrorSendTimeout;
        break;
      default:
        message = dioError.message ?? kErrorInternetConnection;
        return;
    }
  }

  String _handleError(int statusCode) {
    switch (statusCode) {
      case 400:
        return kErrorBadRequest;
      case 401:
        return kErrorBadRequest;
      case 404:
        return kErrorRequestNotFound;
      case 500:
        return kErrorIntenalServer;
      default:
        return kErrorSomethingWentWrong;
    }
  }

  @override
  String toString() => message;
}

const kErrorRequestCancelled = 'Request Cancelled';
const kErrorConnectionTimeout = 'Connection Timeout';
const kErrorInternetConnection = 'Check your Internet Connection';
const kErrorReceiveTimeout = 'Receive Timeout';
const kErrorSendTimeout = 'Send Timeout';
const kErrorBadRequest = 'Bad Request';
const kErrorRequestNotFound = 'Request Not Found';
const kErrorIntenalServer = 'Internal Server Error';
const kErrorSomethingWentWrong = 'Something Went Wrong';
