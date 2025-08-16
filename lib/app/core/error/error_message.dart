import 'package:dio/dio.dart';

class ErrorMessage {
  static final ErrorMessage instance = ErrorMessage._();

  ErrorMessage._();

  String fromDioException({required DioException exception}) {
    dynamic errorResponse = exception.response?.data;
    if (errorResponse is Map<String, dynamic>) {
      return errorResponse['message'];
    } else {
      return dioExceptionMessage(exceptionType: exception.type);
    }
  }

  String dioExceptionMessage({required DioExceptionType exceptionType}) {
    switch (exceptionType) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timed out. Please check your internet connection.';
      case DioExceptionType.sendTimeout:
        return 'Request timed out while sending data.';
      case DioExceptionType.receiveTimeout:
        return 'Server took too long to respond.';
      case DioExceptionType.badCertificate:
        return 'Untrusted SSL certificate detected.';
      case DioExceptionType.badResponse:
        return 'Received invalid response from the server.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'Unable to connect to the server.';
      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }
}
