class AppError {
  final String message;

  AppError(this.message);
}

class NetworkError extends AppError {
  NetworkError() : super('Network Error');
}

class ServerError extends AppError {
  ServerError() : super('Server Error');
}
