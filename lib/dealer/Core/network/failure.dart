import 'package:dio/dio.dart';

class Failure {
  final String massageError;
  final int? statusCode;
  Failure({required this.massageError, this.statusCode});

  factory Failure.handleExcaption(Object e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Failure(massageError: 'poor connection , try again');
        case DioExceptionType.badResponse:
          if (e.response!.statusCode == 400) {
            return Failure(massageError: 'error folani');
          } else {
            return Failure(massageError: 'error 3lani');
          }
        case DioExceptionType.cancel:
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionError:
          return Failure(massageError: 'connection network has an error');
        case DioExceptionType.unknown:
          return Failure(massageError: 'unknow');
      }
    } else {
      return Failure(massageError: 'unknow');
    }
  }
}
