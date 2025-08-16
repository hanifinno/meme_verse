import 'dart:io';

import 'package:dio/dio.dart';

import 'error_message.dart';
import 'exception/data_missing_exception.dart';
import 'exception/model_conversion_exception.dart';
import 'exception/server_exception.dart';
import 'exception/unauthorized_exception.dart';
import 'failures/data_missing_failure.dart';
import 'failures/failure.dart';
import 'failures/model_conversion_failure.dart';
import 'failures/server_failure.dart';
import 'failures/unknown_failure.dart';

class ErrorHandler {
  static Failure handleException(Exception exception) {
    if (exception is DioException) {
      return ServerFailure(
        message: ErrorMessage.instance.fromDioException(exception: exception),
      );
    } else if (exception is SocketException) {
      return ServerFailure(message: exception.message);
    } else if (exception is UnauthorizedException) {
      return UnknownFailure(message: exception.message);
    } else if (exception is DataMissingException) {
      return DataMissingFailure(message: exception.message);
    } else if (exception is ServerException) {
      return ServerFailure(message: exception.message);
    } else if (exception is ModelConversionException) {
      return ModelConversionFailure(message: exception.message);
    } else {
      return UnknownFailure(message: 'Unknwon Error');
    }
  }
}
