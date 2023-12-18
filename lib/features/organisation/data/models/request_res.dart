class RequestRes {
  dynamic response;
  ErrorRes? error;

  RequestRes({this.response, this.error});

  bool hasError() => error != null;
}

class ErrorRes {
  String message;
  dynamic data;

  ErrorRes({required this.message, this.data});
}
